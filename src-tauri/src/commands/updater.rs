use serde::{Deserialize, Serialize};
use tauri::AppHandle;
use tauri_plugin_updater::UpdaterExt;

#[derive(Debug, Serialize, Deserialize)]
pub struct UpdateInfo {
    update_available: bool,
    version: Option<String>,
    date: Option<String>,
    body: Option<String>,
}

/// Check for updates using Tauri's secure updater
#[tauri::command]
pub async fn check_for_update(app: AppHandle) -> Result<UpdateInfo, String> {
    match app.updater() {
        Ok(updater) => {
            match updater.check().await {
                Ok(Some(update)) => {
                    Ok(UpdateInfo {
                        update_available: true,
                        version: Some(update.version.clone()),
                        date: update.date.map(|d| d.to_string()),
                        body: update.body.clone(),
                    })
                }
                Ok(None) => {
                    Ok(UpdateInfo {
                        update_available: false,
                        version: None,
                        date: None,
                        body: None,
                    })
                }
                Err(e) => Err(format!("Failed to check for update: {}", e)),
            }
        }
        Err(e) => Err(format!("Updater not available: {}", e)),
    }
}

/// Install update using Tauri's secure updater (with signature verification)
#[tauri::command]
pub async fn install_update(app: AppHandle) -> Result<(), String> {
    match app.updater() {
        Ok(updater) => {
            match updater.check().await {
                Ok(Some(update)) => {
                    match update.download_and_install(|_, _| {}, || {}).await {
                        Ok(_) => Ok(()),
                        Err(e) => Err(format!("Failed to install update: {}", e)),
                    }
                }
                Ok(None) => Err("No update available".to_string()),
                Err(e) => Err(format!("Failed to check for update: {}", e)),
            }
        }
        Err(e) => Err(format!("Updater not available: {}", e)),
    }
}