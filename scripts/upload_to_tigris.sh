#!/bin/bash

set -euo pipefail

# Configuration
TIGRIS_BUCKET="clones-desktop-release-test"
TIGRIS_ENDPOINT="https://fly.storage.tigris.dev"
BUCKET_URL="https://releases-test.clones-ai.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Load environment variables from .env if it exists
load_env() {
    if [ -f ".env" ]; then
        log_info "Loading environment variables from .env..."
        set -a  # automatically export all variables
        source .env
        set +a  # stop auto-export
        log_success "Environment variables loaded"
    else
        log_warning ".env not found, using system environment variables"
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI not found. Please install AWS CLI"
        echo "  brew install awscli"
        exit 1
    fi
    
    if [ -z "${TIGRIS_ACCESS_KEY_ID:-}" ]; then
        log_error "TIGRIS_ACCESS_KEY_ID not found"
        echo "  Either:"
        echo "    1. Add TIGRIS_ACCESS_KEY_ID=your_key to .env"
        echo "    2. Or export TIGRIS_ACCESS_KEY_ID='your_access_key'"
        exit 1
    fi
    
    if [ -z "${TIGRIS_SECRET_ACCESS_KEY:-}" ]; then
        log_error "TIGRIS_SECRET_ACCESS_KEY not found"
        echo "  Either:"
        echo "    1. Add TIGRIS_SECRET_ACCESS_KEY=your_secret to .env" 
        echo "    2. Or export TIGRIS_SECRET_ACCESS_KEY='your_secret_key'"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Find latest build directory
find_latest_build() {
    local build_dir=$(find . -maxdepth 1 -name "build_output_*" -type d | sort -r | head -n1)
    
    if [ -z "$build_dir" ]; then
        log_error "No build output directory found. Please run build_release_local.sh first"
        exit 1
    fi
    
    echo "$build_dir"
}

# Extract version from Tauri config
get_app_version() {
    if [ ! -f "src-tauri/tauri.conf.json" ]; then
        log_error "src-tauri/tauri.conf.json not found"
        exit 1
    fi
    
    local version=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' src-tauri/tauri.conf.json | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    
    if [ -z "$version" ]; then
        log_error "Could not extract version from src-tauri/tauri.conf.json"
        exit 1
    fi
    
    echo "$version"
}

# Upload file to Tigris with metadata
upload_file() {
    local file_path="$1"
    local s3_key="$2"
    local version="$3"
    local arch="$4"
    local file_type="$5"
    
    log_info "Uploading $(basename "$file_path") to $s3_key..."
    
    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"
    
    # Upload file with metadata, overwriting existing files
    aws s3 cp "$file_path" "s3://$TIGRIS_BUCKET/$s3_key" \
        --metadata "version=$version" \
        --metadata "arch=$arch" \
        --metadata "type=$file_type" \
        --metadata "uploaded=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --content-type "application/octet-stream" \
        --no-progress \
        --force
    
    if [ $? -eq 0 ]; then
        log_success "Uploaded: $BUCKET_URL/$s3_key"
    else
        log_error "Failed to upload $file_path"
        return 1
    fi
}

# Create version manifest
create_version_manifest() {
    local version="$1"
    local build_dir="$2"
    
    local manifest_file=$(mktemp)
    local upload_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Start JSON
    cat > "$manifest_file" <<EOF
{
  "version": "$version",
  "uploadDate": "$upload_date",
  "files": {
EOF

    local entries=()
    
    # Process DMG files
    while IFS= read -r -d '' dmg_file; do
        if [[ "$dmg_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$dmg_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local filename=$(basename "$dmg_file")
        local size=$(stat -f%z "$dmg_file" 2>/dev/null || stat -c%s "$dmg_file")
        
        entries+=("    \"macos_${arch}_dmg\": {
      \"filename\": \"$filename\",
      \"url\": \"$BUCKET_URL/latest/$filename\",
      \"size\": $size,
      \"arch\": \"$arch\",
      \"type\": \"dmg\"
    }")
    done < <(find "$build_dir" -name "*.dmg" -print0)
    
    # Process APP bundles (zipped)
    while IFS= read -r -d '' app_file; do
        if [[ "$app_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$app_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local app_name=$(basename "$app_file")
        local zip_name="${app_name%.app}_${arch}.zip"
        local size=$(du -sk "$app_file" | cut -f1)
        size=$((size * 1024))  # Convert KB to bytes
        
        entries+=("    \"macos_${arch}_app\": {
      \"filename\": \"$zip_name\",
      \"url\": \"$BUCKET_URL/latest/$zip_name\",
      \"size\": $size,
      \"arch\": \"$arch\",
      \"type\": \"app\"
    }")
    done < <(find "$build_dir" -name "*.app" -type d -print0)
    
    # Join entries with commas
    local first=true
    for entry in "${entries[@]}"; do
        if [ "$first" = false ]; then
            echo "," >> "$manifest_file"
        fi
        echo "$entry" >> "$manifest_file"
        first=false
    done
    
    # Close JSON
    cat >> "$manifest_file" <<EOF
  }
}
EOF

    echo "$manifest_file"
}

# Main upload function
main_upload() {
    local build_dir=$(find_latest_build)
    local version=$(get_app_version)
    
    log_info "Found build directory: $build_dir"
    log_info "App version: $version"
    
    # Upload DMG files
    find "$build_dir" -name "*.dmg" | while read dmg_file; do
        if [[ "$dmg_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$dmg_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local filename=$(basename "$dmg_file")
        
        # Upload to versioned path
        upload_file "$dmg_file" "versions/$version/macos/$filename" "$version" "$arch" "dmg"
        
        # Upload to latest path (for easy access)
        upload_file "$dmg_file" "latest/$filename" "$version" "$arch" "dmg"
    done
    
    # Upload APP bundles (zipped for transport)
    find "$build_dir" -name "*.app" -type d | while read app_file; do
        if [[ "$app_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$app_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local app_name=$(basename "$app_file")
        local zip_name="${app_name%.app}_${arch}.zip"
        local temp_zip=$(mktemp -d)/"$zip_name"
        
        log_info "Creating ZIP archive for $app_name..."
        cd "$(dirname "$app_file")"
        zip -r "$temp_zip" "$app_name" > /dev/null
        cd - > /dev/null
        
        # Upload to versioned path
        upload_file "$temp_zip" "versions/$version/macos/$zip_name" "$version" "$arch" "app"
        
        # Upload to latest path
        upload_file "$temp_zip" "latest/$zip_name" "$version" "$arch" "app"
        
        rm "$temp_zip"
    done
    
    # Create and upload version manifest
    log_info "Creating version manifest..."
    local manifest_file=$(create_version_manifest "$version" "$build_dir")
    
    if [ ! -f "$manifest_file" ]; then
        log_error "Failed to create manifest file: $manifest_file"
        exit 1
    fi
    
    log_info "Created manifest file: $manifest_file"
    log_info "Manifest content preview:"
    head -10 "$manifest_file"
    
    upload_file "$manifest_file" "latest/version.json" "$version" "all" "manifest"
    upload_file "$manifest_file" "versions/$version/version.json" "$version" "all" "manifest"
    rm "$manifest_file"
    
    log_success "🎉 Upload completed successfully!"
    echo ""
    log_info "Files available at:"
    echo "  📦 Latest builds: $BUCKET_URL/latest/"
    echo "  📋 Version manifest: $BUCKET_URL/latest/version.json"
    echo "  📚 All versions: $BUCKET_URL/versions/"
}

# Main execution
main() {
    echo "🚀 Clones Desktop - Tigris Upload Script"
    echo "========================================"
    
    load_env
    check_prerequisites
    main_upload
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi