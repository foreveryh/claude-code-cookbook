## PR Create Smart

从提交历史与 diff 自动拟写高质量 PR 描述，包含目标、改动、测试与相关 Issue。

### Usage

```bash
/pr-create-smart [--assignees <users>] [--labels <labels>]
```

### Options

- `--assignees <users>` : 以逗号分隔的 GitHub 用户名
- `--labels <labels>` : 以逗号分隔的标签（如 enhancement,needs-review）

### Basic Examples

```bash
# 为当前分支生成 PR 描述草稿
/pr-create-smart
"使用从 origin/main 以来的提交日志与 diff 统计生成 PR 正文。"

# 附带初始元数据
/pr-create-smart --assignees @me --labels enhancement
"生成包含：目标、改动、测试、截图（可选）、相关 Issue 的精简 PR 正文。"
```

### Claude Integration

```bash
# 提供 diff 统计与提交日志作为上下文
changes=$(git diff --stat origin/main..HEAD)
commits=$(git log origin/main..HEAD --oneline)

# 调用命令
/pr-create-smart --labels enhancement
"生成 PR 正文，包含：
- 目标（为什么）
- 改动（做了什么）
- 测试（如何验证）
- 风险/缓解
- 检查清单
- 相关 Issue（若文本中包含 #123，自动解析）
用项目符号列表，长度控制在约 400-600 字。"
```

### Considerations

- Prerequisites: 建议先整理本地提交历史（必要时 squash）。
- Limitations: 本命令仅生成正文草稿；实际创建 PR 仍通过 gh/GUI。
- Recommendations: 变更尽量聚焦；UI 改动附截图更佳。

### Related Commands (Optional)

- `/pr-check` : PR 前质量与安全检查清单
- `/pr-review` : 审查流程与反馈处理
