## Deploy Check

部署前的安全检查与就绪评估命令，确保待发布版本满足目标环境的门禁要求。

### Usage

```bash
/deploy-check [--env <staging|production|custom>] [--smoke-url <url>] [--migrations] [--strict]
```

### Options

- `--env <staging|production|custom>` : 目标环境（影响检查项权重/阈值）
- `--smoke-url <url>` : 部署后的健康/冒烟检查地址（如有）
- `--migrations` : 包含数据库迁移就绪性检查（dry-run/plan）
- `--strict` : 更严格门禁（0 漏洞、无 TODO/FIXME、覆盖率阈值等）
- `--template` : 输出标准 Markdown 检查清单模板（便于 CI 产物或人工审核）

### Basic Examples

```bash
# 输出标准清单模板（用于 CI 产物或复制到变更单）
/deploy-check --template
"输出一份 Markdown 清单，便于复制粘贴。"
```

```bash
# 测试环境部署前检查
/deploy-check --env staging --smoke-url https://staging.example.com/health
"结合下方提供的构建/测试/audit 输出与环境变量，判断就绪度并列出阻塞项与修复步骤。"

# 生产环境，包含迁移检查
/deploy-check --env production --migrations --strict
"以最小停机为约束，校验回滚策略与配置漂移。"
```

### Claude Integration

```bash
# 1) 分支与脏工作区
 git branch --show-current && git status --porcelain

# 2) 与 main 同步情况（粘贴结果）
 git fetch origin && git rev-parse --short HEAD && git rev-parse --short origin/main && git log --oneline -5

# 3) 提供 lint/test/build/audit 摘要日志（粘贴精简输出）
# --- LINT OUTPUT START ---
# ...
# --- TEST OUTPUT START ---
# ...
# --- BUILD OUTPUT START ---
# ...
# --- AUDIT OUTPUT START ---
# ...

# 4) 目标环境所需关键环境变量（注意打码）
# API_URL=...
# DATABASE_URL=...
# SECRET_KEY=...

# 5) 若需迁移，粘贴迁移计划/dry-run
# --- MIGRATION PLAN START ---
# ...
# --- MIGRATION PLAN END ---

# 6) 可选：当前基础设施/配置概览（IaC 漂移、镜像 tag、副本数）
# --- INFRA SUMMARY START ---
# ...
# --- INFRA SUMMARY END ---

# 7) 执行
/deploy-check --env production --migrations --strict
"输出门禁清单（PASS/FAIL），对 FAIL 项给出可执行修复步骤/命令；补充风险评估、回滚方案与部署后冒烟步骤（curl <url> / 检查日志）。"
```

### 机制说明（Mechanism）

这是一个“意图定义命令”。它不会执行部署，而是：
- 将部署前门禁统一为可核查的清单（分支与脏工作区、与 main 同步、测试/构建/audit、环境变量、迁移就绪、配置/基础设施、冒烟就绪）
- 基于用户提供的上下文（日志/差异/环境摘要）做 PASS/FAIL 判断
- 输出：
  - 明确的门禁结果（逐项 PASS/FAIL）
  - 对 FAIL 的具体修复步骤与命令
  - 最小化的冒烟验证与回滚预案

### 模板（输出示例）

```
# 部署就绪清单

- [ ] 分支干净（无未提交变更）
- [ ] 与 main 同步（HEAD == origin/main 或给出合理说明）
- [ ] Lint 通过
- [ ] 类型检查通过（如适用）
- [ ] 单元测试通过
- [ ] E2E 测试通过（或给出范围与说明）
- [ ] 构建成功
- [ ] 安全审计：0 个严重/高危（如有，需列出缓解措施）
- [ ] 必需环境变量：API_URL、DATABASE_URL、SECRET_KEY
- [ ] 迁移已评审（附 dry-run/plan）
- [ ] 基础设施/配置漂移已检查（IaC、镜像 tag、副本数）
- [ ] 回滚预案已记录
- [ ] 部署后冒烟：curl <SMOKE_URL> 与日志检查
```

### Considerations

- Prerequisites: 项目应有标准脚本（lint/test/build）；安全/audit 工具可用。
- Limitations: 结论依赖于粘贴的日志与环境摘要的准确性。
- Recommendations: 在 CI 中自动生成所需上下文；生产环境任何高风险操作需二次人工确认。

### Related Commands (Optional)

- `/pr-check` : PR 前质量门禁
- `/test-e2e-local` : 本地 E2E 验证
- `/check-github-ci` : 追踪 CI 状态
