#!/bin/bash

set -euo pipefail

# Configuration
TIGRIS_BUCKET="clones-desktop-release-test"
TIGRIS_ENDPOINT="https://fly.storage.tigris.dev"

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

# Delete a specific version directory
delete_version() {
    local version="$1"
    local s3_prefix="versions/$version/"
    local s3_path="s3://$TIGRIS_BUCKET/$s3_prefix"

    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"

    log_info "Checking if version '$version' exists at $s3_path..."
    # Use s3api to reliably check for objects with the given prefix.
    # 'ls' can be unreliable as it has a non-zero exit code if no files are found.
    if ! aws s3api list-objects-v2 --bucket "$TIGRIS_BUCKET" --prefix "$s3_prefix" --max-items 1 | grep -q '"Contents"'; then
        log_error "Version '$version' not found at $s3_path"
        log_info "Nothing to delete."
        exit 1
    fi
    log_success "Version '$version' found."
    
    log_info "Attempting to delete version '$version' from Tigris bucket..."
    log_warning "This will permanently delete all files in: $s3_path"
    
    # Confirmation prompt
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deletion cancelled by user."
        exit 0
    fi
    
    log_info "Deleting files from $s3_path..."
    
    # The command doesn't fail if the directory is empty or doesn't exist.
    if aws s3 rm "$s3_path" --recursive; then
        log_success "Successfully deleted version '$version'."
    else
        log_error "Failed to delete version '$version'. An unexpected error occurred."
        exit 1
    fi
}

# Main execution
main() {
    echo "🗑️  Clones Desktop - Tigris Version Deletion Script"
    echo "================================================"
    
    if [ -z "${1:-}" ]; then
        log_error "Usage: $0 <version>"
        echo "  Example: $0 0.0.4"
        exit 1
    fi
    
    local version_to_delete="$1"
    
    load_env
    check_prerequisites
    delete_version "$version_to_delete"
    
    log_success "🎉 Deletion process completed successfully!"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
