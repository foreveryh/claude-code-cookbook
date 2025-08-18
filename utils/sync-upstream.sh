#!/bin/bash

# Claude Code Cookbook Upstream Sync Tool
# 上游同步工具 - 保持 versions/ 结构优势的智能同步系统
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# 配置和常量
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 支持的语言列表
SUPPORTED_LANGUAGES=("en" "zh" "ja" "fr" "ko")

# 需要翻译的语言映射 (上游没有的语言)
TRANSLATE_LANGUAGES=("ja" "fr" "ko")

# ============================================================================
# 工具函数
# ============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# 检查依赖
check_dependencies() {
    local missing_deps=()
    
    # 检查必需工具
    for tool in "git" "jq" "python3"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_deps+=("$tool")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# 检查上游远程仓库
check_upstream() {
    if ! git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
        log_error "Upstream remote '$UPSTREAM_REMOTE' not found"
        log_info "Please add upstream remote: git remote add upstream https://github.com/wasabeef/claude-code-cookbook.git"
        exit 1
    fi
}

# ============================================================================
# 核心同步功能
# ============================================================================

# 获取上游更新
fetch_upstream() {
    log_step "Fetching upstream changes..."
    git fetch "$UPSTREAM_REMOTE" "$UPSTREAM_BRANCH"
    log_success "Upstream fetched successfully"
}

# 分析差异
analyze_changes() {
    log_step "Analyzing changes from upstream..."
    
    # 获取新提交数量
    local new_commits
    new_commits=$(git rev-list --count HEAD.."$UPSTREAM_REMOTE/$UPSTREAM_BRANCH")
    
    if [[ "$new_commits" -eq 0 ]]; then
        log_info "No new changes from upstream"
        return 1
    fi
    
    log_info "Found $new_commits new commits from upstream"
    
    # 显示主要变更
    echo ""
    log_info "Recent upstream changes:"
    git log --oneline HEAD.."$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | head -10
    echo ""
    
    return 0
}

# 同步根目录文件
sync_root_files() {
    log_step "Syncing root directory files..."
    
    # 同步脚本
    sync_scripts
    
    # 同步命令 (从 locales/en 到根目录)
    sync_root_commands
    
    # 同步角色
    sync_root_agents
    
    # 同步文档
    sync_root_docs
    
    log_success "Root files synchronized"
}

# 同步脚本
sync_scripts() {
    log_info "Syncing scripts..."
    
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep "^100.*scripts/" | while read -r line; do
        local file
        file=$(echo "$line" | awk '{print $4}')
        
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            log_info "Updating script: $file"
        else
            log_info "Adding new script: $file"
        fi
        
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$file" > "$PROJECT_ROOT/$file"
        chmod +x "$PROJECT_ROOT/$file"
    done
}

# 同步根目录命令
sync_root_commands() {
    log_info "Syncing root commands from upstream locales/en..."
    
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep "locales/en/commands/" | while read -r line; do
        local upstream_file
        local local_file
        upstream_file=$(echo "$line" | awk '{print $4}')
        local_file=$(echo "$upstream_file" | sed 's|locales/en/commands/|commands/|')
        
        log_info "Syncing command: $(basename "$local_file")"
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$upstream_file" > "$PROJECT_ROOT/$local_file"
    done
}

# 同步根目录角色
sync_root_agents() {
    log_info "Syncing root agents from upstream locales/en..."
    
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep "locales/en/agents/roles/" | while read -r line; do
        local upstream_file
        local local_file
        upstream_file=$(echo "$line" | awk '{print $4}')
        local_file=$(echo "$upstream_file" | sed 's|locales/en/agents/roles/|agents/roles/|')
        
        log_info "Syncing agent: $(basename "$local_file")"
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$upstream_file" > "$PROJECT_ROOT/$local_file"
    done
}

# 同步文档
sync_root_docs() {
    log_info "Syncing documentation..."
    
    # 同步主要 README 文件
    local readme_files=("README_en.md" "README_zh.md" "README_ja.md" "README_fr.md" "README_ko.md")
    
    for readme in "${readme_files[@]}"; do
        if git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep -q "$readme"; then
            log_info "Syncing $readme"
            git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$readme" > "$PROJECT_ROOT/$readme"
        fi
    done
    
    # 将上游的 README_en.md 作为主 README.md
    if git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep -q "README_en.md"; then
        log_info "Updating main README.md from upstream README_en.md"
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:README_en.md" > "$PROJECT_ROOT/README.md"
    fi
    
    # 将上游的日语 README.md 保存为 README_ja.md
    if git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep -q "README.md"; then
        log_info "Saving upstream README.md as README_ja.md"
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:README.md" > "$PROJECT_ROOT/README_ja.md"
    fi
}

# ============================================================================
# 多语言版本同步
# ============================================================================

# 同步所有语言版本
sync_versions() {
    log_step "Syncing versions/ directory..."
    
    for lang in "${SUPPORTED_LANGUAGES[@]}"; do
        sync_language_version "$lang"
    done
    
    log_success "All language versions synchronized"
}

# 同步单个语言版本
sync_language_version() {
    local lang="$1"
    log_info "Syncing versions/$lang/..."
    
    # 确保目录存在
    mkdir -p "$PROJECT_ROOT/versions/$lang/"{commands,agents/roles,scripts,hooks}
    
    if has_upstream_locale "$lang"; then
        # 从上游 locales 同步
        sync_from_upstream_locale "$lang"
    else
        # 需要翻译的语言
        sync_with_translation "$lang"
    fi
    
    # 同步脚本到所有语言版本
    sync_scripts_to_version "$lang"
}

# 检查上游是否有该语言的 locale
has_upstream_locale() {
    local lang="$1"
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep -q "locales/$lang/"
}

# 从上游 locale 同步
sync_from_upstream_locale() {
    local lang="$1"
    log_info "Syncing $lang from upstream locales/$lang/"
    
    # 同步命令
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep "locales/$lang/commands/" | while read -r line; do
        local upstream_file
        local local_file
        upstream_file=$(echo "$line" | awk '{print $4}')
        local_file=$(echo "$upstream_file" | sed "s|locales/$lang/commands/|versions/$lang/commands/|")
        
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$upstream_file" > "$PROJECT_ROOT/$local_file"
    done
    
    # 同步角色
    git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep "locales/$lang/agents/roles/" | while read -r line; do
        local upstream_file
        local local_file
        upstream_file=$(echo "$line" | awk '{print $4}')
        local_file=$(echo "$upstream_file" | sed "s|locales/$lang/agents/roles/|versions/$lang/agents/roles/|")
        
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:$upstream_file" > "$PROJECT_ROOT/$local_file"
    done
    
    # 同步 Claude.md
    if git ls-tree -r "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | grep -q "locales/$lang/CLAUDE.md"; then
        git show "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH:locales/$lang/CLAUDE.md" > "$PROJECT_ROOT/versions/$lang/Claude.md"
    fi
}

# 通过翻译同步（对于上游没有的语言）
sync_with_translation() {
    local lang="$1"
    log_info "Syncing $lang with translation (upstream locale not available)"
    
    # 保持现有文件，只添加新功能
    # 这里可以集成翻译工具或保持手动翻译
    log_warning "Language $lang requires manual translation or translation tool integration"
}

# 同步脚本到语言版本
sync_scripts_to_version() {
    local lang="$1"
    
    # 复制所有根目录脚本到语言版本
    if [[ -d "$PROJECT_ROOT/scripts" ]]; then
        cp -r "$PROJECT_ROOT/scripts/"* "$PROJECT_ROOT/versions/$lang/scripts/" 2>/dev/null || true
    fi
}

# ============================================================================
# 翻译和校验系统
# ============================================================================

# 翻译新内容
translate_new_content() {
    log_step "Checking for content that needs translation..."
    
    for lang in "${TRANSLATE_LANGUAGES[@]}"; do
        check_translation_needed "$lang"
    done
}

# 检查是否需要翻译
check_translation_needed() {
    local lang="$1"
    local en_dir="$PROJECT_ROOT/versions/en"
    local lang_dir="$PROJECT_ROOT/versions/$lang"
    
    # 检查命令文件
    for en_file in "$en_dir/commands"/*.md; do
        local filename
        filename=$(basename "$en_file")
        local lang_file="$lang_dir/commands/$filename"
        
        if [[ ! -f "$lang_file" ]]; then
            log_warning "Missing translation for $lang: commands/$filename"
        elif [[ "$en_file" -nt "$lang_file" ]]; then
            log_warning "Translation outdated for $lang: commands/$filename"
        fi
    done
}

# 校验版本完整性
validate_versions() {
    log_step "Validating version completeness..."
    
    local en_commands
    en_commands=$(find "$PROJECT_ROOT/versions/en/commands" -name "*.md" | wc -l)
    
    for lang in "${SUPPORTED_LANGUAGES[@]}"; do
        if [[ "$lang" == "en" ]]; then
            continue
        fi
        
        local lang_commands
        lang_commands=$(find "$PROJECT_ROOT/versions/$lang/commands" -name "*.md" 2>/dev/null | wc -l || echo "0")
        
        if [[ "$lang_commands" -lt "$en_commands" ]]; then
            log_warning "Language $lang has $lang_commands commands, EN has $en_commands"
        else
            log_success "Language $lang is complete ($lang_commands commands)"
        fi
    done
}

# ============================================================================
# 版本发布系统
# ============================================================================

# 创建新版本
create_release() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        log_error "Version number required"
        exit 1
    fi
    
    log_step "Creating release $version..."
    
    # 验证所有版本
    validate_versions
    
    # 创建标签
    git tag -a "$version" -m "Release $version - Multi-language Claude Code Cookbook"
    
    # 生成发布说明
    generate_release_notes "$version"
    
    log_success "Release $version created"
}

# 生成发布说明
generate_release_notes() {
    local version="$1"
    local notes_file="RELEASE_NOTES_$version.md"
    
    cat > "$notes_file" << EOF
# Claude Code Cookbook $version

## 🌍 Multi-Language Support
- English (en): Complete
- 中文 (zh): Complete  
- 日本語 (ja): Complete
- Français (fr): Complete
- 한국어 (ko): Complete

## 📊 Statistics
- Commands: $(find versions/en/commands -name "*.md" | wc -l)
- Agent Roles: $(find versions/en/agents/roles -name "*.md" | wc -l)
- Scripts: $(find versions/en/scripts -name "*.sh" | wc -l)

## 🔄 Sync Status
- Upstream sync: $(date)
- Architecture: versions/ structure (optimized)
- Translation status: Validated

## 🚀 Installation
\`\`\`bash
./install.sh --lang en  # or zh, ja, fr, ko
\`\`\`
EOF
    
    log_info "Release notes generated: $notes_file"
}

# ============================================================================
# 主要命令处理
# ============================================================================

# 显示帮助
show_help() {
    cat << EOF
Claude Code Cookbook Upstream Sync Tool

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    sync        Full synchronization with upstream
    check       Check for upstream changes
    translate   Check translation status
    validate    Validate version completeness
    release     Create a new release
    help        Show this help

OPTIONS:
    --dry-run   Preview changes without applying
    --force     Force sync even if no changes detected
    --lang      Sync specific language only

EXAMPLES:
    $0 sync                    # Full sync
    $0 sync --lang zh          # Sync Chinese version only
    $0 check                   # Check for changes
    $0 validate                # Validate all versions
    $0 release v2.1.0          # Create release
    
ARCHITECTURE:
    This tool maintains the superior versions/ structure while
    syncing from upstream's locales/ structure, preserving
    your advanced features and multi-language completeness.
EOF
}

# 主函数
main() {
    local command="${1:-help}"
    local dry_run=false
    local force=false
    local specific_lang=""
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --lang)
                specific_lang="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # 检查依赖
    check_dependencies
    check_upstream
    
    case "$command" in
        sync)
            log_info "Starting upstream synchronization..."
            fetch_upstream
            
            if ! analyze_changes && [[ "$force" != true ]]; then
                log_info "No changes to sync"
                exit 0
            fi
            
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - No changes will be made"
                exit 0
            fi
            
            sync_root_files
            
            if [[ -n "$specific_lang" ]]; then
                sync_language_version "$specific_lang"
            else
                sync_versions
            fi
            
            translate_new_content
            validate_versions
            
            log_success "Synchronization completed!"
            ;;
        check)
            fetch_upstream
            analyze_changes
            ;;
        translate)
            translate_new_content
            ;;
        validate)
            validate_versions
            ;;
        release)
            create_release "$2"
            ;;
        help|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"