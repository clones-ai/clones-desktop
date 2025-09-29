#!/bin/bash

set -euo pipefail

echo "🏗️  Starting Flutter Web + Tauri Build"

ROOT_DIR=$(pwd)
BUILD_DIR="$ROOT_DIR/build"
WEB_DIR="$ROOT_DIR/web"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up..."
    # Remove any temporary files if needed
    echo "✅ Cleanup complete"
}
trap cleanup EXIT INT TERM

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

# Check for .env file
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found. Creating from env.example..."
    if [ -f "env.example" ]; then
        cp env.example .env
        echo "✅ Created .env from env.example"
    else
        echo "❌ Error: env.example not found. Please create a .env file manually."
        exit 1
    fi
fi

# Set environment for production build
echo "🔧 Setting up environment for production build..."
export ENV=production

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
rm -rf "$WEB_DIR"

# 1. Build Flutter Web
echo "📱 Building Flutter Web..."

# Load environment variables for the build
if [ -f ".env" ]; then
    echo "📋 Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
fi

flutter build web --release --web-renderer html

# Verify the build was successful
if [ ! -d "$WEB_DIR" ]; then
    echo "❌ Error: Flutter web build failed. Web directory not found."
    exit 1
fi

echo "✅ Flutter Web build complete!"

# 2. Build Tauri
echo "🦀 Building Tauri application..."
cd "$ROOT_DIR/src-tauri"

# Build for current platform
echo "🔨 Building for current platform..."
cargo tauri build --release

# Optional: Build for multiple platforms
# Uncomment the following lines if you want to build for multiple platforms
# echo "🔨 Building for Windows..."
# cargo tauri build --release --target x86_64-pc-windows-msvc
# 
# echo "🔨 Building for macOS..."
# cargo tauri build --release --target x86_64-apple-darwin
# cargo tauri build --release --target aarch64-apple-darwin
# 
# echo "🔨 Building for Linux..."
# cargo tauri build --release --target x86_64-unknown-linux-gnu

echo "✅ Tauri build complete!"

# 3. Show build results
echo "🎉 Build completed successfully!"
echo "📁 Build artifacts:"
echo "   - Flutter Web: $WEB_DIR"
echo "   - Tauri App: $ROOT_DIR/src-tauri/target/release/"

# Optional: Show file sizes
if command -v du >/dev/null 2>&1; then
    echo ""
    echo "📊 Build sizes:"
    if [ -d "$WEB_DIR" ]; then
        echo "   - Web build: $(du -sh "$WEB_DIR" | cut -f1)"
    fi
    
    TAURI_APP="$ROOT_DIR/src-tauri/target/release/"
    if [ -d "$TAURI_APP" ]; then
        echo "   - Tauri app: $(du -sh "$TAURI_APP" | cut -f1)"
    fi
fi

echo ""
echo "🚀 Ready for deployment!"
