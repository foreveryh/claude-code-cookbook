## PR Check

在创建 Pull Request 前执行规范化检查，覆盖代码质量、测试、构建与安全门禁。

### Usage

```bash
/pr-check [--strict]
```

### Options

- `--strict` : 更严格的门禁（例如更高的覆盖率阈值、零 audit 警告）

### Basic Examples

```bash
# 标准检查
/pr-check
"请分析下面提供的 staged diff 和本地输出，列出阻塞项并给出可执行修复建议。"

# 严格模式
/pr-check --strict
"启用更高标准：变更文件覆盖率需 >90%，且不允许 audit 警告。"
```

### Claude Integration

```bash
# 先提供上下文，再调用命令
# 1) 展示当前分支、暂存变更、项目脚本
git branch --show-current && git status --porcelain && cat package.json

# 2) 粘贴最近的 lint/test/build 输出（示例占位，替换为真实输出）
# --- LINT OUTPUT START ---
# ...
# --- LINT OUTPUT END ---
# --- TEST OUTPUT START ---
# ...
# --- TEST OUTPUT END ---
# --- BUILD OUTPUT START ---
# ...
# --- BUILD OUTPUT END ---

# 3) 调用命令
/pr-check --strict
"请按门禁项（lint、type-check、unit、e2e 可选、build、敏感扫描、audit）给出通过/未过结论；对未过项提供具体修复命令或 diff。"
```

### Considerations

- Prerequisites: 项目应定义 lint/test/build/type-check 等脚本。
- Limitations: 依赖用户提供的上下文（输出与 diff），请提供精炼且充分的日志。
- Recommendations: PR 粒度要小；本地先跑通过再调用本命令可更高效。

### Related Commands (Optional)

- `/pr-create-smart` : 基于提交历史与 diff 生成 PR 描述草稿
- `/test-e2e-local` : 本地启动 E2E 验证关键流程
