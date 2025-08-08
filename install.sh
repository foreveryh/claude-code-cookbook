#!/bin/bash

# Claude Code Cookbook Unified Installer
# Version: 2.0.0
# Supports: English (en), Chinese (zh)
# Author: Claude Code Cookbook Team

# Enable strict error handling
set -euo pipefail

# Error trap for better debugging
trap 'echo "Error occurred on line $LINENO. Exit code: $?" >&2' ERR

# ============================================================================
# GLOBAL VARIABLES AND CONFIGURATION
# ============================================================================

SCRIPT_VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSIONS_DIR="$SCRIPT_DIR/versions"
CLAUDE_DIR="$HOME/.claude"

# Default configuration
DEFAULT_LANG=""
DEFAULT_MODEL="ppinfra"
INSTALL_LANG=""
DRY_RUN=false
SHOW_HELP=false
BACKUP_EXISTING=true
VERIFY_INSTALL=true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# INTERNATIONALIZATION SYSTEM
# ============================================================================

# Get localized message function - Compatible with bash 3+
get_message() {
    local key="$1"
    local lang="${INSTALL_LANG:-en}"
    
    case "${lang}_${key}" in
        # English messages
        en_BANNER_TITLE) echo "Claude Code Cookbook Installer" ;;
        en_BANNER_VERSION) echo "Version" ;;
        en_CHECKING_DEPS) echo "Checking dependencies..." ;;
        en_INSTALL_SUCCESS) echo "Installation completed successfully!" ;;
        en_SELECT_LANG) echo "Please select your language:" ;;
        en_BACKUP_PROMPT) echo "Do you want to backup the existing .claude directory?" ;;
        en_VERIFY_INSTALL) echo "Verifying installation..." ;;
        en_LANG_AUTO_DETECT) echo "Auto-detected language" ;;
        en_LANG_MENU_PROMPT) echo "Enter your choice (1-2):" ;;
        en_INVALID_CHOICE) echo "Invalid choice. Please try again." ;;
        en_ERROR_DEPS_MISSING) echo "Missing required dependencies" ;;
        en_ERROR_PERMISSION) echo "Permission denied" ;;
        en_WARNING_BACKUP) echo "Existing .claude directory found" ;;
        en_SUCCESS_BACKUP) echo "Backup created successfully" ;;
        en_HELP_USAGE) echo "Usage" ;;
        en_HELP_OPTIONS) echo "Options" ;;
        en_HELP_EXAMPLES) echo "Examples" ;;
        en_YES) echo "y" ;;
        en_NO) echo "n" ;;
        en_ENGLISH) echo "English" ;;
        en_CHINESE) echo "中文 Chinese" ;;
        en_NEXT_STEPS) echo "Next Steps:" ;;
        en_CONFIGURE_API) echo "Configure your API keys in:" ;;
        en_OPEN_CLAUDE) echo "Open Claude Desktop and set Custom Instructions path" ;;
        en_START_USING) echo "Start using Claude Code Cookbook!" ;;
        en_LOCATION) echo "Location" ;;
        en_LANGUAGE) echo "Language" ;;
        en_COMPONENTS) echo "Installed components:" ;;
        en_COMMANDS) echo "Commands" ;;
        en_ROLES) echo "Roles" ;;
        en_SCRIPTS) echo "Scripts" ;;
        
        # Chinese messages (中文消息)
        zh_BANNER_TITLE) echo "Claude Code Cookbook 安装程序" ;;
        zh_BANNER_VERSION) echo "版本" ;;
        zh_CHECKING_DEPS) echo "检查依赖项..." ;;
        zh_INSTALL_SUCCESS) echo "安装成功完成！" ;;
        zh_SELECT_LANG) echo "请选择您的语言：" ;;
        zh_BACKUP_PROMPT) echo "是否要备份现有的 .claude 目录？" ;;
        zh_VERIFY_INSTALL) echo "验证安装..." ;;
        zh_LANG_AUTO_DETECT) echo "自动检测语言" ;;
        zh_LANG_MENU_PROMPT) echo "请输入您的选择 (1-2)：" ;;
        zh_INVALID_CHOICE) echo "无效选择，请重试。" ;;
        zh_ERROR_DEPS_MISSING) echo "缺少必需的依赖项" ;;
        zh_ERROR_PERMISSION) echo "权限被拒绝" ;;
        zh_WARNING_BACKUP) echo "发现现有的 .claude 目录" ;;
        zh_SUCCESS_BACKUP) echo "备份创建成功" ;;
        zh_HELP_USAGE) echo "用法" ;;
        zh_HELP_OPTIONS) echo "选项" ;;
        zh_HELP_EXAMPLES) echo "示例" ;;
        zh_YES) echo "y" ;;
        zh_NO) echo "n" ;;
        zh_ENGLISH) echo "English 英语" ;;
        zh_CHINESE) echo "中文" ;;
        zh_NEXT_STEPS) echo "下一步：" ;;
        zh_CONFIGURE_API) echo "配置您的 API 密钥：" ;;
        zh_OPEN_CLAUDE) echo "打开 Claude Desktop 并设置自定义指令路径" ;;
        zh_START_USING) echo "开始使用 Claude Code Cookbook！" ;;
        zh_LOCATION) echo "位置" ;;
        zh_LANGUAGE) echo "语言" ;;
        zh_COMPONENTS) echo "已安装组件：" ;;
        zh_COMMANDS) echo "命令" ;;
        zh_ROLES) echo "角色" ;;
        zh_SCRIPTS) echo "脚本" ;;
        
        # Default fallback
        *) echo "$key" ;;
    esac
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Simplified message function that uses get_message
msg() {
    get_message "$1"
}

# Print colored output with consistent formatting
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

# ============================================================================
# LANGUAGE DETECTION AND SELECTION FUNCTIONS
# ============================================================================

# Detect language from environment
detect_language_from_env() {
    local lang_env="${LANG:-}"
    
    case "$lang_env" in
        zh_CN*|zh_TW*|zh_HK*|zh_SG*|zh*)
            echo "zh"
            ;;
        en_US*|en_GB*|en_AU*|en_CA*|en*)
            echo "en"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Show language selection menu
show_language_menu() {
    echo "" >&2
    print_info "$(msg SELECT_LANG)" >&2
    echo "1) $(msg ENGLISH)" >&2
    echo "2) $(msg CHINESE)" >&2
    echo "" >&2
    
    while true; do
        printf "%s " "$(msg LANG_MENU_PROMPT)" >&2
        read choice
        
        case $choice in
            1) echo "en"; return ;;
            2) echo "zh"; return ;;
            *) print_error "$(msg INVALID_CHOICE)" >&2 ;;
        esac
    done
}

# Determine installation language
determine_language() {
    # 1. Command line flag takes precedence
    if [[ -n "$DEFAULT_LANG" ]]; then
        INSTALL_LANG="$DEFAULT_LANG"
        return
    fi
    
    # 2. Environment variable detection
    local detected_lang=$(detect_language_from_env)
    if [[ -n "$detected_lang" ]]; then
        INSTALL_LANG="$detected_lang"
        print_info "$(msg LANG_AUTO_DETECT): $INSTALL_LANG"
        return
    fi
    
    # 3. Interactive menu fallback (set temporary English for menu)
    INSTALL_LANG="en"
    INSTALL_LANG=$(show_language_menu)
}

# ============================================================================
# MODULAR INSTALLATION FUNCTIONS
# ============================================================================

# Display installation banner
show_banner() {
    local title="$(msg BANNER_TITLE)"
    local version_text="$(msg BANNER_VERSION) $SCRIPT_VERSION"
    
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
    printf "${CYAN}║ %-46s ║${NC}\n" "$title"
    printf "${CYAN}║ %-46s ║${NC}\n" "$version_text"
    echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check system dependencies
check_dependencies() {
    print_info "$(msg CHECKING_DEPS)"
    local missing_deps=()
    
    # Check required tools
    local required_tools=("git" "find" "cp" "mv")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_deps+=("$tool")
        fi
    done
    
    # Check write permissions
    if [[ ! -w "$(dirname "$CLAUDE_DIR")" ]]; then
        print_error "$(msg ERROR_PERMISSION): $(dirname "$CLAUDE_DIR")"
        exit 1
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "$(msg ERROR_DEPS_MISSING): ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "Dependencies check passed"
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

# Backup existing installation with bilingual prompts
backup_existing() {
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        return
    fi
    
    print_warning "$(msg WARNING_BACKUP)"
    
    local backup_name=".claude_backup_$(date +%Y%m%d_%H%M%S)"
    local backup_path="$HOME/$backup_name"
    
    read -p "$(msg BACKUP_PROMPT) ($(msg YES)/$(msg NO)): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv "$CLAUDE_DIR" "$backup_path"
        print_success "$(msg SUCCESS_BACKUP): $backup_path"
    else
        rm -rf "$CLAUDE_DIR"
        print_info "Removed existing .claude directory"
    fi
}

# Function to generate settings.json from template
generate_settings_json() {
    local lang="$1"
    local template_file="$SCRIPT_DIR/settings.json.template"
    local output_file="$CLAUDE_DIR/settings.json"
    
    if [[ ! -f "$template_file" ]]; then
        print_error "Settings template not found: $template_file"
        return 1
    fi
    
    print_info "Generating settings.json for language: $lang"
    
    # Define language-specific values
    local claude_language="$lang"
    local notification_waiting=""
    local notification_completed=""
    
    case "$lang" in
        "en")
            notification_waiting="Waiting for confirmation"
            notification_completed="Task completed"
            ;;
        "ja")
            notification_waiting="確認待ち"
            notification_completed="タスク完了"
            ;;
        "zh")
            notification_waiting="等待确认"
            notification_completed="任务完成"
            ;;
        *)
            # Default to English
            notification_waiting="Waiting for confirmation"
            notification_completed="Task completed"
            ;;
    esac
    
    # Use sed to replace placeholders (compatible with both macOS and Linux)
    sed -e "s/{{CLAUDE_LANGUAGE}}/$claude_language/g" \
        -e "s/{{NOTIFICATION_WAITING}}/$notification_waiting/g" \
        -e "s/{{NOTIFICATION_COMPLETED}}/$notification_completed/g" \
        "$template_file" > "$output_file"
    
    if [[ $? -eq 0 ]]; then
        print_success "Settings.json generated successfully"
    else
        print_error "Failed to generate settings.json"
        return 1
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
    
    # Create the target directory
    mkdir -p "$CLAUDE_DIR"

    # Copy version contents to .claude, excluding settings.json
    # Using find and cpio to handle potentially missing files/dirs gracefully
    (cd "$source_dir" && find . -name "settings.json" -prune -o -print | cpio -pdm "$CLAUDE_DIR")

    # Copy assets directory from root if it exists
    if [[ -d "$SCRIPT_DIR/assets" ]]; then
        print_info "Copying assets..."
        cp -r "$SCRIPT_DIR/assets" "$CLAUDE_DIR/"
    fi

    # Generate settings.json from template
    generate_settings_json "$version"

    # Copy language-specific Claude.md into ~/.claude/Claude.md
    copy_language_claude_md "$version"
    
    # Make scripts executable
    if [[ -d "$CLAUDE_DIR/scripts" ]]; then
        chmod +x "$CLAUDE_DIR/scripts"/*.sh 2>/dev/null || true
    fi
    
    print_success "Installation completed!"
}

# Copy the appropriate Claude.md into ~/.claude
copy_language_claude_md() {
    local lang="$1"
    local dest="$CLAUDE_DIR/Claude.md"

    # Preferred source: versions/<lang>/Claude.md
    local preferred_src="$VERSIONS_DIR/$lang/Claude.md"

    if [[ -f "$preferred_src" ]]; then
        cp "$preferred_src" "$dest"
        print_success "Copied Claude.md from versions/$lang"
        return 0
    fi

    print_warning "No Claude.md found for language '$lang' under versions/$lang. Skipping copy."
    return 0
}

# Configure model backend (PPINFRA by default per user rules)
config_models() {
    print_info "Configuring AI model backend..."
    
    # Create .env file with PPINFRA configuration
    cat > "$CLAUDE_DIR/.env" << EOF
# Claude Code Cookbook Model Configuration
# Generated by installer v$SCRIPT_VERSION on $(date)

# PPINFRA Configuration (Default)
PPINFRA_API_KEY=your_api_key_here
PPINFRA_MODEL=qwen/qwen3-235b-a22b-thinking-2507
PPINFRA_MAX_TOKENS=120000

# Alternative Models (Uncomment to use)
# PPINFRA_MODEL=moonshotai/kimi-k2-instruct
# PPINFRA_MODEL=deepseek/deepseek-r1-0528

# Gemini Configuration (Optional)
# GEMINI_API_KEY=your_gemini_key_here
# GEMINI_MODEL=gemini-pro

# Default Model Selection
DEFAULT_MODEL=$DEFAULT_MODEL
LANGUAGE=$INSTALL_LANG
EOF
    
    print_success "Model configuration completed"
}

# Function to verify installation
verify_installation() {
    if [[ "$VERIFY_INSTALL" != true ]]; then
        return
    fi
    
    print_info "$(msg VERIFY_INSTALL)"
    local checks_passed=true
    
    # Check directory structure
    local required_dirs=("commands" "agents" "hooks")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$CLAUDE_DIR/$dir" ]]; then
            print_error "Missing directory: $dir"
            checks_passed=false
        fi
    done
    
    # Check configuration files
    if [[ ! -f "$CLAUDE_DIR/.env" ]]; then
        print_error "Missing configuration file: .env"
        checks_passed=false
    fi
    
    if $checks_passed; then
        print_success "Installation verified successfully!"
        
        # Count installed items
        local cmd_count=$(find "$CLAUDE_DIR/commands" -name "*.md" -type f 2>/dev/null | wc -l)
        local role_count=0
        if [[ -d "$CLAUDE_DIR/agents/roles" ]]; then
            role_count=$(find "$CLAUDE_DIR/agents/roles" -name "*.md" -type f 2>/dev/null | wc -l)
        fi
        local script_count=0
        if [[ -d "$CLAUDE_DIR/scripts" ]]; then
            script_count=$(find "$CLAUDE_DIR/scripts" -name "*.sh" -type f 2>/dev/null | wc -l)
        fi
        
        echo ""
        echo "$(msg COMPONENTS)"
        echo "  • $(msg COMMANDS): $cmd_count"
        echo "  • $(msg ROLES): $role_count"
        echo "  • $(msg SCRIPTS): $script_count"
    else
        print_error "Installation verification failed"
        exit 1
    fi
}

# ============================================================================
# HELP AND ARGUMENT PARSING
# ============================================================================

# Show help message with bilingual usage examples
show_help() {
    # Set temporary English for help display
    local temp_lang="$INSTALL_LANG"
    INSTALL_LANG="en"
    
    cat << EOF
$(msg BANNER_TITLE) v$SCRIPT_VERSION

$(msg HELP_USAGE):
    $0 [OPTIONS]

$(msg HELP_OPTIONS):
    --lang {en,ja,zh,fr,ko}  Installation language
    --model {ppinfra,gemini} AI model backend (default: ppinfra)
    --target <path>          Target directory (default: $HOME/.claude)
    --dry-run               Preview mode, no changes made
    --no-verify             Skip post-installation verification
    --help, -h              Show this help message
    --version               Show version information

$(msg HELP_EXAMPLES):
    # Default installation with auto-detected language
    $0

    # Chinese installation
    $0 --lang zh

    # English installation with Gemini model
    $0 --lang en --model gemini

    # Development setup (dry run)
    $0 --lang en --target ./test-install --dry-run

    # Silent installation (no verification)
    $0 --lang zh --no-verify

Supported Languages:
    en - English
    ja - 日本語 (Japanese)
    zh - 中文 (Chinese)

For more information, visit:
    https://github.com/foreveryh/claude-code-cookbook
EOF
    
    # Restore language setting
    INSTALL_LANG="$temp_lang"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang)
                if [[ "$2" =~ ^(en|ja|zh|fr|ko)$ ]]; then
                    DEFAULT_LANG="$2"
                    shift 2
                else
                    print_error "Invalid language: $2. Supported: en, ja, zh, fr, ko"
                    exit 1
                fi
                ;;
            --model)
                if [[ "$2" =~ ^(ppinfra|gemini)$ ]]; then
                    DEFAULT_MODEL="$2"
                    shift 2
                else
                    print_error "Invalid model: $2. Supported: ppinfra, gemini"
                    exit 1
                fi
                ;;
            --target)
                CLAUDE_DIR="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-verify)
                VERIFY_INSTALL=false
                shift
                ;;
            --help|-h)
                INSTALL_LANG="en"  # Set English for help
                show_help
                exit 0
                ;;
            --version)
                echo "Claude Code Cookbook Installer v$SCRIPT_VERSION"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
}

# Display completion message with bilingual content
finish_banner() {
    echo ""
    echo "════════════════════════════════════════════════"
    print_success "$(msg INSTALL_SUCCESS)"
    echo ""
    echo "$(msg LOCATION): $CLAUDE_DIR"
    echo "$(msg LANGUAGE): $INSTALL_LANG"
    echo "Model: $DEFAULT_MODEL"
    echo ""
    echo "$(msg NEXT_STEPS)"
    case "$INSTALL_LANG" in
        "zh")
            echo "1. 配置 API 密钥: $CLAUDE_DIR/.env"
            echo "2. 打开 Claude Desktop → 设置 → 开发者"
            echo "3. 设置自定义指令路径: $CLAUDE_DIR"
            ;;
        *)
            echo "1. Configure API keys: $CLAUDE_DIR/.env"
            echo "2. Open Claude Desktop → Settings → Developer"
            echo "3. Set Custom Instructions path: $CLAUDE_DIR"
            ;;
    esac
    echo ""
    echo "$(msg START_USING) 🎉"
    echo "════════════════════════════════════════════════"
    echo ""
}

# ============================================================================
# MAIN INSTALLATION FLOW
# ============================================================================

# Main installation flow
main() {
    # Parse command line arguments first
    parse_arguments "$@"
    
    # Determine language (may show menu)
    determine_language
    
    # Ensure INSTALL_LANG is set before showing banner
    if [[ -z "$INSTALL_LANG" ]]; then
        INSTALL_LANG="en"
    fi
    
    # Show banner with localized messages
    show_banner
    
    # Show dry run notice if enabled
    if [[ "$DRY_RUN" == true ]]; then
        print_info "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    # Check environment and dependencies
    check_dependencies
    
    # Check if versions directory exists
    if [[ ! -d "$VERSIONS_DIR" ]]; then
        print_error "Versions directory not found: $VERSIONS_DIR"
        print_info "Please ensure you're running this script from the Claude Code Cookbook directory"
        exit 1
    fi
    
    # Determine installation version
    local versions=($(ls -d "$VERSIONS_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
    local selected_version="$INSTALL_LANG"
    
    # Check if the detected/selected language version exists
    if [[ ! " ${versions[@]} " =~ " ${selected_version} " ]]; then
        print_warning "Language version '$selected_version' not found"
        
        # Fallback to available versions
        if [[ ${#versions[@]} -eq 0 ]]; then
            print_error "No language versions found"
            exit 1
        elif [[ ${#versions[@]} -eq 1 ]]; then
            selected_version="${versions[0]}"
            print_info "Using available version: $selected_version"
        else
            print_info "Available versions: ${versions[*]}"
            selected_version="${versions[0]}"  # Use first available
            print_info "Using default version: $selected_version"
        fi
    fi
    
    echo ""
    print_info "Selected version: $selected_version"
    echo ""
    
    # Set the install language to match the selected version
    INSTALL_LANG="$selected_version"
    
    if [[ "$DRY_RUN" != true ]]; then
        # Backup existing .claude if present
        backup_existing
        
        # Install selected version
        install_version "$selected_version"
        
        # Configure model backend
        config_models
        
        # Verify installation
        echo ""
        verify_installation
    else
        print_info "Would install version: $selected_version"
        print_info "Would use model: $DEFAULT_MODEL"
        print_info "Would install to: $CLAUDE_DIR"
    fi
    
    # Show completion message
    finish_banner
}

# ============================================================================
# SCRIPT EXECUTION
# ============================================================================

# Run main function with all arguments
main "$@"
