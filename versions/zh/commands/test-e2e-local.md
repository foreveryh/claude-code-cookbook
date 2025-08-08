## Test E2E Local

在本地拉起 E2E 测试环境，验证关键用户路径。

### Usage

```bash
/test-e2e-local [--headless]
```

### Options

- `--headless` : 以无头模式运行浏览器测试（若测试框架支持）

### Basic Examples

```bash
# 启动本地应用并运行 E2E
/test-e2e-local
"使用项目标准脚本 start:test 与 test:e2e，确保失败时也能清理进程。"

# 无头模式
/test-e2e-local --headless
"如支持，优先选择无头模式。"
```

### Claude Integration

```bash
# 提供项目脚本与环境变量作为上下文
cat package.json | jq '.scripts'

# 可选：粘贴 .env.test（注意涂抹敏感信息）
# --- ENV TEST START ---
# ...
# --- ENV TEST END ---

# 调用
/test-e2e-local
"计划：1) 启动测试服务器；2) 等待就绪；3) 运行 e2e；4) 收集产物；5) 关闭服务。若脚本不同，请给出替代方案。"
```

### Considerations

- Prerequisites: 项目需提供 `start:test` 与 `test:e2e` 脚本（或在提示中说明替代脚本）。
- Limitations: 本地波动与 CI 可能不同；建议保留日志/截图等产物便于排查。
- Recommendations: 保持测试确定性、加健康检查、确保正确清理资源。

### Related Commands (Optional)

- `/pr-check` : PR 前质量门禁
- `/pr-create-smart` : 基于改动生成 PR 正文草稿
