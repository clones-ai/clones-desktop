#!/bin/bash

set -euo pipefail

echo "🚀 Building Clones Desktop for macOS Release (Local)"

ROOT_DIR=$(pwd)
BUILD_DATE=$(date +"%Y%m%d_%H%M%S")
BUILD_DIR="$ROOT_DIR/build_output_$BUILD_DATE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Read required Flutter version from .tool-versions
    if [ ! -f ".tool-versions" ]; then
        log_error ".tool-versions file not found"
        exit 1
    fi
    
    REQUIRED_FLUTTER_VERSION=$(grep "^flutter " .tool-versions | cut -d' ' -f2)
    if [ -z "$REQUIRED_FLUTTER_VERSION" ]; then
        log_error "Flutter version not found in .tool-versions"
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter not found. Please install Flutter $REQUIRED_FLUTTER_VERSION"
        exit 1
    fi
    
    if ! command -v cargo &> /dev/null; then
        log_error "Cargo not found. Please install Rust"
        exit 1
    fi
    
    if ! command -v security &> /dev/null; then
        log_error "macOS security command not found"
        exit 1
    fi
    
    # Check Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1 | cut -d' ' -f2)
    log_info "Flutter version: $FLUTTER_VERSION (required: $REQUIRED_FLUTTER_VERSION)"
    
    # Check if .env.local exists
    if [ ! -f ".env.local" ]; then
        log_error ".env.local file not found. Please create it with your environment variables."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Setup environment
setup_environment() {
    log_info "Setting up environment..."
    
    # Copy .env.local to .env for Flutter assets
    cp .env.local .env
    log_info "Created .env from .env.local"
    
    # Source .env.local to load environment variables
    set -a  # automatically export all variables
    source .env.local
    set +a  # stop auto-export
    log_info "Loaded environment variables from .env.local"
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    log_info "Created build directory: $BUILD_DIR"
}

# Install dependencies
install_dependencies() {
    log_info "Installing Flutter dependencies..."
    flutter pub get
    
    log_info "Installing Tauri CLI (if not already installed)..."
    if ! command -v cargo-tauri &> /dev/null; then
        cargo install tauri-cli --version "^2.0"
        log_success "Tauri CLI installed"
    else
        log_info "Tauri CLI already installed"
    fi
}

# Build Flutter Web
build_flutter() {
    log_info "Building Flutter Web..."
    flutter build web --base-href="/"
    log_success "Flutter Web build completed"
}

# Build for specific target
build_tauri_target() {
    local target=$1
    local arch=$2
    
    log_info "Building Tauri app for $arch ($target)..."
    
    cd "$ROOT_DIR/src-tauri"
    
    # Add target if not already added
    rustup target add $target 2>/dev/null || true
    
    # Build without notarization (signing only)
    cargo tauri build --target $target --config tauri.conf.json
    
    local target_dir="$ROOT_DIR/src-tauri/target/$target/release/bundle"
    
    if [ -d "$target_dir/macos" ]; then
        cp -r "$target_dir/macos" "$BUILD_DIR/macos_$arch"
        log_success "macOS app copied to build directory: macos_$arch"
    fi
    
    if [ -d "$target_dir/dmg" ]; then
        cp -r "$target_dir/dmg" "$BUILD_DIR/dmg_$arch"
        log_success "DMG copied to build directory: dmg_$arch"
    fi
    
    cd "$ROOT_DIR"
}

# Main build function
main_build() {
    log_info "Starting main build process..."
    
    # Build for both architectures
    log_info "Building for Apple Silicon (ARM64)..."
    build_tauri_target "aarch64-apple-darwin" "arm64"
    
    log_info "Building for Intel (x86_64)..."
    build_tauri_target "x86_64-apple-darwin" "intel"
    
    log_success "Build completed!"
    log_info "Build artifacts located in: $BUILD_DIR"
    
    # List built artifacts
    echo ""
    log_info "Built artifacts:"
    find "$BUILD_DIR" -name "*.app" -o -name "*.dmg" | while read -r file; do
        echo "  📦 $(basename "$file")"
    done
}

# Automated notarization
notarize_artifacts() {
    echo ""
    log_info "🔐 Starting automated notarization..."
    
    # Check if keychain profile is configured
    local KEYCHAIN_PROFILE="${NOTARIZATION_KEYCHAIN_PROFILE:-clones-notary}"
    
    # Test if keychain profile exists
    if ! xcrun notarytool history --keychain-profile "$KEYCHAIN_PROFILE" >/dev/null 2>&1; then
        log_warning "Keychain profile '$KEYCHAIN_PROFILE' not found."
        log_info "Please configure it first:"
        echo "   xcrun notarytool store-credentials \"$KEYCHAIN_PROFILE\" --apple-id \"your@email.com\" --team-id \"TEAMID\" --password \"app-specific-password\""
        echo ""
        log_info "Skipping notarization. Build artifacts are available for manual notarization."
        return 0
    fi
    
    # Notarize DMG files (preferred format)
    local dmg_files=($(find "$BUILD_DIR" -name "*.dmg"))
    
    if [ ${#dmg_files[@]} -eq 0 ]; then
        log_warning "No DMG files found for notarization"
        return 0
    fi
    
    for dmg in "${dmg_files[@]}"; do
        log_info "Notarizing $(basename "$dmg")..."
        
        # Submit for notarization and capture the submission ID
        local submission_output
        submission_output=$(xcrun notarytool submit "$dmg" --keychain-profile "$KEYCHAIN_PROFILE" --wait 2>&1)
        local submit_exit_code=$?
        
        if [ $submit_exit_code -eq 0 ]; then
            # Extract submission ID and check the actual status
            local submission_id
            submission_id=$(echo "$submission_output" | grep "id:" | head -1 | awk '{print $2}')
            
            if [ -n "$submission_id" ]; then
                # Get the actual status
                local status_info
                status_info=$(xcrun notarytool info "$submission_id" --keychain-profile "$KEYCHAIN_PROFILE" 2>/dev/null)
                local actual_status
                actual_status=$(echo "$status_info" | grep "status:" | awk '{print $2}')
                
                if [ "$actual_status" = "Accepted" ]; then
                    log_success "Notarization successful for $(basename "$dmg")"
                    
                    # Staple the notarization ticket
                    log_info "Stapling notarization ticket..."
                    if xcrun stapler staple "$dmg"; then
                        log_success "Stapling successful for $(basename "$dmg")"
                    else
                        log_warning "Stapling failed for $(basename "$dmg")"
                    fi
                else
                    log_error "Notarization failed with status: $actual_status"
                    log_info "Fetching detailed error logs..."
                    xcrun notarytool log "$submission_id" --keychain-profile "$KEYCHAIN_PROFILE"
                fi
            else
                log_error "Could not extract submission ID from notarization output"
            fi
        else
            log_error "Notarization submission failed for $(basename "$dmg")"
            echo "$submission_output"
        fi
        echo ""
    done
}

# Cleanup function
cleanup() {
    log_info "Cleaning up temporary files..."
    rm -f .env
    log_info "Cleanup completed"
}

# Error handling
handle_error() {
    log_error "Build failed! Check the output above for errors."
    cleanup
    exit 1
}

trap handle_error ERR

# Main execution
main() {
    echo "📱 Clones Desktop - Local macOS Build Script"
    echo "=============================================="
    
    check_prerequisites
    setup_environment
    install_dependencies
    build_flutter
    main_build
    notarize_artifacts
    cleanup
    
    echo ""
    log_success "🎉 Build and notarization process completed successfully!"
    log_info "Your notarized apps are ready for distribution"
}

# Run main function
main "$@"