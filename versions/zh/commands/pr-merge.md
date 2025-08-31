## PR 合并

在综合质量验证和审批通过后自动合并 Pull Request。

### 用法

```bash
# 在质量门控通过后自动合并
/pr-merge
"验证所有质量门控并自动合并当前 PR"

# 合并指定 PR 并进行验证
/pr-merge --pr 123
"验证并合并 PR #123（所有检查通过后）"

# 模拟运行检查合并准备状态
/pr-merge --dry-run
"检查 PR 是否准备好合并（不实际执行合并）"
```

### 基本示例

```bash
# 完整质量验证和合并
gh pr checks && gh pr view --json reviewDecision
"验证 CI 状态和审批状态，如果所有条件满足则继续合并"

# 带安全检查的条件合并
gh pr view --json isDraft,mergeable,reviewDecision
"在合并前检查草稿状态、合并冲突和审查批准"
```

### 合并前验证清单

#### 1. CI 状态检查
```bash
# 验证所有 CI 检查通过
gh pr checks --required
"确保所有必需的 CI 检查为绿色"
```

#### 2. 审查状态检查
```bash
# 检查审批状态
gh pr view --json reviewDecision,reviews
"验证 PR 已获得必需的审批且无待处理的变更请求"
```

#### 3. 分支状态检查
```bash
# 检查合并冲突
gh pr view --json mergeable,mergeableState
"确保不存在合并冲突"
```

#### 4. 草稿状态检查
```bash
# 确保 PR 不是草稿状态
gh pr view --json isDraft
"确认 PR 已标记为准备审查"
```

### 合并策略

#### 默认：压缩合并
```bash
# 压缩合并（推荐用于功能分支）
gh pr merge --squash --delete-branch
"将所有提交合并为单个提交并删除功能分支"
```

#### 备选：合并提交
```bash
# 创建合并提交（用于发布分支）
gh pr merge --merge --delete-branch
"创建明确的合并提交保留提交历史"
```

#### 备选：变基合并
```bash
# 变基合并（用于线性历史）
gh pr merge --rebase --delete-branch
"在基础分支之上重放提交"
```

### 安全机制

#### 1. 必需条件
- ✅ 所有必需的 CI 检查必须通过
- ✅ 至少有一个代码所有者的审批
- ✅ 没有待处理的变更请求
- ✅ 没有合并冲突
- ✅ PR 必须不是草稿状态
- ✅ 满足分支保护规则

#### 2. 可选质量门控
- ⚠️ 代码覆盖率达到阈值
- ⚠️ 安全扫描通过
- ⚠️ 性能基准测试可接受
- ⚠️ 文档已更新

#### 3. 紧急绕过（仅管理员）
```bash
# 使用管理员权限强制合并（谨慎使用）
/pr-merge --force --admin
"覆盖保护规则（需要管理员权限）"
```

### 执行流程

```bash
#!/bin/bash

# 1. 检测当前 PR
detect_current_pr() {
  local current_branch=$(git branch --show-current)
  gh pr list --head $current_branch --json number --jq '.[0].number'
}

# 2. 综合验证
verify_merge_readiness() {
  local pr_number=$1
  
  # 检查 CI 状态
  local ci_status=$(gh pr checks $pr_number --required --json state --jq '.[] | select(.state != "SUCCESS") | length')
  if [ $ci_status -gt 0 ]; then
    echo "❌ 必需的 CI 检查未通过"
    return 1
  fi
  
  # 检查审查状态
  local review_decision=$(gh pr view $pr_number --json reviewDecision --jq '.reviewDecision')
  if [ "$review_decision" != "APPROVED" ]; then
    echo "❌ PR 未获得审批（状态：$review_decision）"
    return 1
  fi
  
  # 检查草稿状态
  local is_draft=$(gh pr view $pr_number --json isDraft --jq '.isDraft')
  if [ "$is_draft" = "true" ]; then
    echo "❌ PR 仍为草稿状态"
    return 1
  fi
  
  # 检查合并冲突
  local mergeable=$(gh pr view $pr_number --json mergeable --jq '.mergeable')
  if [ "$mergeable" != "MERGEABLE" ]; then
    echo "❌ PR 存在合并冲突"
    return 1
  fi
  
  echo "✅ 所有合并条件已满足"
  return 0
}

# 3. 执行合并
execute_merge() {
  local pr_number=$1
  local strategy=${2:-"squash"}
  
  case $strategy in
    "squash")
      gh pr merge $pr_number --squash --delete-branch
      ;;
    "merge")
      gh pr merge $pr_number --merge --delete-branch
      ;;
    "rebase")
      gh pr merge $pr_number --rebase --delete-branch
      ;;
    *)
      echo "❌ 未知的合并策略：$strategy"
      return 1
      ;;
  esac
  
  echo "✅ PR $pr_number 成功合并"
}

# 主执行函数
main() {
  local pr_number=$(detect_current_pr)
  
  if [ -z "$pr_number" ]; then
    echo "❌ 未找到当前分支的 PR"
    exit 1
  fi
  
  echo "🔍 验证 PR #$pr_number 的合并准备状态"
  
  if verify_merge_readiness $pr_number; then
    if [ "$DRY_RUN" = "true" ]; then
      echo "✅ [模拟运行] PR #$pr_number 准备好合并"
    else
      echo "🚀 开始合并..."
      execute_merge $pr_number $MERGE_STRATEGY
    fi
  else
    echo "❌ PR #$pr_number 尚未准备好合并"
    exit 1
  fi
}
```

### 选项

- `--pr <编号>`: 指定 PR 编号（如未指定则从当前分支自动检测）
- `--strategy <squash|merge|rebase>`: 选择合并策略（默认：squash）
- `--dry-run`: 检查合并准备状态（不实际执行合并）
- `--force`: 覆盖保护规则（仅管理员）
- `--no-delete-branch`: 合并后保留功能分支

### 与现有工作流的集成

```bash
# 完整自动化工作流
/pr-check          # 质量验证
/pr-review         # 综合审查
/pr-feedback       # 处理任何问题
/pr-auto-update    # 更新元数据
/pr-merge          # 准备好后自动合并
```

### 常见用例

#### 1. 功能分支完成
```bash
# 开发完成后
/pr-merge --strategy squash
"将所有功能提交压缩为干净的单个提交"
```

#### 2. 热修复部署
```bash
# 需要立即合并的紧急修复
/pr-merge --strategy merge
"保留确切的提交历史用于审计跟踪"
```

#### 3. 发布分支集成
```bash
# 合并发布分支（保留完整历史）
/pr-merge --strategy merge --no-delete-branch
"集成发布分支同时保留分支供未来参考"
```

### 故障排除

#### 常见问题
1. **PR 未获得审批**：请求代码所有者审查
2. **CI 检查失败**：使用 `/pr-feedback` 分析和修复
3. **合并冲突**：解决冲突并更新分支
4. **草稿状态**：使用 `gh pr ready` 标记为准备审查
5. **缺少分支保护**：联系仓库管理员

#### 错误恢复
```bash
# 如果合并失败，分析问题
gh pr view $PR_NUMBER --json mergeableState,statusCheckRollup
"检查详细的合并状态和 CI 结果"

# 修复问题并重试
/pr-feedback && /pr-merge --dry-run
"解决问题并在重试前验证"
```

### 安全考虑

1. **权限验证**：确保用户具有合并权限
2. **分支保护**：遵守所有配置的保护规则
3. **审计跟踪**：记录所有合并操作及用户归属
4. **回滚计划**：记录合并撤销程序（如需要）

### 注意事项

- **需要 GitHub CLI**：`gh` 必须已认证
- **分支权限**：用户必须对目标分支具有写权限
- **保护规则**：必须满足所有仓库保护规则
- **通知**：团队成员通过 GitHub 的标准合并通知收到通知