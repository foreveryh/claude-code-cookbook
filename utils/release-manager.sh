#!/bin/bash

# Claude Code Cookbook Release Manager
# 版本发布管理工具 - 自动化版本发布和分发流程
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# 配置和常量
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RELEASE_DIR="$PROJECT_ROOT/releases"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 支持的语言
LANGUAGES=("en" "zh" "ja" "fr" "ko")

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

# 获取当前版本
get_current_version() {
    if git describe --tags --exact-match HEAD 2>/dev/null; then
        return
    fi
    
    local last_tag
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
    local commit_count
    commit_count=$(git rev-list --count "$last_tag"..HEAD 2>/dev/null || echo "0")
    
    if [[ "$commit_count" -gt 0 ]]; then
        echo "$last_tag-dev.$commit_count"
    else
        echo "$last_tag"
    fi
}

# 验证版本格式
validate_version() {
    local version="$1"
    if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?$ ]]; then
        log_error "Invalid version format: $version (expected: vX.Y.Z or vX.Y.Z-suffix)"
        return 1
    fi
}

# ============================================================================
# 版本统计和验证
# ============================================================================

# 统计版本内容
collect_version_stats() {
    local stats_file="$1"
    
    cat > "$stats_file" << EOF
# Claude Code Cookbook Statistics

## 📊 Content Statistics

EOF
    
    for lang in "${LANGUAGES[@]}"; do
        local lang_dir="$PROJECT_ROOT/versions/$lang"
        if [[ ! -d "$lang_dir" ]]; then
            continue
        fi
        
        local commands_count=0
        local agents_count=0
        local scripts_count=0
        
        if [[ -d "$lang_dir/commands" ]]; then
            commands_count=$(find "$lang_dir/commands" -name "*.md" | wc -l)
        fi
        
        if [[ -d "$lang_dir/agents/roles" ]]; then
            agents_count=$(find "$lang_dir/agents/roles" -name "*.md" | wc -l)
        fi
        
        if [[ -d "$lang_dir/scripts" ]]; then
            scripts_count=$(find "$lang_dir/scripts" -name "*.sh" | wc -l)
        fi
        
        cat >> "$stats_file" << EOF
### $lang
- Commands: $commands_count
- Agent Roles: $agents_count  
- Scripts: $scripts_count

EOF
    done
    
    cat >> "$stats_file" << EOF
## 🔧 Technical Details

- Architecture: versions/ structure
- Installation: Multi-language installer
- Sync: Upstream compatible
- Generated: $(date)

EOF
}

# 验证发布准备
validate_release_readiness() {
    log_step "Validating release readiness..."
    
    local issues=()
    
    # 检查工作目录是否干净
    if ! git diff --quiet; then
        issues+=("Working directory has uncommitted changes")
    fi
    
    # 检查是否有未跟踪的文件
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        issues+=("Working directory has untracked files")
    fi
    
    # 检查英语版本是否存在
    if [[ ! -d "$PROJECT_ROOT/versions/en" ]]; then
        issues+=("English version (versions/en) not found")
    fi
    
    # 检查关键文件
    local required_files=("install.sh" "README.md" "scripts/statusline.sh")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
            issues+=("Required file missing: $file")
        fi
    done
    
    # 检查版本完整性
    local en_commands=0
    if [[ -d "$PROJECT_ROOT/versions/en/commands" ]]; then
        en_commands=$(find "$PROJECT_ROOT/versions/en/commands" -name "*.md" | wc -l)
    fi
    
    for lang in "${LANGUAGES[@]}"; do
        if [[ "$lang" == "en" ]]; then
            continue
        fi
        
        local lang_dir="$PROJECT_ROOT/versions/$lang"
        if [[ ! -d "$lang_dir" ]]; then
            issues+=("Language version missing: $lang")
            continue
        fi
        
        local lang_commands=0
        if [[ -d "$lang_dir/commands" ]]; then
            lang_commands=$(find "$lang_dir/commands" -name "*.md" | wc -l)
        fi
        
        if [[ "$lang_commands" -lt "$en_commands" ]]; then
            issues+=("Language $lang incomplete: $lang_commands/$en_commands commands")
        fi
    done
    
    if [[ ${#issues[@]} -gt 0 ]]; then
        log_error "Release validation failed:"
        for issue in "${issues[@]}"; do
            echo "  ❌ $issue"
        done
        return 1
    fi
    
    log_success "Release validation passed"
    return 0
}

# ============================================================================
# 发布包创建
# ============================================================================

# 创建发布包
create_release_package() {
    local version="$1"
    local package_dir="$RELEASE_DIR/$version"
    
    log_step "Creating release package for $version..."
    
    # 创建发布目录
    mkdir -p "$package_dir"
    
    # 复制核心文件
    cp -r "$PROJECT_ROOT/versions" "$package_dir/"
    cp -r "$PROJECT_ROOT/scripts" "$package_dir/"
    cp -r "$PROJECT_ROOT/assets" "$package_dir/"
    cp -r "$PROJECT_ROOT/utils" "$package_dir/"
    
    # 复制配置文件
    cp "$PROJECT_ROOT/install.sh" "$package_dir/"
    cp "$PROJECT_ROOT/settings.json.template" "$package_dir/"
    cp "$PROJECT_ROOT/settings.json.example" "$package_dir/"
    
    # 复制文档
    cp "$PROJECT_ROOT/README"*.md "$package_dir/" 2>/dev/null || true
    cp "$PROJECT_ROOT/CHANGELOG.md" "$package_dir/" 2>/dev/null || true
    cp "$PROJECT_ROOT/INSTALL"*.md "$package_dir/" 2>/dev/null || true
    
    # 生成版本信息
    cat > "$package_dir/VERSION" << EOF
$version
$(date)
$(git rev-parse HEAD)
EOF
    
    # 生成统计信息
    collect_version_stats "$package_dir/STATS.md"
    
    # 生成发布说明
    generate_release_notes "$version" "$package_dir/RELEASE_NOTES.md"
    
    # 创建压缩包
    (cd "$RELEASE_DIR" && tar -czf "$version.tar.gz" "$version/")
    
    log_success "Release package created: $RELEASE_DIR/$version.tar.gz"
}

# 生成发布说明
generate_release_notes() {
    local version="$1"
    local output_file="$2"
    
    local prev_tag
    prev_tag=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
    
    cat > "$output_file" << EOF
# Claude Code Cookbook $version

## 🌟 Highlights

This release maintains the superior **versions/** architecture while staying synchronized with upstream improvements.

## 🌍 Multi-Language Support

$(for lang in "${LANGUAGES[@]}"; do
    local lang_dir="$PROJECT_ROOT/versions/$lang"
    if [[ -d "$lang_dir" ]]; then
        local commands=$(find "$lang_dir/commands" -name "*.md" 2>/dev/null | wc -l || echo "0")
        local agents=$(find "$lang_dir/agents/roles" -name "*.md" 2>/dev/null | wc -l || echo "0")
        echo "- **$(echo $lang | tr '[:lower:]' '[:upper:]')**: $commands commands, $agents agent roles"
    fi
done)

## 📋 What's New

EOF
    
    if [[ -n "$prev_tag" ]]; then
        echo "### Changes since $prev_tag" >> "$output_file"
        echo "" >> "$output_file"
        git log --oneline "$prev_tag"..HEAD | head -20 | sed 's/^/- /' >> "$output_file"
        echo "" >> "$output_file"
    fi
    
    cat >> "$output_file" << EOF
## 🚀 Installation

\`\`\`bash
# Download and extract
wget https://github.com/foreveryh/claude-code-cookbook/releases/download/$version/$version.tar.gz
tar -xzf $version.tar.gz
cd $version

# Install (choose your language)
./install.sh --lang en    # English
./install.sh --lang zh    # 中文
./install.sh --lang ja    # 日本語
./install.sh --lang fr    # Français
./install.sh --lang ko    # 한국어
\`\`\`

## 🔄 Upgrade from Previous Version

\`\`\`bash
# Backup existing installation
cp -r ~/.claude ~/.claude_backup_\$(date +%Y%m%d)

# Install new version
./install.sh --lang [your_language]
\`\`\`

## 🏗️ Architecture Advantages

- **versions/ Structure**: Cleaner organization than upstream locales/
- **Complete Language Parity**: All languages have identical feature sets
- **Advanced Features**: Includes features ahead of upstream
- **Intelligent Sync**: Maintains compatibility while preserving improvements

## 📊 Statistics

$(cat "$PROJECT_ROOT/STATS.md" 2>/dev/null || echo "Statistics not available")

## 🤝 Contributing

This fork maintains compatibility with upstream while providing enhanced multi-language support and architectural improvements.

---

**Full Changelog**: https://github.com/foreveryh/claude-code-cookbook/compare/$prev_tag...$version
EOF
}

# ============================================================================
# Git 操作
# ============================================================================

# 创建发布标签
create_release_tag() {
    local version="$1"
    local message="$2"
    
    log_step "Creating release tag $version..."
    
    # 创建带注释的标签
    git tag -a "$version" -m "$message"
    
    log_success "Tag $version created"
}

# 推送发布
push_release() {
    local version="$1"
    
    log_step "Pushing release $version..."
    
    # 推送代码和标签
    git push origin main
    git push origin "$version"
    
    log_success "Release $version pushed to origin"
}

# ============================================================================
# 主要命令
# ============================================================================

# 显示帮助
show_help() {
    cat << EOF
Claude Code Cookbook Release Manager

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    prepare VERSION     Prepare a new release
    package VERSION     Create release package
    publish VERSION     Publish release (tag + push)
    validate           Validate release readiness
    stats              Show version statistics
    help               Show this help

OPTIONS:
    --dry-run          Preview actions without executing
    --force            Skip validation checks
    --message MSG      Custom release message

EXAMPLES:
    $0 validate                    # Check if ready for release
    $0 prepare v2.1.0             # Prepare version 2.1.0
    $0 package v2.1.0             # Create release package
    $0 publish v2.1.0             # Publish to Git
    $0 stats                      # Show statistics

WORKFLOW:
    1. $0 validate                # Ensure everything is ready
    2. $0 prepare v2.1.0         # Prepare the release
    3. $0 package v2.1.0         # Create distribution package
    4. $0 publish v2.1.0         # Publish to repository

The release manager maintains the versions/ architecture advantage
while ensuring all language versions are complete and synchronized.
EOF
}

# 主函数
main() {
    local command="${1:-help}"
    local version="${2:-}"
    local dry_run=false
    local force=false
    local message=""
    
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
            --message)
                message="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    case "$command" in
        validate)
            validate_release_readiness
            ;;
        prepare)
            if [[ -z "$version" ]]; then
                log_error "Version required for prepare command"
                exit 1
            fi
            
            validate_version "$version"
            
            if [[ "$force" != true ]]; then
                validate_release_readiness
            fi
            
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would prepare release $version"
                exit 0
            fi
            
            log_info "Preparing release $version..."
            
            # 这里可以添加预发布准备步骤
            # 例如：更新版本号、生成文档等
            
            log_success "Release $version prepared"
            ;;
        package)
            if [[ -z "$version" ]]; then
                log_error "Version required for package command"
                exit 1
            fi
            
            validate_version "$version"
            
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would create package for $version"
                exit 0
            fi
            
            create_release_package "$version"
            ;;
        publish)
            if [[ -z "$version" ]]; then
                log_error "Version required for publish command"
                exit 1
            fi
            
            validate_version "$version"
            
            if [[ "$force" != true ]]; then
                validate_release_readiness
            fi
            
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would publish release $version"
                exit 0
            fi
            
            local release_message="${message:-"Release $version"}"
            
            create_release_tag "$version" "$release_message"
            push_release "$version"
            
            log_success "Release $version published successfully!"
            ;;
        stats)
            local temp_stats="/tmp/claude_stats.md"
            collect_version_stats "$temp_stats"
            cat "$temp_stats"
            rm -f "$temp_stats"
            ;;
        help|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"