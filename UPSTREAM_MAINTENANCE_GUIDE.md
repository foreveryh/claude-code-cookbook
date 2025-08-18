# 🔄 上游更新维护指南

## 📋 **维护策略概览**

当上游 `wasabeef/claude-code-cookbook` 有更新时，你需要按照以下策略进行维护，以保持你的项目既能获得最新功能，又能保持架构优势。

## 🕐 **维护频率建议**

### **每周检查** (推荐)
```bash
# 快速检查是否有上游更新
./utils/sync-upstream.sh check
```

### **每月同步** (必须)
```bash
# 完整同步工作流程
./utils/workflow-manager.sh sync
```

### **重大更新时** (按需)
```bash
# 完整维护工作流程
./utils/workflow-manager.sh maintenance
```

## 🔄 **标准维护流程**

### **步骤 1: 检查上游更新**

```bash
# 方法 1: 使用统一管理器 (推荐)
./utils/workflow-manager.sh status

# 方法 2: 直接检查
./utils/sync-upstream.sh check
```

**输出示例**：
```
[INFO] Found 15 new commits from upstream
[INFO] Recent upstream changes:
abc1234 feat: add new command /analyze-security
def5678 fix: improve statusline performance
ghi9012 docs: update installation guide
```

### **步骤 2: 评估更新影响**

根据上游更新类型，选择合适的维护策略：

#### **🟢 低风险更新** (文档、小修复)
```bash
# 直接同步
./utils/workflow-manager.sh sync
```

#### **🟡 中等风险更新** (新功能、脚本改进)
```bash
# 预览模式先检查
./utils/workflow-manager.sh sync --dry-run

# 确认无问题后执行
./utils/workflow-manager.sh sync
```

#### **🔴 高风险更新** (架构变更、重大重构)
```bash
# 完整维护流程
./utils/workflow-manager.sh maintenance --dry-run

# 手动检查关键差异
git diff upstream/main HEAD -- install.sh
git diff upstream/main HEAD -- scripts/

# 谨慎执行
./utils/workflow-manager.sh maintenance
```

### **步骤 3: 执行同步**

```bash
# 🎯 推荐：使用统一工作流程
./utils/workflow-manager.sh sync

# 这个命令会自动执行：
# 1. 检查上游更新
# 2. 清理项目结构  
# 3. 同步新内容到 versions/ 结构
# 4. 保持你的先进功能
# 5. 验证多语言完整性
# 6. 测试安装器
```

### **步骤 4: 验证同步结果**

```bash
# 检查关键指标
./utils/workflow-manager.sh status

# 验证安装器
./install.sh --lang en --dry-run

# 检查新功能
ls -la scripts/
ls -la versions/en/commands/ | wc -l
```

### **步骤 5: 处理翻译更新**

```bash
# 检查翻译需求
python3 utils/translate-content.py scan

# 翻译新内容 (如果有)
python3 utils/translate-content.py translate --lang zh
python3 utils/translate-content.py translate --lang ja

# 验证完整性
python3 utils/translate-content.py validate
```

## 🎯 **不同更新场景的处理**

### **场景 1: 上游添加新命令**

**检测**：
```bash
./utils/sync-upstream.sh check
# 输出显示新的 commands/ 文件
```

**处理**：
```bash
# 1. 同步新命令到所有版本
./utils/workflow-manager.sh sync

# 2. 检查翻译需求
python3 utils/translate-content.py scan

# 3. 翻译新命令
./utils/workflow-manager.sh translate zh
./utils/workflow-manager.sh translate ja

# 4. 验证结果
python3 utils/translate-content.py validate
```

### **场景 2: 上游优化脚本**

**检测**：
```bash
git diff upstream/main HEAD -- scripts/
```

**处理**：
```bash
# 1. 同步脚本改进
./utils/sync-upstream.sh sync

# 2. 脚本会自动分发到所有 versions/*/scripts/
# 3. 测试关键脚本
./scripts/statusline.sh
./scripts/deny-check.sh
```

### **场景 3: 上游架构调整**

**检测**：
```bash
git log --oneline upstream/main | grep -E "(refactor|restructure|move)"
```

**处理**：
```bash
# 1. 谨慎评估影响
./utils/workflow-manager.sh maintenance --dry-run

# 2. 备份当前状态
git tag backup-before-sync-$(date +%Y%m%d)

# 3. 执行维护
./utils/workflow-manager.sh maintenance

# 4. 如有问题，可回滚
# git reset --hard backup-before-sync-YYYYMMDD
```

### **场景 4: 上游添加新语言支持**

**检测**：
```bash
git ls-tree -r upstream/main | grep "locales/" | cut -d'/' -f2 | sort -u
```

**处理**：
```bash
# 1. 同步新语言内容
./utils/sync-upstream.sh sync

# 2. 如果上游添加了新语言 (如德语 de)
mkdir -p versions/de/{commands,agents/roles,scripts,hooks}

# 3. 从上游同步德语内容
git ls-tree -r upstream/main | grep "locales/de/" | while read line; do
  file=$(echo "$line" | awk '{print $4}')
  target=$(echo "$file" | sed 's|locales/de/|versions/de/|')
  git show "upstream/main:$file" > "$target"
done

# 4. 更新安装器支持新语言
# 编辑 install.sh 中的 SUPPORTED_LANGUAGES
```

## 🛡️ **风险控制策略**

### **备份策略**

```bash
# 同步前创建备份标签
git tag backup-$(date +%Y%m%d-%H%M) -m "Backup before upstream sync"

# 备份关键配置
cp -r ~/.claude ~/.claude_backup_$(date +%Y%m%d)
```

### **回滚策略**

```bash
# 如果同步出现问题，快速回滚
git reset --hard backup-YYYYMMDD-HHMM

# 恢复安装
./install.sh --lang en
```

### **测试策略**

```bash
# 同步后必须测试
./install.sh --lang en --dry-run    # 测试安装器
./install.sh --lang zh --dry-run    # 测试中文版本
./install.sh --lang ja --dry-run    # 测试日语版本

# 验证关键功能
ls ~/.claude/scripts/statusline.sh  # 新脚本存在
wc -l ~/.claude/commands/*.md       # 命令数量正确
```

## 📊 **维护检查清单**

### **同步前检查**
- [ ] 工作目录干净 (`git status`)
- [ ] 已备份重要更改
- [ ] 上游远程配置正确
- [ ] 工具权限正确 (`chmod +x utils/*.sh`)

### **同步后验证**
- [ ] 新功能已获取 (检查 scripts/, commands/)
- [ ] 版本结构完整 (所有语言版本功能对等)
- [ ] 安装器正常工作
- [ ] 先进功能保持 (pr-create-smart 等)
- [ ] 翻译状态良好

### **发布前确认**
- [ ] 所有语言版本完整
- [ ] 文档已更新
- [ ] 测试通过
- [ ] 版本号已更新

## 🚨 **常见问题处理**

### **问题 1: 合并冲突**

```bash
# 如果出现合并冲突
git status
git diff

# 解决冲突后
git add .
git commit -m "Resolve merge conflicts from upstream sync"
```

### **问题 2: 翻译不完整**

```bash
# 检查缺失的翻译
python3 utils/translate-content.py scan

# 补充翻译
./utils/workflow-manager.sh translate ja
```

### **问题 3: 安装器失败**

```bash
# 检查安装器配置
./install.sh --lang en --dry-run

# 检查 versions/ 结构
ls -la versions/en/
```

### **问题 4: 新功能缺失**

```bash
# 强制重新同步
./utils/sync-upstream.sh sync --force

# 检查同步结果
./utils/workflow-manager.sh status
```

## 🔄 **自动化维护 (高级)**

### **设置定期检查**

创建 cron 任务：
```bash
# 编辑 crontab
crontab -e

# 添加每周检查
0 9 * * 1 cd /path/to/claude-code-cookbook && ./utils/sync-upstream.sh check > /tmp/upstream-check.log 2>&1
```

### **GitHub Actions 集成**

创建 `.github/workflows/upstream-sync.yml`：
```yaml
name: Upstream Sync Check
on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一上午9点
  workflow_dispatch:

jobs:
  check-upstream:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check upstream updates
        run: |
          git remote add upstream https://github.com/wasabeef/claude-code-cookbook.git
          ./utils/sync-upstream.sh check
```

## 🎯 **最佳实践总结**

### **DO ✅**
- 定期检查上游更新 (每周)
- 使用统一工作流程管理器
- 同步前备份重要状态
- 验证同步结果
- 保持翻译完整性

### **DON'T ❌**
- 不要忽略上游更新太久
- 不要跳过验证步骤
- 不要在工作目录不干净时同步
- 不要忘记测试安装器
- 不要丢失你的先进功能

---

## 🚀 **快速维护命令**

```bash
# 🎯 日常维护 (推荐)
./utils/workflow-manager.sh sync

# 🔍 检查状态
./utils/workflow-manager.sh status

# 🔧 完整维护
./utils/workflow-manager.sh maintenance

# 🌍 翻译更新
./utils/workflow-manager.sh translate zh
```

**记住：你的 versions/ 架构是优势，同步工具会自动保持这个优势！** 🎉