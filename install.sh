#!/bin/bash

# Installation script for Claude Code Cookbook
# This script helps users install their preferred language version

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Project paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSIONS_DIR="$SCRIPT_DIR/versions"
CLAUDE_DIR="$HOME/.claude"

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

# Function to display banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════╗"
    echo "║     Claude Code Cookbook Installer     ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to list available versions
list_versions() {
    print_info "Available language versions:"
    echo ""
    
    local index=1
    local versions=()
    
    for version_dir in "$VERSIONS_DIR"/*; do
        if [[ -d "$version_dir" ]]; then
            local version=$(basename "$version_dir")
            versions+=("$version")
            
            case "$version" in
                en)
                    echo "  $index) English (en)"
                    ;;
                ja)
                    echo "  $index) 日本語 Japanese (ja)"
                    ;;
                zh)
                    echo "  $index) 中文 Chinese (zh)"
                    ;;
                fr)
                    echo "  $index) Français French (fr)"
                    ;;
                ko)
                    echo "  $index) 한국어 Korean (ko)"
                    ;;
                *)
                    echo "  $index) $version"
                    ;;
            esac
            
            index=$((index + 1))
        fi
    done
    
    echo ""
    echo "${versions[@]}"
}

# Function to backup existing .claude directory
backup_existing() {
    if [[ -d "$CLAUDE_DIR" ]]; then
        local backup_name=".claude_backup_$(date +%Y%m%d_%H%M%S)"
        local backup_path="$HOME/$backup_name"
        
        print_warning "Existing .claude directory found"
        read -p "Do you want to backup the existing .claude directory? (y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Creating backup at $backup_path"
            mv "$CLAUDE_DIR" "$backup_path"
            print_success "Backup created: $backup_path"
        else
            read -p "Remove existing .claude directory? (y/n): " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$CLAUDE_DIR"
                print_info "Removed existing .claude directory"
            else
                print_error "Installation cancelled"
                exit 1
            fi
        fi
    fi
}

# Function to install selected version
install_version() {
    local version="$1"
    local source_dir="$VERSIONS_DIR/$version"
    
    if [[ ! -d "$source_dir" ]]; then
        print_error "Version not found: $version"
        return 1
    fi
    
    print_info "Installing $version version..."
    
    # Copy version to .claude
    cp -r "$source_dir" "$CLAUDE_DIR"
    
    # Make scripts executable
    if [[ -d "$CLAUDE_DIR/scripts" ]]; then
        chmod +x "$CLAUDE_DIR/scripts"/*.sh 2>/dev/null || true
    fi
    
    print_success "Installation completed!"
}

# Function to verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    # Check directory structure
    local checks_passed=true
    
    if [[ ! -d "$CLAUDE_DIR/commands" ]]; then
        print_error "Commands directory missing"
        checks_passed=false
    fi
    
    if [[ ! -d "$CLAUDE_DIR/agents" ]]; then
        print_error "Agents directory missing"
        checks_passed=false
    fi
    
    if [[ ! -f "$CLAUDE_DIR/settings.json" ]]; then
        print_error "settings.json missing"
        checks_passed=false
    fi
    
    if $checks_passed; then
        print_success "Installation verified successfully!"
        
        # Count installed items
        local cmd_count=$(find "$CLAUDE_DIR/commands" -name "*.md" -type f 2>/dev/null | wc -l)
        local role_count=$(find "$CLAUDE_DIR/agents/roles" -name "*.md" -type f 2>/dev/null | wc -l)
        local script_count=$(find "$CLAUDE_DIR/scripts" -name "*.sh" -type f 2>/dev/null | wc -l)
        
        echo ""
        echo "Installed components:"
        echo "  • Commands: $cmd_count"
        echo "  • Roles: $role_count"
        echo "  • Scripts: $script_count"
    else
        print_error "Installation verification failed"
        return 1
    fi
}

# Main installation flow
main() {
    show_banner
    
    # Check if versions directory exists
    if [[ ! -d "$VERSIONS_DIR" ]]; then
        print_error "Versions directory not found: $VERSIONS_DIR"
        print_info "Please ensure you're running this script from the Claude Code Cookbook directory"
        exit 1
    fi
    
    # Check for available versions
    local version_count=$(ls -d "$VERSIONS_DIR"/*/ 2>/dev/null | wc -l)
    
    if [[ $version_count -eq 0 ]]; then
        print_error "No language versions found"
        exit 1
    fi
    
    # List available versions
    local versions=($(ls -d "$VERSIONS_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
    
    if [[ ${#versions[@]} -eq 1 ]]; then
        # Only one version available
        print_info "Only one version available: ${versions[0]}"
        local selected_version="${versions[0]}"
    else
        # Multiple versions available
        list_versions
        
        # Get user selection
        read -p "Select a language version (1-${#versions[@]}): " selection
        
        if [[ ! "$selection" =~ ^[0-9]+$ ]] || [[ $selection -lt 1 ]] || [[ $selection -gt ${#versions[@]} ]]; then
            print_error "Invalid selection"
            exit 1
        fi
        
        local selected_version="${versions[$((selection-1))]}"
    fi
    
    echo ""
    print_info "Selected version: $selected_version"
    echo ""
    
    # Backup existing .claude if present
    backup_existing
    
    # Install selected version
    install_version "$selected_version"
    
    # Verify installation
    echo ""
    verify_installation
    
    # Show completion message
    echo ""
    echo "════════════════════════════════════════"
    print_success "Claude Code Cookbook installed successfully!"
    echo ""
    echo "Location: $CLAUDE_DIR"
    echo "Version: $selected_version"
    echo ""
    echo "To use with Claude:"
    echo "1. Open Claude Desktop App"
    echo "2. Go to Settings → Developer"
    echo "3. Set Custom Instructions path to: $CLAUDE_DIR"
    echo ""
    echo "Enjoy using Claude Code Cookbook! 🎉"
    echo "════════════════════════════════════════"
}

# Run main function
main "$@"
