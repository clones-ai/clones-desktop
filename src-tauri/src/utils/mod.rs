//! Utility modules for file downloading, GitHub release management, logging, permissions, settings, window management, platform detection, URL handling, and proxying.
//!
//! This module re-exports all utility submodules for use throughout the application.

// Re-export all utility modules
pub mod downloader;
pub mod github_release;
pub mod logger;
pub mod permissions;
pub mod platform;
pub mod proxy;
pub mod settings;
pub mod url;
pub mod windows;
