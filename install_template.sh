#!/bin/bash

# Unified Claude Code Cookbook Installer
# Version: 2.0.0
# Supports: English (en), Chinese (zh)

set -euo pipefail

# ============================================================================
# GLOBAL VARIABLES AND DEFAULTS
# ============================================================================

SCRIPT_VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
DEFAULT_LANG=""
DEFAULT_MODEL="ppinfra"
DEFAULT_GPU="auto"
DEFAULT_SOURCE="local"
DEFAULT_TARGET="$HOME/.claude"
DEFAULT_BACKUP="prompt"
DEFAULT_VERIFY=true
DRY_RUN=false

# Current configuration (will be set from args/defaults)
INSTALL_LANG=""
INSTALL_MODEL=""
INSTALL_GPU=""
INSTALL_SOURCE=""
INSTALL_TARGET=""
INSTALL_BACKUP=""
INSTALL_VERIFY=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# INTERNATIONALIZATION (i18n) SYSTEM
# ============================================================================

# English messages
declare -A MESSAGES_EN=(
    [BANNER_TITLE]="Claude Code Cookbook Installer"
    [BANNER_VERSION]="Version"
    [CHECKING_DEPS]="Checking dependencies..."
    [INSTALL_SUCCESS]="Installation completed successfully!"
    [SELECT_LANG]="Please select your language:"
    [BACKUP_PROMPT]="Backup existing installation?"
    [VERIFY_INSTALL]="Verifying installation..."
    [ENV_CHECK]="Checking environment..."
    [PREREQ_INSTALL]="Installing prerequisites..."
    [MODEL_SETUP]="Setting up AI model backend..."
    [GPU_CONFIG]="Configuring GPU acceleration..."
    [POST_TEST]="Running post-installation tests..."
    [LANG_AUTO_DETECT]="Auto-detected language"
    [LANG_MENU_PROMPT]="Enter your choice (1-2):"
    [INVALID_CHOICE]="Invalid choice. Please try again."
    [ERROR_DEPS_MISSING]="Missing required dependencies"
    [ERROR_PERMISSION]="Permission denied"
    [ERROR_DISK_SPACE]="Insufficient disk space"
    [WARNING_BACKUP]="Existing installation found"
    [INFO_DRY_RUN]="DRY RUN MODE - No changes will be made"
    [SUCCESS_BACKUP]="Backup created successfully"
    [HELP_USAGE]="Usage"
    [HELP_OPTIONS]="Options"
    [HELP_EXAMPLES]="Examples"
    [YES]="y"
    [NO]="n"
    [ENGLISH]="English"
    [CHINESE]="中文 Chinese"
)

# Chinese messages
declare -A MESSAGES_ZH=(
    [BANNER_TITLE]="Claude Code Cookbook 安装程序"
    [BANNER_VERSION]="版本"
    [CHECKING_DEPS]="检查依赖项..."
    [INSTALL_SUCCESS]="安装成功完成！"
    [SELECT_LANG]="请选择您的语言："
    [BACKUP_PROMPT]="是否备份现有安装？"
    [VERIFY_INSTALL]="验证安装..."
    [ENV_CHECK]="检查环境..."
    [PREREQ_INSTALL]="安装前置要求..."
    [MODEL_SETUP]="设置AI模型后端..."
    [GPU_CONFIG]="配置GPU加速..."
    [POST_TEST]="运行安装后测试..."
    [LANG_AUTO_DETECT]="自动检测语言"
    [LANG_MENU_PROMPT]="请输入您的选择 (1-2)："
    [INVALID_CHOICE]="无效选择，请重试。"
    [ERROR_DEPS_MISSING]="缺少必需的依赖项"
    [ERROR_PERMISSION]="权限被拒绝"
    [ERROR_DISK_SPACE]="磁盘空间不足"
    [WARNING_BACKUP]="发现现有安装"
    [INFO_DRY_RUN]="预演模式 - 不会进行任何更改"
    [SUCCESS_BACKUP]="备份创建成功"
    [HELP_USAGE]="用法"
    [HELP_OPTIONS]="选项"
    [HELP_EXAMPLES]="示例"
    [YES]="y"
    [NO]="n"
    [ENGLISH]="English 英语"
    [CHINESE]="中文"
)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Get localized message
msg() {
    local key="$1"
    local lang_var="MESSAGES_${INSTALL_LANG^^}"
    
    if [[ -v $lang_var ]]; then
        local -n messages=$lang_var
        echo "${messages[$key]:-$key}"
    else
        echo "$key"
    fi
}

# Print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================================
# LANGUAGE DETECTION AND SELECTION
# ============================================================================

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

show_language_menu() {
    echo ""
    print_info "$(msg SELECT_LANG)"
    echo "1) $(msg ENGLISH)"
    echo "2) $(msg CHINESE)"
    echo ""
    
    while true; do
        read -p "$(msg LANG_MENU_PROMPT) " choice
        
        case $choice in
            1) echo "en"; return ;;
            2) echo "zh"; return ;;
            *) print_error "$(msg INVALID_CHOICE)" ;;
        esac
    done
}

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
    
    # 3. Interactive menu fallback
    # Set temporary language to English for menu
    INSTALL_LANG="en"
    INSTALL_LANG=$(show_language_menu)
}

# ============================================================================
# BANNER AND HELP
# ============================================================================

show_banner() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         $(msg BANNER_TITLE)         ║${NC}"
    echo -e "${CYAN}║              $(msg BANNER_VERSION) $SCRIPT_VERSION                    ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_help() {
    cat << EOF
$(msg BANNER_TITLE) v$SCRIPT_VERSION

$(msg HELP_USAGE):
    $0 [OPTIONS]

$(msg HELP_OPTIONS):
    --lang {en,zh}              Installation language
    --model {gemini,ppinfra,openai}  AI model backend (default: ppinfra)
    --gpu {auto,cuda,metal,none}     GPU acceleration (default: auto)
    --source {local,remote}          Installation source (default: local)
    --target <path>                  Target directory (default: $HOME/.claude)
    --backup {auto,prompt,skip}      Backup strategy (default: prompt)
    --dry-run                        Preview mode, no changes made
    --no-verify                      Skip post-installation verification
    --help                           Show this help message
    --version                        Show version information

$(msg HELP_EXAMPLES):
    # Default installation with auto-detected language
    $0

    # Chinese installation with automatic backup
    $0 --lang zh --backup auto

    # Development setup with specific model
    $0 --lang en --model gemini --target ./test-install --dry-run

    # Automated installation for CI/CD
    $0 --lang en --model ppinfra --backup skip --no-verify
EOF
}

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang)
                if [[ "$2" =~ ^(en|zh)$ ]]; then
                    DEFAULT_LANG="$2"
                    shift 2
                else
                    print_error "Invalid language: $2. Supported: en, zh"
                    exit 1
                fi
                ;;
            --model)
                if [[ "$2" =~ ^(gemini|ppinfra|openai)$ ]]; then
                    DEFAULT_MODEL="$2"
                    shift 2
                else
                    print_error "Invalid model: $2. Supported: gemini, ppinfra, openai"
                    exit 1
                fi
                ;;
            --gpu)
                if [[ "$2" =~ ^(auto|cuda|metal|none)$ ]]; then
                    DEFAULT_GPU="$2"
                    shift 2
                else
                    print_error "Invalid GPU option: $2. Supported: auto, cuda, metal, none"
                    exit 1
                fi
                ;;
            --source)
                if [[ "$2" =~ ^(local|remote)$ ]]; then
                    DEFAULT_SOURCE="$2"
                    shift 2
                else
                    print_error "Invalid source: $2. Supported: local, remote"
                    exit 1
                fi
                ;;
            --target)
                DEFAULT_TARGET="$2"
                shift 2
                ;;
            --backup)
                if [[ "$2" =~ ^(auto|prompt|skip)$ ]]; then
                    DEFAULT_BACKUP="$2"
                    shift 2
                else
                    print_error "Invalid backup option: $2. Supported: auto, prompt, skip"
                    exit 1
                fi
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-verify)
                DEFAULT_VERIFY=false
                shift
                ;;
            --help|-h)
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
    
    # Set final configuration
    INSTALL_MODEL="$DEFAULT_MODEL"
    INSTALL_GPU="$DEFAULT_GPU"
    INSTALL_SOURCE="$DEFAULT_SOURCE"
    INSTALL_TARGET="$DEFAULT_TARGET"
    INSTALL_BACKUP="$DEFAULT_BACKUP"
    INSTALL_VERIFY="$DEFAULT_VERIFY"
}

# ============================================================================
# INSTALLATION STEPS
# ============================================================================

check_environment() {
    print_info "$(msg ENV_CHECK)"
    
    # Check shell version
    if [[ ${BASH_VERSION%%.*} -lt 4 ]]; then
        print_error "Bash 4.0+ required. Current: $BASH_VERSION"
        exit 1
    fi
    
    # Check disk space (500MB minimum)
    local free_space
    if command -v df >/dev/null; then
        free_space=$(df -m "$HOME" | awk 'NR==2 {print $4}')
        if [[ $free_space -lt 500 ]]; then
            print_error "$(msg ERROR_DISK_SPACE): ${free_space}MB < 500MB"
            exit 1
        fi
    fi
    
    # Check write permissions
    if [[ ! -w "$(dirname "$INSTALL_TARGET")" ]]; then
        print_error "$(msg ERROR_PERMISSION): $(dirname "$INSTALL_TARGET")"
        exit 1
    fi
    
    print_success "Environment check passed"
}

check_dependencies() {
    print_info "$(msg CHECKING_DEPS)"
    local missing_deps=()
    
    # Check required tools
    local required_tools=("git" "curl")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    # Check optional tools
    if [[ "$INSTALL_MODEL" == "ppinfra" ]] && ! command -v "python3" >/dev/null; then
        print_warning "Python3 recommended for PPINFRA model"
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "$(msg ERROR_DEPS_MISSING): ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "Dependencies check passed"
}

install_prerequisites() {
    print_info "$(msg PREREQ_INSTALL)"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "$(msg INFO_DRY_RUN) - Prerequisites installation skipped"
        return
    fi
    
    # Model-specific prerequisites
    case "$INSTALL_MODEL" in
        "ppinfra")
            echo "Setting up PPINFRA model configuration..."
            ;;
        "gemini")
            echo "Setting up Gemini API configuration..."
            ;;
        "openai")
            echo "Setting up OpenAI API configuration..."
            ;;
    esac
    
    print_success "Prerequisites installed"
}

perform_installation() {
    print_info "Starting installation..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "$(msg INFO_DRY_RUN)"
        echo "Would install to: $INSTALL_TARGET"
        echo "Would use model: $INSTALL_MODEL"
        echo "Would use GPU: $INSTALL_GPU"
        echo "Would use source: $INSTALL_SOURCE"
        return
    fi
    
    # Handle existing installation
    handle_existing_installation
    
    # Perform actual installation based on source
    case "$INSTALL_SOURCE" in
        "local")
            install_from_local
            ;;
        "remote")
            install_from_remote
            ;;
    esac
    
    # Configure model backend
    configure_model_backend
    
    print_success "$(msg INSTALL_SUCCESS)"
}

handle_existing_installation() {
    if [[ ! -d "$INSTALL_TARGET" ]]; then
        return
    fi
    
    print_warning "$(msg WARNING_BACKUP)"
    
    case "$INSTALL_BACKUP" in
        "auto")
            create_backup
            ;;
        "prompt")
            read -p "$(msg BACKUP_PROMPT) ($(msg YES)/$(msg NO)): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                create_backup
            else
                rm -rf "$INSTALL_TARGET"
            fi
            ;;
        "skip")
            rm -rf "$INSTALL_TARGET"
            ;;
    esac
}

create_backup() {
    local backup_name=".claude_backup_$(date +%Y%m%d_%H%M%S)"
    local backup_path="$(dirname "$INSTALL_TARGET")/$backup_name"
    
    mv "$INSTALL_TARGET" "$backup_path"
    print_success "$(msg SUCCESS_BACKUP): $backup_path"
}

install_from_local() {
    local source_dir="$SCRIPT_DIR/versions/$INSTALL_LANG"
    
    if [[ ! -d "$source_dir" ]]; then
        print_error "Local version not found: $source_dir"
        exit 1
    fi
    
    cp -r "$source_dir" "$INSTALL_TARGET"
    chmod +x "$INSTALL_TARGET/scripts"/*.sh 2>/dev/null || true
}

install_from_remote() {
    # Clone repository and setup
    git clone https://github.com/foreveryh/claude-code-cookbook.git "$INSTALL_TARGET"
    cd "$INSTALL_TARGET"
    
    # Switch to appropriate language version
    if [[ -d "versions/$INSTALL_LANG" ]]; then
        cp -r "versions/$INSTALL_LANG"/* .
    fi
}

configure_model_backend() {
    print_info "$(msg MODEL_SETUP)"
    
    # Create model configuration
    case "$INSTALL_MODEL" in
        "ppinfra")
            configure_ppinfra_model
            ;;
        "gemini")
            configure_gemini_model
            ;;
        "openai")
            configure_openai_model
            ;;
    esac
    
    print_info "$(msg GPU_CONFIG)"
    configure_gpu_acceleration
}

configure_ppinfra_model() {
    cat > "$INSTALL_TARGET/.env" << EOF
# PPINFRA Configuration
PPINFRA_API_KEY=your_api_key_here
PPINFRA_MODEL=qwen/qwen3-235b-a22b-thinking-2507
PPINFRA_MAX_TOKENS=120000
EOF
}

configure_gemini_model() {
    cat > "$INSTALL_TARGET/.env" << EOF
# Gemini Configuration
GEMINI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-pro
EOF
}

configure_openai_model() {
    cat > "$INSTALL_TARGET/.env" << EOF
# OpenAI Configuration
OPENAI_API_KEY=your_api_key_here
OPENAI_MODEL=gpt-4
EOF
}

configure_gpu_acceleration() {
    case "$INSTALL_GPU" in
        "auto")
            # Auto-detect GPU capabilities
            if command -v nvidia-smi >/dev/null; then
                echo "GPU_ACCELERATION=cuda" >> "$INSTALL_TARGET/.env"
            elif [[ "$(uname)" == "Darwin" ]]; then
                echo "GPU_ACCELERATION=metal" >> "$INSTALL_TARGET/.env"
            else
                echo "GPU_ACCELERATION=none" >> "$INSTALL_TARGET/.env"
            fi
            ;;
        *)
            echo "GPU_ACCELERATION=$INSTALL_GPU" >> "$INSTALL_TARGET/.env"
            ;;
    esac
}

verify_installation() {
    if [[ "$INSTALL_VERIFY" != true ]]; then
        return
    fi
    
    print_info "$(msg VERIFY_INSTALL)"
    print_info "$(msg POST_TEST)"
    
    local checks_passed=true
    
    # Check directory structure
    local required_dirs=("commands" "agents" "scripts")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$INSTALL_TARGET/$dir" ]]; then
            print_error "Missing directory: $dir"
            checks_passed=false
        fi
    done
    
    # Check configuration files
    if [[ ! -f "$INSTALL_TARGET/.env" ]]; then
        print_error "Missing configuration file: .env"
        checks_passed=false
    fi
    
    if $checks_passed; then
        print_success "Installation verification passed"
        
        # Show installation summary
        local cmd_count=$(find "$INSTALL_TARGET/commands" -name "*.md" -type f 2>/dev/null | wc -l)
        local role_count=$(find "$INSTALL_TARGET/agents/roles" -name "*.md" -type f 2>/dev/null | wc -l)
        
        echo ""
        echo "Installation Summary:"
        echo "  • Language: $INSTALL_LANG"
        echo "  • Model: $INSTALL_MODEL"
        echo "  • GPU: $INSTALL_GPU"
        echo "  • Target: $INSTALL_TARGET"
        echo "  • Commands: $cmd_count"
        echo "  • Roles: $role_count"
    else
        print_error "Installation verification failed"
        exit 1
    fi
}

show_completion_message() {
    echo ""
    echo "════════════════════════════════════════════════"
    print_success "$(msg INSTALL_SUCCESS)"
    echo ""
    echo "Location: $INSTALL_TARGET"
    echo "Language: $INSTALL_LANG"
    echo "Model: $INSTALL_MODEL"
    echo ""
    echo "Next Steps:"
    echo "1. Configure your API keys in: $INSTALL_TARGET/.env"
    echo "2. Open Claude Desktop and set MCP server path"
    echo "3. Start using Claude Code Cookbook! 🎉"
    echo "════════════════════════════════════════════════"
    echo ""
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    # Parse command line arguments first
    parse_arguments "$@"
    
    # Determine language (may show menu in English)
    determine_language
    
    # Show banner with localized messages
    show_banner
    
    # Show dry run notice if enabled
    if [[ "$DRY_RUN" == true ]]; then
        print_info "$(msg INFO_DRY_RUN)"
        echo ""
    fi
    
    # Execute installation steps
    check_environment
    check_dependencies
    install_prerequisites
    perform_installation
    verify_installation
    show_completion_message
}

# Run main function with all arguments
main "$@"
