# 🚀 Claude Code Cookbook 完整工作流程指南

## 🎯 **概览**

你现在拥有一个完整的同步和版本管理生态系统，包含5个核心工具：

```
utils/
├── 🔄 sync-upstream.sh      # 上游同步工具
├── 🌍 translate-content.py  # 翻译管理工具  
├── 🚀 release-manager.sh    # 版本发布工具
├── 🧹 cleanup-structure.sh  # 结构清理工具
└── 🎛️ workflow-manager.sh   # 统一工作流程管理器
```

## 🎛️ **统一工作流程管理器** (推荐使用)

### **交互式模式** (最简单)

```bash
./utils/workflow-manager.sh interactive
```

这将启动一个友好的交互式菜单，让你选择需要的工作流程。

### **命令行模式**

```bash
# 完整同步工作流程
./utils/workflow-manager.sh sync

# 翻译工作流程
./utils/workflow-manager.sh translate zh

# 发布工作流程  
./utils/workflow-manager.sh release v2.1.0

# 维护工作流程
./utils/workflow-manager.sh maintenance

# 项目状态概览
./utils/workflow-manager.sh status
```

## 📋 **标准工作流程**

### **1. 日常同步工作流程** ⭐ **最常用**

```bash
# 方法 1: 使用统一管理器 (推荐)
./utils/workflow-manager.sh sync

# 方法 2: 手动步骤
./utils/sync-upstream.sh check          # 检查更新
./utils/cleanup-structure.sh full       # 清理结构
./utils/sync-upstream.sh sync           # 同步内容
python3 utils/translate-content.py status  # 检查翻译
```

**这个工作流程会**：
- ✅ 检查上游49个新提交
- ✅ 清理冗余的根目录语言文件
- ✅ 同步所有新功能到 versions/ 结构
- ✅ 保持你的先进功能
- ✅ 验证多语言完整性

### **2. 翻译管理工作流程**

```bash
# 使用统一管理器
./utils/workflow-manager.sh translate ja

# 或手动步骤
python3 utils/translate-content.py scan           # 扫描需求
python3 utils/translate-content.py translate --lang ja  # 翻译
python3 utils/translate-content.py validate       # 验证
```

### **3. 版本发布工作流程**

```bash
# 使用统一管理器
./utils/workflow-manager.sh release v2.1.0

# 或手动步骤
./utils/release-manager.sh validate        # 验证准备
./utils/release-manager.sh prepare v2.1.0  # 准备发布
./utils/release-manager.sh package v2.1.0  # 创建包
./utils/release-manager.sh publish v2.1.0  # 发布
```

### **4. 维护检查工作流程**

```bash
# 使用统一管理器
./utils/workflow-manager.sh maintenance

# 或手动步骤
./utils/cleanup-structure.sh analyze       # 分析结构
./utils/sync-upstream.sh check            # 检查更新
python3 utils/translate-content.py status # 翻译状态
./utils/release-manager.sh stats          # 统计信息
```

## 🔧 **单独工具使用**

### **sync-upstream.sh** - 上游同步

```bash
# 检查上游更新 (安全，无副作用)
./utils/sync-upstream.sh check

# 完整同步
./utils/sync-upstream.sh sync

# 预览同步 (不实际修改)
./utils/sync-upstream.sh sync --dry-run

# 同步特定语言
./utils/sync-upstream.sh sync --lang zh
```

### **translate-content.py** - 翻译管理

```bash
# 查看翻译状态
python3 utils/translate-content.py status

# 扫描需要翻译的内容
python3 utils/translate-content.py scan

# 翻译特定语言 (生成翻译提示)
python3 utils/translate-content.py translate --lang ja

# 验证版本完整性
python3 utils/translate-content.py validate
```

### **release-manager.sh** - 版本发布

```bash
# 验证发布准备
./utils/release-manager.sh validate

# 查看项目统计
./utils/release-manager.sh stats

# 准备发布
./utils/release-manager.sh prepare v2.1.0

# 创建发布包
./utils/release-manager.sh package v2.1.0

# 发布到 Git
./utils/release-manager.sh publish v2.1.0
```

### **cleanup-structure.sh** - 结构清理

```bash
# 分析当前结构
./utils/cleanup-structure.sh analyze

# 清理冗余文件
./utils/cleanup-structure.sh cleanup

# 完整清理和同步
./utils/cleanup-structure.sh full

# 与同步工具集成
./utils/cleanup-structure.sh integrate
```

## 🎯 **常见使用场景**

### **场景 1: 获取上游最新功能**

```bash
# 一键完成
./utils/workflow-manager.sh sync

# 验证结果
./install.sh --lang en --dry-run
```

### **场景 2: 添加新语言支持**

```bash
# 1. 创建语言版本目录
mkdir -p versions/de/{commands,agents/roles,scripts,hooks}

# 2. 复制英语版本作为基础
cp -r versions/en/* versions/de/

# 3. 翻译内容
./utils/workflow-manager.sh translate de

# 4. 验证完整性
python3 utils/translate-content.py validate
```

### **场景 3: 发布新版本**

```bash
# 1. 确保所有更改已提交
git status

# 2. 运行完整工作流程
./utils/workflow-manager.sh release v2.1.0

# 3. 验证发布
git tag -l | grep v2.1.0
```

### **场景 4: 定期维护**

```bash
# 每周运行
./utils/workflow-manager.sh maintenance

# 检查是否需要更新
./utils/sync-upstream.sh check
```

## 🌟 **架构优势确认**

运行同步后，你的项目将保持以下优势：

### **✅ 结构优势**
- `versions/` 结构比上游 `locales/` 更清晰
- 每个语言版本功能完整对等
- 安装器智能选择语言版本

### **✅ 功能领先**
- 保持你的先进功能 (pr-create-smart, deploy-check 等)
- 获得上游新功能 (statusline.sh, 优化脚本等)
- 性能优化的钩子系统

### **✅ 多语言完整性**
- 英语: 42 commands, 8 agents ✅
- 中文: 42 commands, 8 agents ✅  
- 日语: 42 commands, 8 agents ✅
- 法语/韩语: 可通过翻译工具补全

## 🔄 **推荐维护计划**

### **每周**
```bash
./utils/sync-upstream.sh check
```

### **每月**
```bash
./utils/workflow-manager.sh sync
```

### **发布前**
```bash
./utils/workflow-manager.sh maintenance
./utils/workflow-manager.sh release v2.x.0 --dry-run
```

## 🚨 **故障排除**

### **问题 1: 工具权限错误**
```bash
chmod +x utils/*.sh utils/*.py
```

### **问题 2: 上游远程未配置**
```bash
git remote add upstream https://github.com/wasabeef/claude-code-cookbook.git
```

### **问题 3: Python 依赖缺失**
```bash
# 检查 Python 和 jq
python3 --version
jq --version
```

### **问题 4: 工作目录不干净**
```bash
git status
git add .
git commit -m "Prepare for sync"
```

## 🎉 **成功指标**

同步成功后，你应该看到：

1. ✅ **新脚本**: `scripts/statusline.sh` 存在
2. ✅ **版本对等**: 所有语言版本命令数量一致
3. ✅ **安装正常**: `./install.sh --lang en` 成功
4. ✅ **结构清晰**: 根目录冗余文件已清理
5. ✅ **功能完整**: 保持先进功能 + 获得上游改进

---

## 🎯 **快速开始**

**第一次使用**：
```bash
# 1. 运行交互式管理器
./utils/workflow-manager.sh interactive

# 2. 选择 "1) 完整同步工作流程"
# 3. 选择预览模式查看会做什么
# 4. 确认后执行实际同步
```

**日常使用**：
```bash
# 一键同步
./utils/workflow-manager.sh sync
```

**🎉 现在你拥有了业界最先进的 Claude Code Cookbook 同步和管理系统！**