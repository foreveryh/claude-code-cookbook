# 🚀 Claude Code Cookbook 同步快速开始

## 📋 **立即开始同步**

### **1. 检查当前状态**

```bash
# 检查上游更新
./utils/sync-upstream.sh check

# 查看翻译状态
python3 utils/translate-content.py status

# 验证发布准备
./utils/release-manager.sh validate
```

### **2. 执行完整同步**

```bash
# 🔄 同步上游所有更新
./utils/sync-upstream.sh sync

# ✅ 验证同步结果
python3 utils/translate-content.py status
```

### **3. 测试新功能**

```bash
# 重新安装验证
./install.sh --lang en

# 检查新脚本
ls -la ~/.claude/scripts/statusline.sh
```

## 🎯 **常用命令速查**

### **同步命令**

```bash
# 检查更新（无副作用）
./utils/sync-upstream.sh check

# 完整同步
./utils/sync-upstream.sh sync

# 预览同步（不实际修改）
./utils/sync-upstream.sh sync --dry-run

# 同步特定语言
./utils/sync-upstream.sh sync --lang zh
```

### **翻译命令**

```bash
# 查看状态
python3 utils/translate-content.py status

# 扫描需要翻译的内容
python3 utils/translate-content.py scan

# 翻译特定语言
python3 utils/translate-content.py translate --lang ja

# 验证完整性
python3 utils/translate-content.py validate
```

### **发布命令**

```bash
# 验证准备
./utils/release-manager.sh validate

# 查看统计
./utils/release-manager.sh stats

# 准备发布
./utils/release-manager.sh prepare v2.1.0

# 创建包
./utils/release-manager.sh package v2.1.0

# 发布
./utils/release-manager.sh publish v2.1.0
```

## 🔧 **解决常见问题**

### **问题 1：工作目录有未提交更改**

```bash
# 查看更改
git status

# 提交更改
git add .
git commit -m "Sync upstream updates"

# 或者暂存更改
git stash
# 执行同步后
git stash pop
```

### **问题 2：翻译不完整**

```bash
# 查看具体缺失
python3 utils/translate-content.py scan

# 翻译特定语言
python3 utils/translate-content.py translate --lang fr

# 手动补充翻译后验证
python3 utils/translate-content.py validate
```

### **问题 3：上游远程未配置**

```bash
# 添加上游远程
git remote add upstream https://github.com/wasabeef/claude-code-cookbook.git

# 验证配置
git remote -v
```

## 📊 **同步效果验证**

### **验证清单**

- [ ] ✅ statusline.sh 脚本已添加
- [ ] ✅ deny-check.sh 脚本已优化
- [ ] ✅ 所有语言版本功能对等
- [ ] ✅ 根目录文件与上游同步
- [ ] ✅ 安装器正常工作

### **验证命令**

```bash
# 检查新脚本
ls -la scripts/statusline.sh versions/*/scripts/statusline.sh

# 检查命令数量
find versions/en/commands -name "*.md" | wc -l
find versions/zh/commands -name "*.md" | wc -l

# 测试安装
./install.sh --lang en --dry-run
```

## 🌟 **架构优势确认**

### **你的项目 vs 上游**

| 特性 | 上游 | 你的项目 | 状态 |
|------|------|----------|------|
| 结构清晰度 | locales/ | versions/ | ✅ 优势保持 |
| 多语言完整性 | 部分 | 完整 | ✅ 优势保持 |
| 先进功能 | 基础 | 增强 | ✅ 优势保持 |
| 状态栏支持 | ✅ | ✅ | ✅ 已同步 |
| 脚本优化 | ✅ | ✅ | ✅ 已同步 |

## 🔄 **定期维护计划**

### **每周**
```bash
./utils/sync-upstream.sh check
```

### **每月**
```bash
./utils/sync-upstream.sh sync
python3 utils/translate-content.py status
```

### **发布前**
```bash
./utils/release-manager.sh validate
./utils/release-manager.sh stats
```

## 🎉 **成功指标**

同步成功的标志：

1. ✅ **功能同步**：获得上游所有新功能
2. ✅ **架构保持**：versions/ 结构完整
3. ✅ **先进性维持**：独有功能未丢失
4. ✅ **多语言对等**：所有语言功能一致
5. ✅ **安装正常**：install.sh 工作正常

---

**🎯 现在你拥有了一个完整的同步系统，既能保持与上游同步，又能维护自己的架构优势！**