# 团队项目完整工作流指南

从拉取代码到提交 PR 的每一步详细说明

## 📋 工作流概览

```mermaid
flowchart LR
    A[1.拉取项目] --> B[2.项目分析]
    B --> C[3.任务拆解]
    C --> D[4.创建分支]
    D --> E[5.开发实现]
    E --> F[6.本地测试]
    F --> G[7.代码审查]
    G --> H[8.提交PR]
    H --> I[9.CI检查]
    I --> J[10.合并]
```

---

## 第 1 步：拉取项目并初始化环境

### 1.1 克隆项目
```bash
# 克隆项目
git clone https://github.com/team/project.git
cd project

# 或者如果已有项目，更新到最新
git fetch origin
git pull origin main
```

### 1.2 设置 Claude 项目配置（遵循官方做法）
```bash
# 在项目根创建 Claude.md 作为“唯一入口”上下文（/init 通常会生成）
cat > Claude.md << 'EOF'
# 项目总览（Claude 上下文入口）

本文件为 Claude 读取的项目上下文入口，保持简洁，指向更详细文档。

- 项目名称: [项目名]
- 技术栈: [React/Vue/Node.js等]
- 主要功能: [核心功能列表]
- 团队规范: [链接到 docs/CONTRIBUTING.md 或代码规范]
- 详细上下文导航:
  - docs/context/01-architecture.md
  - docs/context/02-backend.md
  - docs/context/03-frontend.md
  - docs/context/04-api-conventions.md
EOF

# 可选（推荐用于团队/中大型项目）：按主题维护模块化上下文文档
mkdir -p docs/context
cat > docs/context/01-architecture.md << 'EOF'
# 架构概览
- 系统边界与组件
- 数据流与依赖
- 部署拓扑
EOF
```

备注：
- 官方最佳实践是使用根目录 Claude.md 作为上下文入口。
- 若采用 docs/context/ 的模块化文档，请通过 Claude.md 进行导航引用；这些文件不会被“自动加载”，需要你在对话中明确引用，或通过自定义命令/Hook 按需拼接后注入上下文。

### ⚠️ 安全检查
```bash
# 确保不会泄露敏感信息
echo ".env" >> .gitignore
echo ".claude/secrets/" >> .gitignore
echo "*.key" >> .gitignore
```

---

## 第 2 步：让 Claude 分析项目

### 2.1 项目结构分析
```bash
# 使用 Claude 命令分析项目结构
/analyze-dependencies

# 或手动引导 Claude
"请分析这个项目的结构，包括：
1. 主要目录结构
2. 核心模块
3. 依赖关系
4. 构建和测试配置"
```

### 2.2 识别技术债务和潜在问题
```bash
# 使用技术债务分析命令
/tech-debt

# 输出示例：
# - 📊 代码复杂度高的文件
# - 🔄 循环依赖
# - ⚠️ 缺失的测试
# - 💭 TODO/FIXME 注释
```

### 2.3 理解业务逻辑
```bash
# 让 Claude 阅读关键文件
/explain-code src/core/business-logic.js

# 生成架构图
"基于代码分析，生成项目的架构图（mermaid格式）"
```

---

## 第 3 步：任务拆解

### 3.1 创建任务规格
```bash
# 使用 spec 命令创建详细规格
/spec

# Claude 会生成：
# - requirements.md (需求文档)
# - design.md (设计文档)  
# - tasks.md (任务列表)
```

### 3.2 任务优先级排序
```markdown
## 任务拆解示例

### 高优先级（必须完成）
- [ ] 修复用户登录 bug (#123)
- [ ] 添加输入验证
- [ ] 更新单元测试

### 中优先级（应该完成）
- [ ] 重构认证模块
- [ ] 添加错误日志

### 低优先级（可以完成）
- [ ] 优化性能
- [ ] 改进文档
```

### 3.3 估算时间
```bash
# 让 Claude 估算每个任务的时间
"基于任务复杂度，估算每个任务需要的时间：
- 任务1: 修复登录 bug
- 任务2: 添加验证
请给出乐观/现实/悲观三个时间估计"
```

---

## 第 4 步：创建功能分支

### 4.1 分支命名规范
```bash
# 创建符合团队规范的分支
git checkout -b feature/user-auth-improvement
# 或
git checkout -b fix/login-validation-bug
# 或
git checkout -b chore/update-dependencies

# 分支类型：
# - feature/ (新功能)
# - fix/     (修复bug)
# - chore/   (日常维护)
# - docs/    (文档更新)
```

### 4.2 关联 Issue
```bash
# 在分支名中包含 issue 编号
git checkout -b fix/login-bug-#123
```

---

## 第 5 步：开发实现（Claude 辅助）

### 5.1 实现代码
```bash
# 让 Claude 实现具体功能
"实现用户登录验证功能，要求：
1. 邮箱格式验证
2. 密码强度检查
3. 防暴力破解（rate limiting）
4. 遵循项目现有的代码风格"

# Claude 会：
# - 生成代码
# - 添加注释
# - 遵循项目规范
```

### 5.2 增量提交
```bash
# 使用语义化提交
/semantic-commit

# 这会把大改动拆分成多个有意义的提交：
# - feat: 添加邮箱验证函数
# - feat: 实现密码强度检查
# - feat: 添加 rate limiting 中间件
# - test: 添加登录验证测试用例
# - docs: 更新 API 文档
```

### 5.3 实时代码审查
```bash
# 让 Claude 审查刚写的代码
/smart-review

# 检查项：
# ✅ 代码风格
# ✅ 潜在bug
# ✅ 性能问题
# ✅ 安全漏洞
```

---

## 第 6 步：本地测试

### 6.1 运行单元测试
```bash
# 运行测试套件
npm test
# 或
yarn test
# 或
pytest

# 让 Claude 分析测试结果
"测试失败了，错误信息如下：[粘贴错误]
请帮我分析原因并修复"
```

### 6.2 运行 E2E 测试
```bash
# E2E 测试命令示例
npm run test:e2e

# 或使用 Claude 命令
/test-e2e-local

# 典型的 E2E 测试流程：
# 1. 启动测试服务器
# 2. 运行 Cypress/Playwright 测试
# 3. 生成测试报告
```

### 6.3 代码覆盖率检查
```bash
# 生成覆盖率报告
npm run test:coverage

# 确保覆盖率达标（通常 >80%）
# 如果不达标，让 Claude 补充测试：
"当前测试覆盖率是 72%，请为以下未覆盖的函数添加测试：
- validateEmail()
- checkPasswordStrength()"
```

---

## 第 7 步：提交前的最终检查

### 7.1 代码质量检查
```bash
# Lint 检查
npm run lint

# 格式化
npm run format

# 类型检查（如果使用 TypeScript）
npm run type-check
```

### 7.2 安全扫描
```bash
# 检查依赖漏洞
npm audit
# 修复漏洞
npm audit fix

# 检查敏感信息泄露
git diff --staged | grep -E "(password|secret|key|token)" 
# 如果发现敏感信息，不要提交！
```

### 7.3 构建验证
```bash
# 确保项目能成功构建
npm run build

# 验证构建产物
ls -la dist/
```

### 7.4 部署前就绪检查（推荐）
```bash
# 使用命令意图进行标准化部署前门禁
/deploy-check --env staging --smoke-url https://staging.example.com/health
"以下为本地/CI 输出摘要与环境概要，请根据清单判定 PASS/FAIL 并给出修复建议：\n[粘贴 lint/test/build/audit 摘要，必需环境变量，迁移计划（如有）]"
```

---

## 第 8 步：创建 Pull Request

### 8.1 推送分支
```bash
# 推送到远程
git push origin feature/user-auth-improvement
```

### 8.2 创建 PR
```bash
# 使用 Claude 命令创建 PR 草稿
/pr-create-smart

# 或使用 gh CLI
gh pr create \
  --title "feat: 改进用户认证流程" \
  --body "## 改动说明
  
  ### 🎯 目标
  修复登录验证问题 (#123)
  
  ### ✅ 改动内容
  - 添加邮箱格式验证
  - 实现密码强度检查
  - 添加防暴力破解机制
  
  ### 🧪 测试
  - [x] 单元测试通过
  - [x] E2E 测试通过
  - [x] 手动测试完成
  
  ### 📝 截图/演示
  [如果有UI改动，添加截图]
  "
```

### 8.3 设置 PR 元数据
```bash
# 添加标签
gh pr edit --add-label "enhancement,needs-review"

# 指定审查者
gh pr edit --add-reviewer @teammate1,@teammate2

# 关联 issue
gh pr edit --body "Fixes #123"
```

---

## 第 9 步：CI/CD 检查

### 9.1 监控 CI 状态
```bash
# 查看 CI 状态
/check-github-ci

# 或使用 gh
gh pr checks

# 持续监控直到完成
watch -n 30 "gh pr checks"
```

### 9.2 处理 CI 失败
```bash
# 如果 CI 失败，获取日志
gh run view <run-id> --log

# 让 Claude 分析失败原因
/fix-error "CI 失败，错误信息：[粘贴错误日志]"

# 修复后重新推送
git add .
git commit -m "fix: 修复 CI 测试失败"
git push
```

---

## 第 10 步：响应审查意见

### 10.1 查看审查意见
```bash
# 获取 PR 反馈
gh pr view --comments

# 使用 Claude 处理反馈
/pr-feedback
```

### 10.2 进行修改
```bash
# 根据反馈修改代码
# Claude 会帮助理解和实现审查建议

# 提交修改
git add .
git commit -m "refactor: 根据审查意见优化代码"
git push
```

### 10.3 回复审查
```bash
# 回复每个审查意见
gh pr comment --body "已修复，使用了更高效的算法"

# 请求重新审查
gh pr review --request
```

---

## 🛡️ 安全检查清单

### 每个步骤的安全要点：

| 步骤 | 安全检查 | 风险等级 |
|-----|---------|---------|
| 拉取代码 | 验证仓库来源 | 低 |
| 项目分析 | 不暴露敏感配置 | 中 |
| 任务拆解 | 不在公开文档中提及安全漏洞 | 高 |
| 创建分支 | 使用规范的分支名 | 低 |
| 开发实现 | 不硬编码密钥/密码 | 高 |
| 本地测试 | 使用测试数据，不用生产数据 | 高 |
| 代码审查 | 检查安全漏洞 | 高 |
| 提交 PR | 不包含敏感文件 | 高 |
| CI 检查 | 不在日志中打印敏感信息 | 中 |
| 合并 | 确保所有检查通过 | 中 |

---

## 🚀 最佳实践建议

### 1. 小步提交
```bash
# ✅ 好的做法：每个逻辑改动一个提交
git add src/validators/email.js
git commit -m "feat: add email validation"

git add src/validators/password.js  
git commit -m "feat: add password strength check"

# ❌ 不好的做法：所有改动一个提交
git add .
git commit -m "update code"
```

### 2. 充分测试
```bash
# 在提 PR 前运行完整测试
npm run test && npm run test:e2e && npm run lint
```

### 3. 文档同步
```bash
# 代码改动后更新文档
"我修改了 API，请帮我更新 README 和 API 文档"
```

### 4. 及时沟通
```bash
# 遇到阻塞及时沟通
gh issue comment 123 --body "遇到问题：[描述]，需要帮助"
```

---

## 🔧 常用 Claude 命令速查

| 命令 | 用途 | 使用时机 |
|-----|-----|---------|
| `/analyze-dependencies` | 分析项目依赖 | 项目初始化 |
| `/spec` | 创建任务规格 | 开始新功能 |
| `/explain-code` | 解释代码逻辑 | 理解复杂代码 |
| `/fix-error` | 修复错误 | 遇到 bug |
| `/smart-review` | 代码审查 | 提交前 |
| `/semantic-commit` | 语义化提交 | 提交代码 |
| `/pr-check` | PR 前检查清单 | 提交前 |
| `/pr-create-smart` | 生成 PR 描述草稿 | 准备合并 |
| `/test-e2e-local` | 本地 E2E 验证 | 提交前 |
| `/check-github-ci` | 检查 CI | PR 创建后 |
| `/pr-feedback` | 处理反馈 | 收到审查意见 |

---

## 📝 实战示例

### 完整的工作流示例：修复登录 Bug

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 分析问题
/explain-code src/auth/login.js
"这个登录函数有什么问题？"

# 3. 创建修复分支
git checkout -b fix/login-validation-#456

# 4. 实现修复
"修复登录验证问题，确保：
1. 邮箱格式正确
2. 防止 SQL 注入
3. 添加测试用例"

# 5. 运行测试
npm test src/auth/login.test.js

# 6. 提交改动
/semantic-commit

# 7. 推送并创建 PR
git push origin fix/login-validation-#456
/pr-create-smart

# 8. 监控 CI
/check-github-ci

# 9. 响应反馈
/pr-feedback

# 10. 合并
gh pr merge --squash
```

---

## ❓ 常见问题

### Q: Claude 生成的代码安全吗？
A: 始终要审查 Claude 生成的代码，特别注意：
- 不要包含硬编码的密钥
- 验证所有用户输入
- 使用参数化查询防止注入

### Q: 如何确保不提交敏感信息？
A: 
1. 使用 `.gitignore` 排除敏感文件
2. 使用环境变量管理密钥
3. 提交前用 `git diff` 检查
4. 使用 pre-commit hooks 自动检查

### Q: CI 总是失败怎么办？
A: 
1. 本地先运行相同的测试
2. 查看 CI 日志找到具体错误
3. 让 Claude 分析错误：`/fix-error [错误信息]`
4. 确保本地环境与 CI 环境一致

记住：**安全第一，质量第二，速度第三**
