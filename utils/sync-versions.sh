#!/bin/bash

# Sync common files across language versions
# This script syncs scripts and settings that should be identical across versions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSIONS_DIR="$PROJECT_ROOT/versions"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to sync scripts directory
sync_scripts() {
    local source_version="$1"
    local target_version="$2"
    
    if [[ ! -d "$VERSIONS_DIR/$source_version/scripts" ]]; then
        print_error "Source scripts directory not found: $source_version"
        return 1
    fi
    
    print_info "Syncing scripts from $source_version to $target_version"
    
    # Create target directory if it doesn't exist
    mkdir -p "$VERSIONS_DIR/$target_version/scripts"
    
    # Copy all script files
    cp -r "$VERSIONS_DIR/$source_version/scripts/"* "$VERSIONS_DIR/$target_version/scripts/" 2>/dev/null || true
    
    print_success "Scripts synced successfully"
}

# Function to sync settings.json
sync_settings() {
    local source_version="$1"
    local target_version="$2"
    
    if [[ ! -f "$VERSIONS_DIR/$source_version/settings.json" ]]; then
        print_error "Source settings.json not found: $source_version"
        return 1
    fi
    
    print_info "Syncing settings.json from $source_version to $target_version"
    
    cp "$VERSIONS_DIR/$source_version/settings.json" "$VERSIONS_DIR/$target_version/settings.json"
    
    print_success "Settings synced successfully"
}

# Function to list available versions
list_versions() {
    print_info "Available versions:"
    for dir in "$VERSIONS_DIR"/*; do
        if [[ -d "$dir" ]]; then
            echo "  - $(basename "$dir")"
        fi
    done
}

# Main execution
main() {
    echo "================================"
    echo "Version Sync Tool"
    echo "================================"
    echo ""
    
    # Check if versions directory exists
    if [[ ! -d "$VERSIONS_DIR" ]]; then
        print_error "Versions directory not found: $VERSIONS_DIR"
        exit 1
    fi
    
    # Parse arguments
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <source> <target> [--scripts|--settings|--all]"
        echo ""
        list_versions
        exit 0
    fi
    
    local source="$1"
    local target="$2"
    local mode="${3:---all}"
    
    # Validate source and target
    if [[ ! -d "$VERSIONS_DIR/$source" ]]; then
        print_error "Source version not found: $source"
        list_versions
        exit 1
    fi
    
    if [[ ! -d "$VERSIONS_DIR/$target" ]]; then
        print_warning "Target version not found: $target"
        read -p "Create target version? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$VERSIONS_DIR/$target"
            print_success "Created target version: $target"
        else
            exit 1
        fi
    fi
    
    # Perform sync based on mode
    case "$mode" in
        --scripts)
            sync_scripts "$source" "$target"
            ;;
        --settings)
            sync_settings "$source" "$target"
            ;;
        --all)
            sync_scripts "$source" "$target"
            sync_settings "$source" "$target"
            ;;
        *)
            print_error "Unknown mode: $mode"
            echo "Use --scripts, --settings, or --all"
            exit 1
            ;;
    esac
    
    print_success "Sync completed!"
}

main "$@"
