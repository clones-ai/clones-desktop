//! Input event listening and logging utilities for capturing keyboard, mouse, and joystick events across platforms.

use crate::core::record;
use crate::tools::helpers::lock_with_timeout;
use log::{error, info};
use rdev::{listen, Event as RdevEvent, EventType as RdevEventType};
use serde::Serialize;
use std::{
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread::{self, JoinHandle},
};
use tauri::Emitter;
use tauri::Runtime;

/// A listener for input events (keyboard, mouse, joystick) that can be started and stopped.
pub struct InputListener {
    running: Arc<AtomicBool>,
    threads: Vec<JoinHandle<()>>,
}

impl InputListener {
    /// Creates a new `InputListener` instance.
    pub fn new() -> Self {
        Self {
            running: Arc::new(AtomicBool::new(true)),
            threads: Vec::new(),
        }
    }

    /// Stops the input listener and clears all threads.
    pub fn stop(&mut self) {
        self.running.store(false, Ordering::SeqCst);
        // Don't wait for threads since they might be blocked in rdev listen()
        self.threads.clear();
    }
}

impl Drop for InputListener {
    /// Ensures the input listener is stopped when dropped.
    fn drop(&mut self) {
        self.stop();
    }
}

// Global state for input listening
lazy_static::lazy_static! {
    static ref INPUT_LISTENER_STATE: Arc<Mutex<Option<InputListener>>> = Arc::new(Mutex::new(None));
}

/// Represents a generic input event (keyboard, mouse, joystick) with event type and data.
#[derive(Debug, Clone, Serialize)]
pub struct InputEvent {
    pub event: String,
    pub data: serde_json::Value,
}

impl InputEvent {
    /// Creates a new `InputEvent` with the given event name and data.
    ///
    /// # Arguments
    /// * `event` - The event type as a string (e.g., "keydown", "mousemove").
    /// * `data` - The event data as a JSON value.
    pub fn new(event: &str, data: serde_json::Value) -> Self {
        Self {
            event: event.to_string(),
            data,
        }
    }

    /// Converts the input event to a log entry with a timestamp.
    pub fn to_log_entry(&self) -> serde_json::Value {
        serde_json::json!({
            "event": self.event,
            "data": self.data,
            "time": chrono::Local::now().timestamp_millis()
        })
    }
}

/// Starts the global input listener, capturing and emitting input events to the frontend and logging them.
///
/// # Arguments
/// * `app_handle` - The Tauri application handle for emitting events.
///
/// # Returns
/// * `Ok(())` if the listener was started successfully.
/// * `Err` if an error occurred.
pub fn start_input_listener<R: Runtime>(app_handle: tauri::AppHandle<R>) -> Result<(), String> {
    info!("[Input] Starting input listener");
    // Check if already listening
    let lock = lock_with_timeout(&INPUT_LISTENER_STATE, std::time::Duration::from_secs(2));
    let mut state = match lock {
        Some(state) => state,
        None => return Ok(()), // Already listening
    };

    let mut input_listener = InputListener::new();
    let running = input_listener.running.clone();
    let other_app_handle = app_handle.clone();

    // Platform-specific input handling
    // For Windows: use multiinput for all input events (mouse, keyboard, joystick)
    #[cfg(target_os = "windows")]
    {
        use multiinput::*;
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let mut manager = RawInputManager::new().unwrap();
            manager.register_devices(DeviceType::Joysticks(XInputInclude::True));
            manager.register_devices(DeviceType::Keyboards);
            manager.register_devices(DeviceType::Mice);

            while running_clone.load(Ordering::SeqCst) {
                if let Some(event) = manager.get_event() {
                    let input_event = match event {
                        RawEvent::KeyboardEvent(_device_id, key, state) => match state {
                            State::Pressed => Some(InputEvent::new(
                                "keydown",
                                serde_json::json!({
                                    "key": format!("{:?}", key)
                                }),
                            )),
                            State::Released => Some(InputEvent::new(
                                "keyup",
                                serde_json::json!({
                                    "key": format!("{:?}", key)
                                }),
                            )),
                        },
                        RawEvent::MouseMoveEvent(_device_id, x, y) => Some(InputEvent::new(
                            "mousedelta",
                            serde_json::json!({
                                "x": x,
                                "y": y
                            }),
                        )),
                        RawEvent::MouseButtonEvent(_device_id, button, state) => {
                            Some(InputEvent::new(
                                match state {
                                    State::Pressed => "mousedown",
                                    State::Released => "mouseup",
                                },
                                serde_json::json!({
                                    "button": format!("{:?}", button)
                                }),
                            ))
                        }
                        RawEvent::MouseWheelEvent(_device_id, delta) => Some(InputEvent::new(
                            "mousewheel",
                            serde_json::json!({
                                "delta": delta
                            }),
                        )),
                        RawEvent::JoystickButtonEvent(device_id, button, state) => {
                            Some(InputEvent::new(
                                match state {
                                    State::Pressed => "joystickdown",
                                    State::Released => "joystickup",
                                },
                                serde_json::json!({
                                    "id": device_id,
                                    "button": button
                                }),
                            ))
                        }
                        RawEvent::JoystickAxisEvent(device_id, axis, value) => {
                            Some(InputEvent::new(
                                "joystickaxis",
                                serde_json::json!({
                                    "id": device_id,
                                    "axis": format!("{:?}", axis),
                                    "value": value
                                }),
                            ))
                        }
                        _ => None,
                    };

                    if let Some(event) = input_event {
                        if let Err(e) = other_app_handle.emit("input-event", &event) {
                            error!("Failed to emit input event: {}", e);
                        }
                        // Log the input event
                        let _ = record::log_input(event.to_log_entry());
                    }
                }
            }
        });
        input_listener.threads.push(handle);

        // For Windows, we also need a separate rdev listener for absolute mouse position
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let callback = move |event: RdevEvent| {
                if let RdevEventType::MouseMove { x, y } = event.event_type {
                    let input_event = InputEvent::new(
                        "mousemove",
                        serde_json::json!({
                            "x": x,
                            "y": y
                        }),
                    );
                    // Log the mouse move event
                    let _ = record::log_input(input_event.to_log_entry());
                }
            };

            if let Err(error) = listen(move |event| {
                if !running_clone.load(Ordering::SeqCst) {
                    return;
                }
                callback(event);
            }) {
                info!("Error: {:?}", error)
            }
        });
        input_listener.threads.push(handle);
    }

    // For non-Windows platforms: use a single rdev instance for all events
    #[cfg(not(target_os = "windows"))]
    {
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let callback = move |event: RdevEvent| {
                let input_event = match event.event_type {
                    RdevEventType::KeyPress(key) => Some(InputEvent::new(
                        "keydown",
                        serde_json::json!({
                            "key": format!("{:?}", key)
                        }),
                    )),
                    RdevEventType::KeyRelease(key) => Some(InputEvent::new(
                        "keyup",
                        serde_json::json!({
                            "key": format!("{:?}", key)
                        }),
                    )),
                    RdevEventType::ButtonPress(button) => Some(InputEvent::new(
                        "mousedown",
                        serde_json::json!({
                            "button": format!("{:?}", button)
                        }),
                    )),
                    RdevEventType::ButtonRelease(button) => Some(InputEvent::new(
                        "mouseup",
                        serde_json::json!({
                            "button": format!("{:?}", button)
                        }),
                    )),
                    RdevEventType::Wheel {
                        delta_x: _,
                        delta_y,
                    } => Some(InputEvent::new(
                        "mousewheel",
                        serde_json::json!({
                            "delta": delta_y as f32
                        }),
                    )),
                    RdevEventType::MouseMove { x, y } => Some(InputEvent::new(
                        "mousemove",
                        serde_json::json!({
                            "x": x,
                            "y": y
                        }),
                    )),
                };

                if let Some(event) = input_event {
                    if let Err(e) = other_app_handle.emit("input-event", &event) {
                        error!("Failed to emit input event: {}", e);
                    }
                    // Log the input event
                    let _ = record::log_input(event.to_log_entry());
                }
            };

            if let Err(error) = listen(move |event| {
                if !running_clone.load(Ordering::SeqCst) {
                    return;
                }
                callback(event);
            }) {
                info!("Error: {:?}", error)
            }
        });
        input_listener.threads.push(handle);
    }

    *state = Some(input_listener);
    Ok(())
}

/// Stops the global input listener and cleans up resources.
///
/// # Returns
/// * `Ok(())` if the listener was stopped successfully.
/// * `Err` if an error occurred.
pub fn stop_input_listener() -> Result<(), String> {
    info!("[Input] Stopping input listener");
    let lock = lock_with_timeout(&INPUT_LISTENER_STATE, std::time::Duration::from_secs(2));
    let mut state = match lock {
        Some(state) => state,
        None => return Ok(()), // Already stopped
    };
    if let Some(mut listener) = state.take() {
        listener.stop();
    }
    info!("[Input] Input listener stopped");
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn test_input_event_new() {
        let event_name = "test_event";
        let event_data = json!({ "key": "value" });
        let input_event = InputEvent::new(event_name, event_data.clone());

        assert_eq!(input_event.event, event_name);
        assert_eq!(input_event.data, event_data);
    }

    #[test]
    fn test_input_event_to_log_entry() {
        let event_name = "log_event";
        let event_data = json!({ "detail": "some_info" });
        let input_event = InputEvent::new(event_name, event_data.clone());

        let log_entry = input_event.to_log_entry();

        assert_eq!(log_entry["event"], event_name);
        assert_eq!(log_entry["data"], event_data);
        assert!(log_entry["time"].is_number());

        let current_time = chrono::Local::now().timestamp_millis();
        let log_time = log_entry["time"].as_i64().unwrap();
        // Allow a small difference, e.g., 5 seconds (5000 ms)
        assert!(
            (current_time - log_time).abs() < 5000,
            "Timestamp is not recent"
        );
    }
}
