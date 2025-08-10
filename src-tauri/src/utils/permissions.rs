//! Cross-platform permissions utilities for accessibility and screen recording access.
//!
//! This module provides Tauri commands to check and request accessibility (AX) and screen recording permissions.

#[cfg(target_os = "macos")]
mod macos_permissions {
    use core_foundation::base::Boolean;
    use core_graphics::access::ScreenCaptureAccess;
    use macos_accessibility_client::accessibility::application_is_trusted_with_prompt;

    // External ApplicationServices declarations
    #[link(name = "ApplicationServices", kind = "framework")]
    extern "C" {
        fn AXIsProcessTrusted() -> Boolean;
    }

    /// Checks if the application has accessibility (AX) permissions.
    ///
    /// # Returns
    /// * `true` if the application is trusted for accessibility.
    /// * `false` otherwise.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        unsafe {
            let result = AXIsProcessTrusted() != 0;
            result
        }
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    #[tauri::command]
    pub fn request_ax_perms() {
        application_is_trusted_with_prompt();
    }

    /// Checks if the application has screen recording permissions.
    ///
    /// # Returns
    /// * `true` if the application has screen recording access.
    /// * `false` otherwise.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        return ScreenCaptureAccess.preflight();
    }

    /// Prompts the user to grant screen recording permissions.
    #[tauri::command]
    pub fn request_record_perms() {
        ScreenCaptureAccess.request();
    }
}

#[cfg(target_os = "windows")]
mod windows_permissions {
    /// Checks if the application has accessibility (AX) permissions.
    /// On Windows, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        // On Windows, accessibility permissions are typically granted by default
        // or handled through UAC prompts when needed
        true
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    /// On Windows, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub fn request_ax_perms() {
        // On Windows, accessibility permissions are typically granted by default
        // or handled through UAC prompts when needed
    }

    /// Checks if the application has screen recording permissions.
    /// On Windows, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        // On Windows, screen recording permissions are typically granted by default
        // or handled through UAC prompts when needed
        true
    }

    /// Prompts the user to grant screen recording permissions.
    /// On Windows, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub fn request_record_perms() {
        // On Windows, screen recording permissions are typically granted by default
        // or handled through UAC prompts when needed
    }
}

#[cfg(target_os = "linux")]
mod linux_permissions {
    /// Checks if the application has accessibility (AX) permissions.
    /// On Linux, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        // On Linux, accessibility permissions are typically granted by default
        true
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    /// On Linux, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub fn request_ax_perms() {
        // On Linux, accessibility permissions are typically granted by default
    }

    /// Checks if the application has screen recording permissions.
    /// On Linux, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        // On Linux, screen recording permissions are typically granted by default
        true
    }

    /// Prompts the user to grant screen recording permissions.
    /// On Linux, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub fn request_record_perms() {
        // On Linux, screen recording permissions are typically granted by default
    }
}

// Re-export the appropriate platform-specific functions
#[cfg(target_os = "macos")]
pub use macos_permissions::*;

#[cfg(target_os = "windows")]
pub use windows_permissions::*;

#[cfg(target_os = "linux")]
pub use linux_permissions::*;
