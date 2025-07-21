//! Command modules for Tauri backend API (general, tools, recordings, settings, record).
//!
//! This module re-exports all command submodules for use throughout the application.

// Re-export all command modules
pub mod general;
pub mod record;
pub mod recordings;
pub mod settings;
pub mod tools;
