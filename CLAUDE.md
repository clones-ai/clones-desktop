# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Technology Stack

**Framework**: Flutter 3.x with Dart
**Platform**: Cross-platform desktop (macOS, Windows, Linux) + Tauri integration
**Architecture**: Clean Architecture with domain/application/infrastructure layers
**State Management**: Flutter's built-in state management patterns
**Build Tools**: Flutter SDK + Tauri for native desktop features

## Development Commands

```bash
# Flutter Development
flutter run -d macos          # Run on macOS
flutter run -d windows        # Run on Windows  
flutter run -d linux          # Run on Linux
flutter build macos           # Build macOS app
flutter build windows         # Build Windows app
flutter build linux           # Build Linux app

# Tauri Integration
cd src-tauri
cargo tauri dev               # Run with Tauri backend
cargo tauri build             # Build with Tauri

# Testing
flutter test                  # Run Dart tests
flutter analyze               # Static analysis
```

## Core Architecture

**Clean Architecture Structure**:
- `lib/domain/` - Business logic and entities
- `lib/application/` - Use cases and application services  
- `lib/infrastructure/` - External dependencies (APIs, storage)
- `lib/ui/` - Presentation layer (widgets, screens)

**Key Features**:
- Cross-platform desktop application
- Native system integration via Tauri
- Audio system integration (blip.wav, notification sounds)
- Asset management for icons and backgrounds
- Deep linking support for referral system

## Platform-Specific Considerations

**macOS**: 
- Xcode project configuration in `macos/Runner.xcodeproj`
- Entitlements for system access
- Code signing requirements

**Windows**:
- Visual Studio build tools required
- Windows-specific build scripts in `scripts/windows/`

**Linux**:
- CMake build system
- GTK dependencies

## Environment Configuration

The app integrates with the Clones ecosystem:
- Backend API connectivity (clones-backend)
- Referral system integration  
- Blockchain wallet connectivity
- Desktop-specific deep linking

## Asset Management

- Icons: `assets/icons/` (multiple resolutions)
- Audio: `assets/*.wav` files for system sounds
- Backgrounds: `assets/main-background.png`
- Logo: `assets/Logo-Circle-Transparent.svg`

## Build and Distribution

Uses Flutter's desktop support with Tauri integration for:
- Native system APIs
- File system access
- System notifications
- Auto-updater functionality

## Testing Strategy

- Unit tests for business logic
- Widget tests for UI components
- Integration tests for platform features
- Static analysis via `flutter analyze`
