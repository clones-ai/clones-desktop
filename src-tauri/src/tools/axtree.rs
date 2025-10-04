//! AxTree tool integration for running and polling the dump-tree binary.
//!
//! This module manages the download, initialization, and polling of the dump-tree binary for accessibility tree extraction.

use crate::tools::helpers::lock_with_timeout;
use log::info;
use serde_json::{json, Value};
use std::process::Command;
use std::sync::{Arc, Mutex, OnceLock};
use std::thread;
use std::time::{Duration, Instant};

static RECORDING_MODE: OnceLock<Arc<Mutex<bool>>> = OnceLock::new();
static LAST_INTERACTION_TIME: OnceLock<Arc<Mutex<Option<Instant>>>> = OnceLock::new();

/// Recursively converts floating point coordinates to integers in JSON objects
/// This ensures compatibility with the backend API which expects u32 coordinates
fn convert_coordinates_to_integers(obj: &mut serde_json::Map<String, Value>) {
    // Convert bbox coordinates
    if let Some(bbox) = obj.get_mut("bbox").and_then(|v| v.as_object_mut()) {
        for coord_key in ["x", "y", "width", "height"] {
            if let Some(coord_val) = bbox.get_mut(coord_key) {
                if let Some(float_val) = coord_val.as_f64() {
                    *coord_val = json!(float_val.round().max(0.0) as u32);
                }
            }
        }
    }

    // Recursively process children
    if let Some(children) = obj.get_mut("children").and_then(|v| v.as_array_mut()) {
        for child in children {
            if let Some(child_obj) = child.as_object_mut() {
                convert_coordinates_to_integers(child_obj);
            }
        }
    }

    // Process data.tree for event format
    if let Some(data) = obj.get_mut("data").and_then(|v| v.as_object_mut()) {
        if let Some(tree) = data.get_mut("tree").and_then(|v| v.as_array_mut()) {
            for app in tree {
                if let Some(app_obj) = app.as_object_mut() {
                    convert_coordinates_to_integers(app_obj);
                }
            }
        }
    }
}

/// Triggers an immediate AX tree dump when significant user interaction occurs
pub fn trigger_ui_dump_on_interaction<R: tauri::Runtime>(
    _app: tauri::AppHandle<R>,
) -> Result<(), String> {
    // Only trigger during recording mode
    let is_recording = {
        if let Some(recording_mode) = RECORDING_MODE.get() {
            let lock = lock_with_timeout(recording_mode, Duration::from_secs(1));
            if let Some(recording) = lock {
                *recording
            } else {
                false
            }
        } else {
            false
        }
    };

    if !is_recording {
        return Ok(());
    }

    // Debounce: avoid multiple captures within 500ms
    let last_time = LAST_INTERACTION_TIME.get_or_init(|| Arc::new(Mutex::new(None)));
    if let Ok(mut last) = last_time.lock() {
        let now = Instant::now();
        if let Some(last_instant) = *last {
            if now.duration_since(last_instant) < Duration::from_millis(500) {
                return Ok(()); // Skip this capture, too recent
            }
        }
        *last = Some(now);
    }

    info!("[AxTree] Triggering UI dump due to user interaction");

    // Run single dump with no-focus-steal
    thread::spawn(move || {
        // Try local script first, fallback to PyInstaller binary
        let (script_filename, script_command) = if cfg!(target_os = "windows") {
            ("dump-tree-windows.py", "python3")
        } else {
            ("dump-tree-macos.py", "python3")
        };

        let script_path_exe = std::env::current_exe()
            .ok()
            .and_then(|exe| exe.parent().map(|p| p.join("axtree").join(script_filename)));
        let script_path_cwd = std::env::current_dir()
            .ok()
            .map(|p| p.join("axtree").join(script_filename));

        info!("[AxTree] Checking script paths:");
        if let Some(path) = &script_path_exe {
            info!(
                "[AxTree] - Exe relative: {} (exists: {})",
                path.display(),
                path.exists()
            );
        }
        if let Some(path) = &script_path_cwd {
            info!(
                "[AxTree] - Cwd relative: {} (exists: {})",
                path.display(),
                path.exists()
            );
        }

        let script_path = script_path_cwd.filter(|p| p.exists());

        let script = match script_path {
            Some(s) => s,
            None => {
                info!("[AxTree] Script not found: {}", script_filename);
                return; // No script found
            }
        };

        info!("[AxTree] Using local script: {}", script.display());
        let mut command = Command::new(script_command);
        command.arg(script);

        #[cfg(windows)]
        {
            use std::os::windows::process::CommandExt;
            command.creation_flags(0x08000000);
        }

        // Use timeout to prevent hanging
        let child = command
            .arg("-e")
            .arg("--display-index")
            .arg("0") // TODO: Calculate actual display index used for recording
            .arg("--no-focus-steal")
            .stdout(std::process::Stdio::piped())
            .stderr(std::process::Stdio::piped())
            .spawn();

        let output = match child {
            Ok(child) => {
                let child_id = child.id();
                let (tx, rx) = std::sync::mpsc::channel();

                thread::spawn(move || {
                    let result = child.wait_with_output();
                    let _ = tx.send(result);
                });

                // Wait maximum 5 seconds for completion (interactions are less time-critical)
                match rx.recv_timeout(Duration::from_secs(5)) {
                    Ok(result) => result,
                    Err(_) => {
                        // Kill the process forcefully
                        info!(
                            "[AxTree] Timeout reached, killing dump-tree process {}",
                            child_id
                        );
                        #[cfg(unix)]
                        {
                            let _ = std::process::Command::new("kill")
                                .arg("-9")
                                .arg(child_id.to_string())
                                .output();
                        }
                        #[cfg(windows)]
                        {
                            let _ = std::process::Command::new("taskkill")
                                .arg("/PID")
                                .arg(child_id.to_string())
                                .arg("/F")
                                .output();
                        }
                        Err(std::io::Error::new(
                            std::io::ErrorKind::TimedOut,
                            "dump-tree process timed out after 5 seconds",
                        ))
                    }
                }
            }
            Err(e) => Err(e),
        };

        match output {
            Ok(output) => {
                if let Ok(stdout) = String::from_utf8(output.stdout) {
                    for line in stdout.lines() {
                        if let Ok(mut json) = serde_json::from_str::<Value>(&line) {
                            if let Some(obj) = json.as_object_mut() {
                                // Check if Clones app is focused and skip if so
                                let should_skip = if let Some(data) =
                                    obj.get("data").and_then(|v| v.as_object())
                                {
                                    if let Some(focused_app) =
                                        data.get("focused_app").and_then(|v| v.as_object())
                                    {
                                        // Check bundle_id first
                                        if let Some(bundle_id) =
                                            focused_app.get("bundle_id").and_then(|v| v.as_str())
                                        {
                                            bundle_id == "ai.clones"
                                        }
                                        // If bundle_id is null or missing, check name
                                        else if let Some(name) =
                                            focused_app.get("name").and_then(|v| v.as_str())
                                        {
                                            name == "clones_desktop" || name == "clones"
                                        } else {
                                            false
                                        }
                                    } else {
                                        false
                                    }
                                } else {
                                    false
                                };

                                if should_skip {
                                    info!("[AxTree] Skipping interaction - Clones app is focused");
                                    continue;
                                }

                                obj.insert("event".to_string(), json!("axtree_interaction"));

                                // Convert floating point coordinates to integers for backend compatibility
                                convert_coordinates_to_integers(obj);

                                // Debug log the final JSON to check coordinate conversion
                                if log::log_enabled!(log::Level::Debug) {
                                    if let Ok(json_str) = serde_json::to_string(obj) {
                                        log::debug!(
                                            "[AxTree] Final JSON after coordinate conversion: {}",
                                            json_str.chars().take(200).collect::<String>()
                                        );
                                    }
                                }

                                let _ = crate::core::record::log_input(serde_json::Value::Object(
                                    obj.clone(),
                                ));
                            }
                        }
                    }
                }
            }
            Err(e) => {
                info!("[AxTree] Error in interaction dump: {}", e);
            }
        }
    });

    Ok(())
}

/// Sets the recording mode for AXTree polling.
/// When recording is true, polling frequency is reduced to avoid focus stealing.
pub fn set_recording_mode(recording: bool) -> Result<(), String> {
    info!("[AxTree] Setting recording mode: {}", recording);

    let recording_mode = RECORDING_MODE.get_or_init(|| Arc::new(Mutex::new(false)));
    let lock = lock_with_timeout(recording_mode, Duration::from_secs(2));
    if let Some(mut mode) = lock {
        *mode = recording;
        Ok(())
    } else {
        Err("Could not acquire recording mode lock".to_string())
    }
}
