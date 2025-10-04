//! Tauri commands for initializing and checking external tool binaries (FFmpeg, Clones Quality Agent).
//!
//! This module provides commands to initialize required binaries in parallel and check their status.
//! AXTree functionality uses local Python scripts and doesn't require initialization.

use crate::tools::helpers::lock_with_timeout;
use crate::tools::{cqa, ffmpeg};
use log::error;
use serde_json;
use std::sync::{Arc, Mutex};
use std::thread;
use tauri::Emitter;

/// Initializes all required tool binaries (FFmpeg, Clones Quality Agent) in parallel threads.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle` for emitting errors to the frontend.
///
/// # Returns
/// * `Ok(())` if all tools were initialized (errors are emitted as events).
#[tauri::command]
pub async fn init_tools(app: tauri::AppHandle) -> Result<(), String> {
    // Create a vector to store thread handles
    let mut handles = Vec::new();

    // Create shared error storage
    let errors = Arc::new(Mutex::new(Vec::new()));

    // Spawn thread for FFmpeg initialization
    {
        let errors = Arc::clone(&errors);
        let handle = thread::spawn(move || {
            if let Err(e) = ffmpeg::init_ffmpeg_and_ffprobe() {
                let lock = lock_with_timeout(&errors, std::time::Duration::from_secs(2));
                if let Some(mut errors) = lock {
                    errors.push(format!("Failed to initialize FFmpeg/FFprobe: {}", e));
                } else {
                    log::error!("[Init Tools] Could not acquire error lock for FFmpeg/FFprobe");
                }
            }
        });
        handles.push(handle);
    }
    // Spawn thread for Clones Quality Agent initialization
    {
        let errors = Arc::clone(&errors);
        let handle = thread::spawn(move || {
            if let Err(e) = cqa::init_cqa() {
                let lock = lock_with_timeout(&errors, std::time::Duration::from_secs(2));
                if let Some(mut errors) = lock {
                    errors.push(format!("Failed to initialize Clones Quality Agent: {}", e));
                } else {
                    log::error!(
                        "[Init Tools] Could not acquire error lock for Clones Quality Agent"
                    );
                }
            }
        });
        handles.push(handle);
    }

    // Wait for all threads to complete
    for handle in handles {
        if let Err(e) = handle.join() {
            error!("Thread panicked: {:?}", e);
        }
    }

    // Check if there were any errors
    let errors = match lock_with_timeout(&errors, std::time::Duration::from_secs(2)) {
        Some(errors) => errors,
        None => {
            log::error!("[Init Tools] Could not acquire error lock for final check");
            return Ok(());
        }
    };
    if !errors.is_empty() {
        for err in errors.iter() {
            error!("{}", err);
        }
        let _ = app.emit(
            "init_tools_errors",
            serde_json::json!({
                "errors": errors.to_vec()
            }),
        );
    }

    Ok(())
}

/// Checks the initialization status of all required tool binaries.
///
/// # Returns
/// * `Ok(serde_json::Value)` with a map of tool names to their status (true/false).
#[tauri::command]
pub async fn check_tools() -> Result<serde_json::Value, String> {
    // Return the status of each tool
    Ok(serde_json::json!({
        "ffmpeg": ffmpeg::FFMPEG_PATH.get().is_some(),
        "ffprobe": ffmpeg::FFPROBE_PATH.get().is_some(),
        "cqa": cqa::CQA_PATH.get().is_some()
    }))
}
