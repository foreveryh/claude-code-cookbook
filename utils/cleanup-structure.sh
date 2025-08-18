#!/bin/bash

# Claude Code Cookbook Structure Cleanup Tool
# 项目结构清理工具 - 优化文件组织，与上游保持一致
# Version: 1.0.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

# 分析当前结构
analyze_structure() {
    log_step "Analyzing current project structure..."
    
    echo "📁 Root directory files:"
    ls -la "$PROJECT_ROOT" | grep "^-" | awk '{print $9}' | grep -E "\.(md|json|sh)$" | sort
    
    echo ""
    echo "📊 File count by type:"
    echo "  Markdown files: $(find "$PROJECT_ROOT" -maxdepth 1 -name "*.md" | wc -l)"
    echo "  JSON files: $(find "$PROJECT_ROOT" -maxdepth 1 -name "*.json" | wc -l)"
    echo "  Shell scripts: $(find "$PROJECT_ROOT" -maxdepth 1 -name "*.sh" | wc -l)"
    
    echo ""
    echo "🌍 Language-specific files:"
    ls -la "$PROJECT_ROOT" | grep -E "(Claude_|COMMAND_TEMPLATE_|README_)" | awk '{print $9}' || echo "  None found"
}

# 清理冗余的多语言文件
cleanup_redundant_files() {
    log_step "Cleaning up redundant language-specific files..."
    
    # 这些文件在根目录是冗余的，因为我们有 versions/ 结构
    local files_to_remove=(
        "Claude_fr.md"
        "Claude_ja.md" 
        "Claude_ko.md"
        "Claude_zh.md"
        "COMMAND_TEMPLATE_fr.md"
        "COMMAND_TEMPLATE_ja.md"
        "COMMAND_TEMPLATE_ko.md"
        "COMMAND_TEMPLATE_zh.md"
    )
    
    # 备份到 docs/archive 而不是直接删除
    mkdir -p "$PROJECT_ROOT/docs/archive/root_language_files"
    
    for file in "${files_to_remove[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            log_info "Archiving redundant file: $file"
            mv "$PROJECT_ROOT/$file" "$PROJECT_ROOT/docs/archive/root_language_files/"
        fi
    done
    
    log_success "Redundant files archived to docs/archive/root_language_files/"
}

# 整理文档文件
organize_docs() {
    log_step "Organizing documentation files..."
    
    # 创建 docs 目录（如果不存在）
    mkdir -p "$PROJECT_ROOT/docs/archive"
    
    # 移动项目管理文档
    local pm_docs=(
        "CI_IMPLEMENTATION_SUMMARY.md"
        "DOCS_UPDATE_SUMMARY.md"
        "install_flowchart.md"
        "install_spec.md"
        "install_template.sh"
        "PROJECT_STRUCTURE.md"
        "SETTINGS_README.md"
        "commit_message.txt"
        "test-ci-local.sh"
    )
    
    for doc in "${pm_docs[@]}"; do
        if [[ -f "$PROJECT_ROOT/$doc" ]]; then
            log_info "Moving to docs/archive: $doc"
            mv "$PROJECT_ROOT/$doc" "$PROJECT_ROOT/docs/archive/"
        fi
    done
    
    log_success "Documentation organized"
}

# 同步上游核心文件
sync_core_files() {
    log_step "Syncing core files with upstream..."
    
    # 检查上游远程是否存在
    if ! git remote get-url upstream >/dev/null 2>&1; then
        log_warning "Upstream remote not found. Skipping sync."
        return
    fi
    
    # 获取最新的上游信息
    git fetch upstream main >/dev/null 2>&1 || {
        log_warning "Failed to fetch upstream. Skipping sync."
        return
    }
    
    # 同步 CLAUDE.md (日语原版)
    if git show upstream/main:CLAUDE.md > /dev/null 2>&1; then
        git show upstream/main:CLAUDE.md > "$PROJECT_ROOT/CLAUDE.md"
        log_info "Synced CLAUDE.md (Japanese original)"
    fi
    
    # 同步 COMMAND_TEMPLATE.md (日语原版)
    if git show upstream/main:COMMAND_TEMPLATE.md > /dev/null 2>&1; then
        git show upstream/main:COMMAND_TEMPLATE.md > "$PROJECT_ROOT/COMMAND_TEMPLATE.md"
        log_info "Synced COMMAND_TEMPLATE.md (Japanese original)"
    fi
    
    # 从 locales 同步英语版本作为主要版本
    if git show upstream/main:locales/en/CLAUDE.md > /dev/null 2>&1; then
        git show upstream/main:locales/en/CLAUDE.md > "$PROJECT_ROOT/Claude.md"
        log_info "Synced Claude.md (English version as main)"
    fi
    
    if git show upstream/main:locales/en/COMMAND_TEMPLATE.md > /dev/null 2>&1; then
        git show upstream/main:locales/en/COMMAND_TEMPLATE.md > "$PROJECT_ROOT/COMMAND_TEMPLATE_en.md"
        log_info "Synced COMMAND_TEMPLATE_en.md (English version)"
    fi
    
    # 同步 README 文件
    if git show upstream/main:README_en.md > /dev/null 2>&1; then
        git show upstream/main:README_en.md > "$PROJECT_ROOT/README.md"
        log_info "Synced README.md (English as main)"
    fi
    
    if git show upstream/main:README.md > /dev/null 2>&1; then
        git show upstream/main:README.md > "$PROJECT_ROOT/README_ja.md"
        log_info "Synced README_ja.md (Japanese original)"
    fi
    
    log_success "Core files synchronized with upstream"
}

# 验证结构
validate_structure() {
    log_step "Validating optimized structure..."
    
    local issues=()
    
    # 检查核心文件
    local required_files=("CLAUDE.md" "Claude.md" "COMMAND_TEMPLATE.md" "README.md" "install.sh")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
            issues+=("Missing required file: $file")
        fi
    done
    
    # 检查冗余文件是否已清理
    local should_not_exist=("Claude_ja.md" "Claude_zh.md" "COMMAND_TEMPLATE_ja.md")
    for file in "${should_not_exist[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            issues+=("Redundant file still exists: $file")
        fi
    done
    
    if [[ ${#issues[@]} -gt 0 ]]; then
        log_error "Structure validation failed:"
        for issue in "${issues[@]}"; do
            echo "  ❌ $issue"
        done
        return 1
    fi
    
    log_success "Structure validation passed"
    return 0
}

# 生成结构报告
generate_report() {
    local report_file="$PROJECT_ROOT/STRUCTURE_REPORT.md"
    
    cat > "$report_file" << EOF
# Project Structure Report

Generated: $(date)

## 📁 Optimized Structure

### Root Directory Files
\`\`\`
$(ls -la "$PROJECT_ROOT" | grep "^-" | awk '{print $9}' | grep -E "\.(md|json|sh)$" | sort)
\`\`\`

### Key Changes Made
- ✅ Removed redundant language-specific files from root
- ✅ Synchronized core files with upstream
- ✅ Organized documentation in docs/archive/
- ✅ Maintained versions/ structure advantage

### File Mapping
- **CLAUDE.md**: Japanese original (from upstream)
- **Claude.md**: English version (for compatibility)
- **COMMAND_TEMPLATE.md**: Japanese original (from upstream)
- **COMMAND_TEMPLATE_en.md**: English version
- **versions/**: Complete multi-language structure

### Architecture Benefits
- 🎯 Cleaner root directory
- 🔄 Upstream compatibility
- 🌍 Complete multi-language support in versions/
- 📚 Organized documentation

## 📊 Statistics
- Root .md files: $(find "$PROJECT_ROOT" -maxdepth 1 -name "*.md" | wc -l)
- Language versions: $(ls -d "$PROJECT_ROOT/versions"/*/ 2>/dev/null | wc -l)
- Total commands: $(find "$PROJECT_ROOT/versions/en/commands" -name "*.md" 2>/dev/null | wc -l)

EOF
    
    log_info "Structure report generated: STRUCTURE_REPORT.md"
}

# 显示帮助
show_help() {
    cat << EOF
Claude Code Cookbook Structure Cleanup Tool

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    analyze     Analyze current structure
    cleanup     Clean up redundant files
    organize    Organize documentation
    sync        Sync core files with upstream
    validate    Validate structure
    full        Run complete cleanup (all steps)
    integrate   Full integration with sync architecture
    report      Generate structure report
    help        Show this help

OPTIONS:
    --dry-run   Preview changes without applying
    --force     Skip confirmation prompts

EXAMPLES:
    $0 analyze              # Analyze current structure
    $0 cleanup --dry-run    # Preview cleanup changes
    $0 full                 # Complete optimization
    $0 validate             # Check structure validity

This tool optimizes the project structure while maintaining
the superior versions/ architecture and upstream compatibility.
EOF
}

# 主函数
main() {
    local command="${1:-help}"
    local dry_run=false
    local force=false
    
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
            *)
                shift
                ;;
        esac
    done
    
    case "$command" in
        analyze)
            analyze_structure
            ;;
        cleanup)
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would clean up redundant files"
                return
            fi
            cleanup_redundant_files
            ;;
        organize)
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would organize documentation"
                return
            fi
            organize_docs
            ;;
        sync)
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would sync core files"
                return
            fi
            sync_core_files
            ;;
        validate)
            validate_structure
            ;;
        full)
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would run complete cleanup"
                return
            fi
            
            log_info "Running complete structure optimization..."
            cleanup_redundant_files
            organize_docs
            sync_core_files
            validate_structure
            generate_report
            log_success "Structure optimization completed!"
            ;;
        integrate)
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN - Would integrate with sync tools"
                return
            fi
            
            log_info "Integrating with sync architecture..."
            
            # 运行完整清理
            cleanup_redundant_files
            organize_docs
            sync_core_files
            
            # 调用同步工具进行完整同步
            if [[ -x "$PROJECT_ROOT/utils/sync-upstream.sh" ]]; then
                log_info "Running upstream sync..."
                "$PROJECT_ROOT/utils/sync-upstream.sh" sync
            fi
            
            # 检查翻译状态
            if [[ -x "$PROJECT_ROOT/utils/translate-content.py" ]]; then
                log_info "Checking translation status..."
                python3 "$PROJECT_ROOT/utils/translate-content.py" status
            fi
            
            validate_structure
            generate_report
            log_success "Full integration completed!"
            ;;
        report)
            generate_report
            ;;
        help|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"