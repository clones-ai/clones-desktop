//! Tauri command for exporting all recordings as a zip archive.
//!
//! This module provides a command to zip the entire recordings directory and save it to a user-selected location.

use crate::{tools::sanitize_and_check_path, utils::settings::get_custom_app_local_data_dir};
use std::{
    io::{Cursor, Read, Write},
    path::Path,
};
use tauri_plugin_dialog::DialogExt;
use walkdir::WalkDir;
use zip::{write::FileOptions, ZipWriter};

fn validate_dir_path(path: &str) -> Result<(), String> {
    if path.trim().is_empty() {
        return Err("Directory path cannot be empty".to_string());
    }
    if path.len() > 4096 {
        return Err("Directory path is too long".to_string());
    }
    if path.contains("..") || path.contains("\\") {
        return Err("Invalid directory path (path traversal detected)".to_string());
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_dir_path_empty() {
        let result = validate_dir_path("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Directory path cannot be empty");
    }

    #[test]
    fn test_validate_dir_path_too_long() {
        let long_path = "a".repeat(4097);
        let result = validate_dir_path(&long_path);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Directory path is too long");
    }

    #[test]
    fn test_validate_dir_path_path_traversal() {
        let result = validate_dir_path("/tmp/../etc");
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Invalid directory path (path traversal detected)"
        );

        let result = validate_dir_path("C:\\evil");
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Invalid directory path (path traversal detected)"
        );
    }

    #[test]
    fn test_validate_dir_path_valid() {
        let result = validate_dir_path("/tmp/recordings");
        assert!(result.is_ok());
    }
}
