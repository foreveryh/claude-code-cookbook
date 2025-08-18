#!/bin/bash

# Claude Code Cookbook Workflow Manager
# 工作流程管理器 - 统一管理同步、清理、翻译和发布流程
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# 配置和常量
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 工具路径
SYNC_TOOL="$SCRIPT_DIR/sync-upstream.sh"
TRANSLATE_TOOL="$SCRIPT_DIR/translate-content.py"
RELEASE_TOOL="$SCRIPT_DIR/release-manager.sh"
CLEANUP_TOOL="$SCRIPT_DIR/cleanup-structure.sh"

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

log_workflow() {
    echo -e "${PURPLE}[WORKFLOW]${NC} $1"
}

# 显示横幅
show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                Claude Code Cookbook Workflow Manager           ║"
    echo "║                     统一工作流程管理系统                        ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 检查工具可用性
check_tools() {
    local missing_tools=()
    
    if [[ ! -x "$SYNC_TOOL" ]]; then
        missing_tools+=("sync-upstream.sh")
    fi
    
    if [[ ! -x "$TRANSLATE_TOOL" ]]; then
        missing_tools+=("translate-content.py")
    fi
    
    if [[ ! -x "$RELEASE_TOOL" ]]; then
        missing_tools+=("release-manager.sh")
    fi
    
    if [[ ! -x "$CLEANUP_TOOL" ]]; then
        missing_tools+=("cleanup-structure.sh")
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing or non-executable tools: ${missing_tools[*]}"
        log_info "Please ensure all tools are present and executable"
        return 1
    fi
    
    return 0
}

# ============================================================================
# 工作流程定义
# ============================================================================

# 完整同步工作流程
workflow_full_sync() {
    local dry_run="$1"
    
    log_workflow "Starting full synchronization workflow..."
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    # 步骤 1: 检查上游更新
    log_step "1/6 Checking upstream changes..."
    if [[ "$dry_run" == "true" ]]; then
        "$SYNC_TOOL" check || return 1
    else
        "$SYNC_TOOL" check || return 1
    fi
    echo ""
    
    # 步骤 2: 清理项目结构
    log_step "2/6 Cleaning up project structure..."
    if [[ "$dry_run" == "true" ]]; then
        "$CLEANUP_TOOL" full --dry-run
    else
        "$CLEANUP_TOOL" full
    fi
    echo ""
    
    # 步骤 3: 同步上游内容
    log_step "3/6 Synchronizing with upstream..."
    if [[ "$dry_run" == "true" ]]; then
        "$SYNC_TOOL" sync --dry-run
    else
        "$SYNC_TOOL" sync
    fi
    echo ""
    
    # 步骤 4: 检查翻译状态
    log_step "4/6 Checking translation status..."
    python3 "$TRANSLATE_TOOL" status
    echo ""
    
    # 步骤 5: 验证完整性
    log_step "5/6 Validating project completeness..."
    python3 "$TRANSLATE_TOOL" validate
    echo ""
    
    # 步骤 6: 测试安装
    log_step "6/6 Testing installation..."
    if [[ "$dry_run" == "true" ]]; then
        log_info "Would test installation with: ./install.sh --lang en --dry-run"
    else
        "$PROJECT_ROOT/install.sh" --lang en --dry-run
    fi
    echo ""
    
    log_success "Full synchronization workflow completed!"
}

# 翻译工作流程
workflow_translation() {
    local target_lang="$1"
    local dry_run="$2"
    
    log_workflow "Starting translation workflow for: $target_lang"
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No changes will be made"
    fi
    
    # 步骤 1: 扫描翻译需求
    log_step "1/3 Scanning translation requirements..."
    python3 "$TRANSLATE_TOOL" scan
    echo ""
    
    # 步骤 2: 执行翻译
    log_step "2/3 Processing translations..."
    if [[ "$dry_run" == "true" ]]; then
        log_info "Would translate content for: $target_lang"
    else
        python3 "$TRANSLATE_TOOL" translate --lang "$target_lang"
    fi
    echo ""
    
    # 步骤 3: 验证结果
    log_step "3/3 Validating translation results..."
    python3 "$TRANSLATE_TOOL" validate
    echo ""
    
    log_success "Translation workflow completed for: $target_lang"
}

# 发布工作流程
workflow_release() {
    local version="$1"
    local dry_run="$2"
    
    log_workflow "Starting release workflow for: $version"
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No changes will be made"
    fi
    
    # 步骤 1: 验证发布准备
    log_step "1/4 Validating release readiness..."
    "$RELEASE_TOOL" validate
    echo ""
    
    # 步骤 2: 准备发布
    log_step "2/4 Preparing release..."
    if [[ "$dry_run" == "true" ]]; then
        "$RELEASE_TOOL" prepare "$version" --dry-run
    else
        "$RELEASE_TOOL" prepare "$version"
    fi
    echo ""
    
    # 步骤 3: 创建发布包
    log_step "3/4 Creating release package..."
    if [[ "$dry_run" == "true" ]]; then
        "$RELEASE_TOOL" package "$version" --dry-run
    else
        "$RELEASE_TOOL" package "$version"
    fi
    echo ""
    
    # 步骤 4: 发布
    log_step "4/4 Publishing release..."
    if [[ "$dry_run" == "true" ]]; then
        "$RELEASE_TOOL" publish "$version" --dry-run
    else
        "$RELEASE_TOOL" publish "$version"
    fi
    echo ""
    
    log_success "Release workflow completed for: $version"
}

# 维护工作流程
workflow_maintenance() {
    local dry_run="$1"
    
    log_workflow "Starting maintenance workflow..."
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "🔍 DRY RUN MODE - No changes will be made"
    fi
    
    # 步骤 1: 分析项目状态
    log_step "1/5 Analyzing project status..."
    "$CLEANUP_TOOL" analyze
    echo ""
    
    # 步骤 2: 检查上游更新
    log_step "2/5 Checking for upstream updates..."
    "$SYNC_TOOL" check
    echo ""
    
    # 步骤 3: 检查翻译状态
    log_step "3/5 Checking translation status..."
    python3 "$TRANSLATE_TOOL" status
    echo ""
    
    # 步骤 4: 验证项目完整性
    log_step "4/5 Validating project integrity..."
    python3 "$TRANSLATE_TOOL" validate
    "$CLEANUP_TOOL" validate
    echo ""
    
    # 步骤 5: 生成报告
    log_step "5/5 Generating maintenance report..."
    "$RELEASE_TOOL" stats
    "$CLEANUP_TOOL" report
    echo ""
    
    log_success "Maintenance workflow completed!"
}

# ============================================================================
# 交互式菜单
# ============================================================================

show_interactive_menu() {
    while true; do
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${CYAN}                    选择工作流程                                ${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "1) 🔄 完整同步工作流程 (Full Sync)"
        echo "2) 🌍 翻译工作流程 (Translation)"
        echo "3) 🚀 发布工作流程 (Release)"
        echo "4) 🔧 维护工作流程 (Maintenance)"
        echo "5) 📊 项目状态概览 (Status Overview)"
        echo "6) ❌ 退出 (Exit)"
        echo ""
        echo -n "请选择 (1-6): "
        
        read -r choice
        
        case $choice in
            1)
                echo ""
                echo -n "是否预览模式? (y/N): "
                read -r preview
                local dry_run="false"
                [[ "$preview" =~ ^[Yy]$ ]] && dry_run="true"
                
                workflow_full_sync "$dry_run"
                ;;
            2)
                echo ""
                echo -n "目标语言 (zh/ja/fr/ko): "
                read -r lang
                echo -n "是否预览模式? (y/N): "
                read -r preview
                local dry_run="false"
                [[ "$preview" =~ ^[Yy]$ ]] && dry_run="true"
                
                workflow_translation "$lang" "$dry_run"
                ;;
            3)
                echo ""
                echo -n "版本号 (例: v2.1.0): "
                read -r version
                echo -n "是否预览模式? (y/N): "
                read -r preview
                local dry_run="false"
                [[ "$preview" =~ ^[Yy]$ ]] && dry_run="true"
                
                workflow_release "$version" "$dry_run"
                ;;
            4)
                echo ""
                echo -n "是否预览模式? (y/N): "
                read -r preview
                local dry_run="false"
                [[ "$preview" =~ ^[Yy]$ ]] && dry_run="true"
                
                workflow_maintenance "$dry_run"
                ;;
            5)
                echo ""
                log_info "项目状态概览:"
                "$CLEANUP_TOOL" analyze
                echo ""
                python3 "$TRANSLATE_TOOL" status
                echo ""
                "$RELEASE_TOOL" stats
                ;;
            6)
                log_info "退出工作流程管理器"
                exit 0
                ;;
            *)
                log_error "无效选择，请重试"
                ;;
        esac
        
        echo ""
        echo -n "按 Enter 继续..."
        read -r
    done
}

# ============================================================================
# 帮助和主函数
# ============================================================================

show_help() {
    cat << EOF
Claude Code Cookbook Workflow Manager

USAGE:
    $0 [WORKFLOW] [OPTIONS]

WORKFLOWS:
    sync                Full synchronization workflow
    translate LANG      Translation workflow for specific language
    release VERSION     Release workflow for version
    maintenance         Maintenance and health check workflow
    interactive         Interactive menu mode
    status              Show project status overview
    help                Show this help

OPTIONS:
    --dry-run          Preview mode, no actual changes
    --force            Skip confirmation prompts

EXAMPLES:
    $0 interactive                    # Interactive menu
    $0 sync --dry-run                # Preview full sync
    $0 translate zh                  # Translate to Chinese
    $0 release v2.1.0 --dry-run     # Preview release
    $0 maintenance                   # Run maintenance checks
    $0 status                        # Show status overview

WORKFLOW DESCRIPTIONS:
    sync        - Check upstream, cleanup, sync, validate
    translate   - Scan, translate, validate for specific language
    release     - Validate, prepare, package, publish
    maintenance - Analyze, check, validate, report

This unified workflow manager orchestrates all sync tools
to maintain your superior versions/ architecture while
staying synchronized with upstream improvements.
EOF
}

# 主函数
main() {
    show_banner
    
    # 检查工具可用性
    if ! check_tools; then
        exit 1
    fi
    
    local workflow="${1:-interactive}"
    local dry_run="false"
    local force="false"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run="true"
                shift
                ;;
            --force)
                force="true"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    case "$workflow" in
        sync)
            workflow_full_sync "$dry_run"
            ;;
        translate)
            local lang="${2:-}"
            if [[ -z "$lang" ]]; then
                log_error "Language required for translate workflow"
                log_info "Usage: $0 translate <lang>"
                exit 1
            fi
            workflow_translation "$lang" "$dry_run"
            ;;
        release)
            local version="${2:-}"
            if [[ -z "$version" ]]; then
                log_error "Version required for release workflow"
                log_info "Usage: $0 release <version>"
                exit 1
            fi
            workflow_release "$version" "$dry_run"
            ;;
        maintenance)
            workflow_maintenance "$dry_run"
            ;;
        status)
            log_info "项目状态概览:"
            "$CLEANUP_TOOL" analyze
            echo ""
            python3 "$TRANSLATE_TOOL" status
            echo ""
            "$RELEASE_TOOL" stats
            ;;
        interactive)
            show_interactive_menu
            ;;
        help|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"