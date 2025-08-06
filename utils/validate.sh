#!/bin/bash

# Validate language versions for completeness and consistency
# Ensures each version has all required files and structure

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

# Required directories
REQUIRED_DIRS=("commands" "agents" "agents/roles" "scripts")

# Required files
REQUIRED_FILES=("settings.json")

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
}

# Function to check directory structure
check_structure() {
    local version="$1"
    local version_dir="$VERSIONS_DIR/$version"
    
    print_info "Checking directory structure for $version..."
    
    for dir in "${REQUIRED_DIRS[@]}"; do
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        if [[ -d "$version_dir/$dir" ]]; then
            print_success "$dir exists"
        else
            print_error "$dir is missing"
        fi
    done
    
    for file in "${REQUIRED_FILES[@]}"; do
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        if [[ -f "$version_dir/$file" ]]; then
            print_success "$file exists"
        else
            print_error "$file is missing"
        fi
    done
}

# Function to count files in directories
count_files() {
    local version="$1"
    local version_dir="$VERSIONS_DIR/$version"
    
    print_info "File counts for $version:"
    
    # Count command files
    if [[ -d "$version_dir/commands" ]]; then
        local cmd_count=$(find "$version_dir/commands" -name "*.md" -type f | wc -l)
        echo "  Commands: $cmd_count files"
    fi
    
    # Count role files
    if [[ -d "$version_dir/agents/roles" ]]; then
        local role_count=$(find "$version_dir/agents/roles" -name "*.md" -type f | wc -l)
        echo "  Roles: $role_count files"
    fi
    
    # Count script files
    if [[ -d "$version_dir/scripts" ]]; then
        local script_count=$(find "$version_dir/scripts" -name "*.sh" -type f | wc -l)
        echo "  Scripts: $script_count files"
    fi
}

# Function to check for language-specific content
check_language_content() {
    local version="$1"
    local version_dir="$VERSIONS_DIR/$version"
    
    print_info "Checking language content for $version..."
    
    # Define expected language patterns
    case "$version" in
        ja)
            # Check for Japanese content
            if [[ -d "$version_dir/commands" ]]; then
                local ja_files=$(grep -l '[ぁ-んァ-ヶー一-龯]' "$version_dir/commands"/*.md 2>/dev/null | wc -l)
                if [[ $ja_files -gt 0 ]]; then
                    print_success "Found Japanese content in $ja_files command files"
                else
                    print_warning "No Japanese content found in commands"
                fi
            fi
            ;;
        en)
            # Check for English content and no Japanese
            if [[ -d "$version_dir/commands" ]]; then
                local en_files=$(grep -L '[ぁ-んァ-ヶー一-龯]' "$version_dir/commands"/*.md 2>/dev/null | wc -l)
                local ja_contamination=$(grep -l '[ぁ-んァ-ヶー一-龯]' "$version_dir/commands"/*.md 2>/dev/null | wc -l)
                
                if [[ $en_files -gt 0 ]]; then
                    print_success "Found $en_files files without Japanese content"
                fi
                
                if [[ $ja_contamination -gt 0 ]]; then
                    print_warning "Found Japanese content in $ja_contamination files (should be English only)"
                fi
            fi
            ;;
        *)
            print_info "No specific language checks for $version"
            ;;
    esac
}

# Function to compare versions
compare_versions() {
    local version1="$1"
    local version2="$2"
    
    print_info "Comparing $version1 and $version2..."
    
    # Compare command counts
    if [[ -d "$VERSIONS_DIR/$version1/commands" ]] && [[ -d "$VERSIONS_DIR/$version2/commands" ]]; then
        local count1=$(find "$VERSIONS_DIR/$version1/commands" -name "*.md" -type f | wc -l)
        local count2=$(find "$VERSIONS_DIR/$version2/commands" -name "*.md" -type f | wc -l)
        
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        if [[ $count1 -eq $count2 ]]; then
            print_success "Command file count matches ($count1 files)"
        else
            print_error "Command file count mismatch ($version1: $count1, $version2: $count2)"
        fi
    fi
    
    # Compare role counts
    if [[ -d "$VERSIONS_DIR/$version1/agents/roles" ]] && [[ -d "$VERSIONS_DIR/$version2/agents/roles" ]]; then
        local count1=$(find "$VERSIONS_DIR/$version1/agents/roles" -name "*.md" -type f | wc -l)
        local count2=$(find "$VERSIONS_DIR/$version2/agents/roles" -name "*.md" -type f | wc -l)
        
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        if [[ $count1 -eq $count2 ]]; then
            print_success "Role file count matches ($count1 files)"
        else
            print_error "Role file count mismatch ($version1: $count1, $version2: $count2)"
        fi
    fi
    
    # Compare file names (structure consistency)
    print_info "Checking file name consistency..."
    local missing_in_v2=0
    
    for file in "$VERSIONS_DIR/$version1/commands"/*.md; do
        if [[ -f "$file" ]]; then
            local basename=$(basename "$file")
            if [[ ! -f "$VERSIONS_DIR/$version2/commands/$basename" ]]; then
                print_warning "Missing in $version2: commands/$basename"
                missing_in_v2=$((missing_in_v2 + 1))
            fi
        fi
    done
    
    if [[ $missing_in_v2 -eq 0 ]]; then
        print_success "All command files have corresponding entries"
    fi
}

# Function to generate report
generate_report() {
    echo ""
    echo "================================"
    echo "Validation Summary"
    echo "================================"
    echo "Total checks: $TOTAL_CHECKS"
    echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
    echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
    
    if [[ $FAILED_CHECKS -eq 0 ]]; then
        echo ""
        print_success "All validation checks passed!"
        return 0
    else
        echo ""
        print_error "Validation failed with $FAILED_CHECKS error(s)"
        return 1
    fi
}

# Main execution
main() {
    echo "================================"
    echo "Version Validation Tool"
    echo "================================"
    echo ""
    
    # Check if versions directory exists
    if [[ ! -d "$VERSIONS_DIR" ]]; then
        print_error "Versions directory not found: $VERSIONS_DIR"
        exit 1
    fi
    
    # Parse arguments
    if [[ $# -eq 0 ]]; then
        # Validate all versions
        print_info "Validating all versions..."
        echo ""
        
        for version_dir in "$VERSIONS_DIR"/*; do
            if [[ -d "$version_dir" ]]; then
                local version=$(basename "$version_dir")
                echo "────────────────────────────────"
                echo "Version: $version"
                echo "────────────────────────────────"
                check_structure "$version"
                count_files "$version"
                check_language_content "$version"
                echo ""
            fi
        done
        
        # Compare versions if multiple exist
        local versions=($(ls -d "$VERSIONS_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
        if [[ ${#versions[@]} -ge 2 ]]; then
            echo "────────────────────────────────"
            echo "Version Comparison"
            echo "────────────────────────────────"
            compare_versions "${versions[0]}" "${versions[1]}"
        fi
        
    else
        # Validate specific version
        local version="$1"
        
        if [[ ! -d "$VERSIONS_DIR/$version" ]]; then
            print_error "Version not found: $version"
            print_info "Available versions:"
            for dir in "$VERSIONS_DIR"/*; do
                if [[ -d "$dir" ]]; then
                    echo "  - $(basename "$dir")"
                fi
            done
            exit 1
        fi
        
        check_structure "$version"
        count_files "$version"
        check_language_content "$version"
        
        # If second argument provided, compare with it
        if [[ -n "$2" ]]; then
            echo ""
            compare_versions "$version" "$2"
        fi
    fi
    
    generate_report
}

main "$@"
