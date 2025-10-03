//! Tauri commands for managing user settings (upload consent, onboarding).
//!
//! This module provides commands to get and set user preferences stored in the settings file.

use crate::utils::settings::Settings;
use tauri::AppHandle;

#[tauri::command]
pub fn get_upload_data_allowed(app: AppHandle) -> bool {
    Settings::load(&app).upload_confirmed
}

/// Sets whether the user has allowed data upload.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle` for accessing settings.
/// * `confirmed` - Whether upload is allowed.
///
/// # Returns
/// * `Ok(())` if the setting was saved.
/// * `Err` if saving failed.
#[tauri::command]
pub fn set_upload_data_allowed(app: AppHandle, confirmed: bool) -> Result<(), String> {
    let mut settings = Settings::load(&app);
    settings.upload_confirmed = confirmed;
    settings.save(&app)
}
