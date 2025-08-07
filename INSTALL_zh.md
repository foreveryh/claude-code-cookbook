# 安装指南

[English](INSTALL.md) | [日本語](INSTALL_ja.md) | [中文](INSTALL_zh.md)

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/foreveryh/claude-code-cookbook.git
cd claude-code-cookbook

# 运行安装程序（交互模式）
./install.sh

# 或使用参数（非交互模式）
./install.sh --lang zh  # 中文版
./install.sh --lang en  # 英文版
```

## 手动安装

如果您更喜欢手动安装：

### 1. 选择语言版本

可用版本位于 `versions/` 目录：
- `versions/en/` - 英文版
- `versions/ja/` - 日文版（日本語）
- `versions/zh/` - 中文版（中文版）✅ 已完成
- `versions/fr/` - 法文版（Français）[即将推出]
- `versions/ko/` - 韩文版（한국어）[即将推出]

### 2. 复制到 Claude 目录

```bash
# 中文版
cp -r versions/zh ~/.claude

# 英文版
cp -r versions/en ~/.claude

# 日文版
cp -r versions/ja ~/.claude
```

### 3. 设置脚本执行权限

```bash
chmod +x ~/.claude/scripts/*.sh
```

## 配置 Claude Desktop

1. 打开 Claude Desktop 应用
2. 导航到：**设置** → **开发者**
3. 设置**自定义指令**路径为：`~/.claude`
4. 如果需要，重启 Claude

## 高级用法

### 交互式安装
不带参数运行以使用交互式安装程序：
```bash
./install.sh
```
安装程序将：
- 自动检测系统语言
- 如果检测失败则显示菜单
- 引导您完成安装过程

### 非交互式安装
使用参数进行脚本化/自动化安装：
```bash
# 使用 PPINFRA 模型安装中文版
./install.sh --lang zh --model ppinfra

# 使用 Gemini 模型安装英文版
./install.sh --lang en --model gemini

# 自定义目标目录
./install.sh --lang zh --target ~/custom-claude

# 模拟运行（预览但不做更改）
./install.sh --lang zh --dry-run

# 跳过验证步骤
./install.sh --lang zh --no-verify
```

### 可用选项
- `--lang {en,ja,zh}`：安装语言
- `--model {ppinfra,gemini}`：AI 模型后端（默认：ppinfra）
- `--target <路径>`：目标目录（默认：~/.claude）
- `--dry-run`：预览模式，不进行实际更改
- `--no-verify`：跳过安装后验证
- `--help`：显示帮助信息

## 切换语言

要切换到不同的语言版本：

```bash
# 备份当前版本
mv ~/.claude ~/.claude.backup

# 安装新版本
./install.sh --lang [语言代码]
```

## 目录结构

```
~/.claude/
├── commands/       # 自定义命令（/命令名）
├── agents/        
│   └── roles/     # 角色定义
├── scripts/       # 自动化脚本
└── settings.json  # 配置文件
```

## 验证安装

安装后，验证设置：

```bash
# 检查安装
ls -la ~/.claude

# 验证结构
./utils/validate.sh

# 在 Claude 中测试命令
# 输入：/role-help
```

## 故障排除

### 权限问题
```bash
# 修复脚本权限
chmod +x ~/.claude/scripts/*.sh
```

### 路径问题
- 确保 Claude 配置了正确的路径
- 如果 `~/.claude` 不起作用，请使用绝对路径：`/Users/[用户名]/.claude`

### 版本不匹配
- 运行 `./utils/validate.sh` 检查版本完整性
- 使用 `./utils/sync-versions.sh` 同步公共文件

## 更新

要更新到最新版本：

```bash
# 拉取最新更改
git pull

# 重新运行安装程序
./install.sh
```

## 卸载

要删除 Claude Code Cookbook：

```bash
# 删除 .claude 目录
rm -rf ~/.claude

# 可选：恢复备份
mv ~/.claude.backup ~/.claude
```

## 支持

- **问题反馈**：[GitHub Issues](https://github.com/foreveryh/claude-code-cookbook/issues)
- **文档**：查看各语言的 README 文件
- **贡献**：欢迎贡献！请参阅 CONTRIBUTING.md

## 语言支持状态

| 语言 | 命令 | 角色 | 脚本 | 状态 |
|------|------|------|------|------|
| 英文 | ✅ | ✅ | ✅ | 完成 |
| 日文 | ✅ | ✅ | ✅ | 完成 |
| 中文 | ✅ | ✅ | ✅ | 完成 |
| 法文 | 🚧 | 🚧 | ⏳ | 计划中 |
| 韩文 | 🚧 | 🚧 | ⏳ | 计划中 |

✅ 完成 | 🚧 进行中 | ⏳ 计划中

## 中文版特色功能

### 本地化内容
- **38 个中文命令**：所有命令均已完全本地化，包括描述、示例和提示
- **8 个专业角色**：架构师、安全专家、性能优化等角色，均使用中文交互
- **9 个自动化脚本**：包括中文空格格式化、权限保护、继续检查等

### 智能语言检测
安装程序会自动检测您的系统语言：
- 如果系统语言设置为中文（zh_CN、zh_TW 等），将自动选择中文版
- 否则会显示语言选择菜单

### 中文优化
- **中英文混排优化**：`zh-space-format.sh` 自动在中文和英文之间添加合适的空格
- **中文提交消息**：支持生成符合规范的中文 Git 提交消息
- **中文文档字符串**：自动生成和更新中文的代码注释和文档

## 完成度说明

中文版已经完成了以下本地化工作：

✅ **Commands（38 个）**
- 所有命令描述和示例均已翻译
- 保留了技术术语的准确性
- 适应中文用户的使用习惯

✅ **Agents/Roles（8 个）**
- 架构师、安全专家、性能优化专家等
- 所有角色描述和交互均使用中文
- 保持了专业性和准确性

✅ **Scripts（9 个）**
- 完全本地化所有脚本注释和消息
- 清除了所有日语字符遗留
- 适配中文环境的特殊需求

## 开始使用

安装完成后，您可以在 Claude 中使用以下命令开始：

```
/role-help              # 查看可用角色
/commit-message         # 生成提交消息
/analyze-dependencies   # 分析项目依赖
/refactor              # 代码重构建议
/smart-review          # 智能代码审查
```

祝您使用愉快！🎉
