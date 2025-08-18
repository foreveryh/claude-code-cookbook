#!/bin/bash

# Claude Code Cookbook Auto Maintenance
# 自动化维护脚本 - 智能检测和处理上游更新
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# 配置和常量
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_ROOT/maintenance.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 维护配置
MAX_COMMITS_AUTO_SYNC=10    # 自动同步的最大提交数
BACKUP_RETENTION_DAYS=30    # 备份保留天数
NOTIFICATION_EMAIL=""       # 通知邮箱 (可选)

# ============================================================================
# 工具函数
# ============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1" | tee -a "$LOG_FILE"
}

log_auto() {
    echo -e "${PURPLE}[AUTO]${NC} $1" | tee -a "$LOG_FILE"
}

# 初始化日志
init_log() {
    echo "=== Auto Maintenance Started at $(date) ===" >> "$LOG_FILE"
}

# 发送通知 (如果配置了邮箱)
send_notification() {
    local subject="$1"
    local message="$2"
    
    if [[ -n "$NOTIFICATION_EMAIL" ]] && command -v mail >/dev/null 2>&1; then
        echo "$message" | mail -s "$subject" "$NOTIFICATION_EMAIL"
        log_info "Notification sent to $NOTIFICATION_EMAIL"
    fi
}

# ============================================================================
# 检测和分析功能
# ============================================================================

# 检测上游更新类型和风险级别
analyze_upstream_changes() {
    log_step "Analyzing upstream changes..."
    
    # 获取新提交数量
    local new_commits
    new_commits=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    
    if [[ "$new_commits" -eq 0 ]]; then
        log_info "No upstream changes detected"
        return 1
    fi
    
    log_info "Found $new_commits new commits from upstream"
    
    # 分析提交类型
    local commits_info
    commits_info=$(git log --oneline HEAD..upstream/main)
    
    # 风险评估
    local risk_level="LOW"
    local auto_sync_safe=true
    
    # 检查高风险关键词
    if echo "$commits_info" | grep -qE "(refactor|restructure|breaking|major)"; then
        risk_level="HIGH"
        auto_sync_safe=false
        log_warning "High-risk changes detected (refactor/restructure/breaking)"
    elif echo "$commits_info" | grep -qE "(feat|add|new)"; then
        risk_level="MEDIUM"
        log_info "Medium-risk changes detected (new features)"
    fi
    
    # 检查提交数量
    if [[ "$new_commits" -gt "$MAX_COMMITS_AUTO_SYNC" ]]; then
        risk_level="HIGH"
        auto_sync_safe=false
        log_warning "Too many commits ($new_commits > $MAX_COMMITS_AUTO_SYNC) for auto-sync"
    fi
    
    # 检查关键文件变更
    local changed_files
    changed_files=$(git diff --name-only HEAD..upstream/main)
    
    if echo "$changed_files" | grep -qE "(install\.sh|settings\.json\.template)"; then
        risk_level="HIGH"
        auto_sync_safe=false
        log_warning "Critical files changed (install.sh or settings template)"
    fi
    
    # 输出分析结果
    echo "COMMITS:$new_commits"
    echo "RISK:$risk_level"
    echo "AUTO_SAFE:$auto_sync_safe"
    
    # 显示最近的提交
    log_info "Recent upstream changes:"
    echo "$commits_info" | head -5 | while read -r line; do
        log_info "  $line"
    done
    
    return 0
}

# 检查项目健康状态
check_project_health() {
    log_step "Checking project health..."
    
    local issues=()
    
    # 检查工作目录
    if ! git diff --quiet; then
        issues+=("Working directory has uncommitted changes")
    fi
    
    # 检查版本完整性
    local en_commands=0
    if [[ -d "$PROJECT_ROOT/versions/en/commands" ]]; then
        en_commands=$(find "$PROJECT_ROOT/versions/en/commands" -name "*.md" | wc -l)
    fi
    
    for lang in zh ja; do
        local lang_commands=0
        if [[ -d "$PROJECT_ROOT/versions/$lang/commands" ]]; then
            lang_commands=$(find "$PROJECT_ROOT/versions/$lang/commands" -name "*.md" | wc -l)
        fi
        
        if [[ "$lang_commands" -lt "$en_commands" ]]; then
            issues+=("Language $lang incomplete: $lang_commands/$en_commands commands")
        fi
    done
    
    # 检查关键工具
    local tools=("$PROJECT_ROOT/utils/sync-upstream.sh" "$PROJECT_ROOT/utils/workflow-manager.sh")
    for tool in "${tools[@]}"; do
        if [[ ! -x "$tool" ]]; then
            issues+=("Tool not executable: $(basename "$tool")")
        fi
    done
    
    if [[ ${#issues[@]} -gt 0 ]]; then
        log_warning "Project health issues detected:"
        for issue in "${issues[@]}"; do
            log_warning "  - $issue"
        done
        return 1
    fi
    
    log_success "Project health check passed"
    return 0
}

# ============================================================================
# 备份和恢复功能
# ============================================================================

# 创建备份
create_backup() {
    log_step "Creating backup..."
    
    local backup_tag="auto-backup-$(date +%Y%m%d-%H%M%S)"
    
    # 创建 Git 标签备份
    git tag "$backup_tag" -m "Auto backup before upstream sync"
    log_success "Git backup created: $backup_tag"
    
    # 备份 Claude 安装
    if [[ -d "$HOME/.claude" ]]; then
        local claude_backup="$HOME/.claude_backup_$(date +%Y%m%d-%H%M%S)"
        cp -r "$HOME/.claude" "$claude_backup"
        log_success "Claude installation backed up: $claude_backup"
    fi
    
    echo "$backup_tag"
}

# 清理旧备份
cleanup_old_backups() {
    log_step "Cleaning up old backups..."
    
    # 清理旧的 Git 标签
    local old_tags
    old_tags=$(git tag -l "auto-backup-*" | head -n -5)  # 保留最新5个
    
    if [[ -n "$old_tags" ]]; then
        echo "$old_tags" | while read -r tag; do
            git tag -d "$tag"
            log_info "Removed old backup tag: $tag"
        done
    fi
    
    # 清理旧的 Claude 备份
    find "$HOME" -maxdepth 1 -name ".claude_backup_*" -type d -mtime +$BACKUP_RETENTION_DAYS -exec rm -rf {} \; 2>/dev/null || true
    
    log_success "Old backups cleaned up"
}

# ============================================================================
# 自动化同步功能
# ============================================================================

# 执行自动同步
perform_auto_sync() {
    local risk_level="$1"
    local backup_tag="$2"
    
    log_auto "Performing automatic synchronization..."
    
    case "$risk_level" in
        "LOW")
            log_auto "Low-risk sync: Full automatic synchronization"
            "$PROJECT_ROOT/utils/workflow-manager.sh" sync
            ;;
        "MEDIUM")
            log_auto "Medium-risk sync: Sync with validation"
            "$PROJECT_ROOT/utils/workflow-manager.sh" sync
            
            # 额外验证
            if ! "$PROJECT_ROOT/install.sh" --lang en --dry-run >/dev/null 2>&1; then
                log_error "Installation test failed, rolling back..."
                git reset --hard "$backup_tag"
                return 1
            fi
            ;;
        "HIGH")
            log_auto "High-risk changes detected: Manual intervention required"
            send_notification "Claude Code Cookbook: Manual Sync Required" \
                "High-risk upstream changes detected. Please run manual sync."
            return 1
            ;;
    esac
    
    return 0
}

# 验证同步结果
validate_sync_result() {
    log_step "Validating synchronization result..."
    
    # 测试安装器
    if ! "$PROJECT_ROOT/install.sh" --lang en --dry-run >/dev/null 2>&1; then
        log_error "Installation test failed"
        return 1
    fi
    
    # 检查翻译状态
    local translation_status
    translation_status=$(python3 "$PROJECT_ROOT/utils/translate-content.py" validate 2>&1 || echo "FAILED")
    
    if echo "$translation_status" | grep -q "FAILED"; then
        log_warning "Translation validation issues detected"
        # 不算作失败，只是警告
    fi
    
    # 检查关键文件
    local key_files=("scripts/statusline.sh" "versions/en/commands" "versions/zh/commands")
    for file in "${key_files[@]}"; do
        if [[ ! -e "$PROJECT_ROOT/$file" ]]; then
            log_error "Key file/directory missing: $file"
            return 1
        fi
    done
    
    log_success "Synchronization validation passed"
    return 0
}

# ============================================================================
# 报告和通知功能
# ============================================================================

# 生成维护报告
generate_maintenance_report() {
    local sync_performed="$1"
    local sync_result="$2"
    
    local report_file="$PROJECT_ROOT/maintenance_report_$(date +%Y%m%d).md"
    
    cat > "$report_file" << EOF
# Auto Maintenance Report

**Date**: $(date)
**Sync Performed**: $sync_performed
**Sync Result**: $sync_result

## Project Status

### Statistics
- English Commands: $(find "$PROJECT_ROOT/versions/en/commands" -name "*.md" 2>/dev/null | wc -l)
- Chinese Commands: $(find "$PROJECT_ROOT/versions/zh/commands" -name "*.md" 2>/dev/null | wc -l)
- Japanese Commands: $(find "$PROJECT_ROOT/versions/ja/commands" -name "*.md" 2>/dev/null | wc -l)
- Scripts: $(find "$PROJECT_ROOT/scripts" -name "*.sh" 2>/dev/null | wc -l)

### Health Check
$(check_project_health 2>&1 || echo "Issues detected - see log for details")

### Recent Log
\`\`\`
$(tail -20 "$LOG_FILE")
\`\`\`

---
Generated by Auto Maintenance System
EOF
    
    log_info "Maintenance report generated: $report_file"
}

# ============================================================================
# 主要功能
# ============================================================================

# 显示帮助
show_help() {
    cat << EOF
Claude Code Cookbook Auto Maintenance

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    run         Run automatic maintenance (default)
    check       Check for updates without syncing
    force       Force sync regardless of risk level
    status      Show current project status
    cleanup     Clean up old backups
    help        Show this help

OPTIONS:
    --dry-run   Preview mode, no actual changes
    --quiet     Suppress non-essential output
    --email     Set notification email

EXAMPLES:
    $0                          # Run auto maintenance
    $0 check                    # Check for updates only
    $0 force --dry-run          # Preview forced sync
    $0 --email user@example.com # Set notification email

AUTOMATION:
    Add to crontab for regular maintenance:
    0 9 * * 1 cd /path/to/project && ./utils/auto-maintenance.sh

The auto maintenance system intelligently handles upstream updates
while preserving your superior versions/ architecture.
EOF
}

# 主函数
main() {
    local command="${1:-run}"
    local dry_run=false
    local quiet=false
    local force_sync=false
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run=true
                shift
                ;;
            --quiet)
                quiet=true
                shift
                ;;
            --email)
                NOTIFICATION_EMAIL="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # 初始化
    init_log
    
    if [[ "$quiet" != true ]]; then
        log_auto "Starting automatic maintenance..."
    fi
    
    case "$command" in
        run)
            # 检查项目健康状态
            if ! check_project_health; then
                log_error "Project health check failed. Please fix issues before syncing."
                exit 1
            fi
            
            # 获取上游更新
            git fetch upstream main >/dev/null 2>&1 || {
                log_error "Failed to fetch upstream"
                exit 1
            }
            
            # 分析上游变更
            local analysis_result
            if ! analysis_result=$(analyze_upstream_changes); then
                log_info "No maintenance needed"
                exit 0
            fi
            
            # 解析分析结果
            local commits risk_level auto_safe
            commits=$(echo "$analysis_result" | grep "COMMITS:" | cut -d: -f2)
            risk_level=$(echo "$analysis_result" | grep "RISK:" | cut -d: -f2)
            auto_safe=$(echo "$analysis_result" | grep "AUTO_SAFE:" | cut -d: -f2)
            
            if [[ "$dry_run" == true ]]; then
                log_info "DRY RUN: Would sync $commits commits (Risk: $risk_level, Auto-safe: $auto_safe)"
                exit 0
            fi
            
            # 创建备份
            local backup_tag
            backup_tag=$(create_backup)
            
            # 执行同步
            local sync_result="SUCCESS"
            if [[ "$auto_safe" == "true" ]] || [[ "$force_sync" == true ]]; then
                if perform_auto_sync "$risk_level" "$backup_tag"; then
                    if validate_sync_result; then
                        log_success "Automatic maintenance completed successfully"
                        send_notification "Claude Code Cookbook: Auto Sync Success" \
                            "Successfully synced $commits commits from upstream"
                    else
                        sync_result="VALIDATION_FAILED"
                        log_error "Sync validation failed, rolling back..."
                        git reset --hard "$backup_tag"
                    fi
                else
                    sync_result="SYNC_FAILED"
                    log_error "Automatic sync failed"
                fi
            else
                sync_result="MANUAL_REQUIRED"
                log_warning "Manual intervention required for high-risk changes"
                send_notification "Claude Code Cookbook: Manual Sync Required" \
                    "High-risk upstream changes detected ($commits commits). Please run manual sync."
            fi
            
            # 清理旧备份
            cleanup_old_backups
            
            # 生成报告
            generate_maintenance_report "true" "$sync_result"
            ;;
        check)
            git fetch upstream main >/dev/null 2>&1
            analyze_upstream_changes || log_info "No updates available"
            ;;
        force)
            force_sync=true
            main run "$@"
            ;;
        status)
            check_project_health
            python3 "$PROJECT_ROOT/utils/translate-content.py" status
            ;;
        cleanup)
            cleanup_old_backups
            ;;
        help|*)
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"