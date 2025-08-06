## 提交消息

从暂存的更改（git diff --staged）生成合适的提交消息。仅生成消息并复制到剪贴板，不执行 git 命令。

### 使用方法

```bash
/commit-message [选项]
```

### 选项

- `--format <格式>` : 指定消息格式（conventional, gitmoji, angular）
- `--lang <语言>` : 强制指定消息语言（en, zh）
- `--breaking` : 检测并记录 Breaking Change

### 基本示例

```bash
# 从暂存的更改生成消息（自动判定语言）
# 主要候选会自动复制到剪贴板
/commit-message

# 强制指定语言
/commit-message --lang zh
/commit-message --lang en

# 检测 Breaking Change
/commit-message --breaking
```

### 前提条件

**重要**: 此命令仅分析暂存的更改。需要先使用 `git add` 暂存更改。

```bash
# 如果没有暂存更改，会显示警告
$ /commit-message
没有暂存的更改。请先执行 git add。
```

### 自动剪贴板功能

生成的主要候选会以 `git commit -m "消息"` 的完整格式自动复制到剪贴板。可以直接在终端粘贴执行。

**实现注意事项**:

- 将提交命令传递给 `pbcopy` 时，应与消息输出分开执行
- 使用 `printf` 而不是 `echo` 以避免末尾换行

### 项目规范自动检测

**重要**: 如果存在项目特有的规范，将优先使用。

#### 1. CommitLint 配置检查

从以下文件自动检测配置：

- `commitlint.config.js`
- `commitlint.config.mjs`
- `commitlint.config.cjs`
- `commitlint.config.ts`
- `.commitlintrc.js`
- `.commitlintrc.json`
- `.commitlintrc.yml`
- `.commitlintrc.yaml`
- `package.json` 的 `commitlint` 部分

```bash
# 搜索配置文件
find . -name "commitlint.config.*" -o -name ".commitlintrc.*" | head -1
```

#### 2. 自定义类型检测

项目特有类型示例：

```javascript
// commitlint.config.mjs
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore',
        'wip',      // 进行中
        'hotfix',   // 紧急修复
        'release',  // 发布
        'deps',     // 依赖更新
        'config'    // 配置更改
      ]
    ]
  }
}
```

#### 3. 语言设置检测

```javascript
// 项目使用中文消息时
export default {
  rules: {
    'subject-case': [0],  // 为支持中文而禁用
    'subject-max-length': [2, 'always', 72]  // 为中文调整字符数限制
  }
}
```

#### 4. 现有提交历史分析

```bash
# 从最近的提交学习使用模式
git log --oneline -50 --pretty=format:"%s"

# 使用类型统计
git log --oneline -100 --pretty=format:"%s" | \
grep -oE '^[a-z]+(\([^)]+\))?' | \
sort | uniq -c | sort -nr
```

### 语言自动判定

根据以下条件自动切换中文/英文：

1. **CommitLint 配置**中的语言设置
2. **git log 分析**的自动判定
3. **项目文件**的语言设置
4. **更改文件**中的注释和字符串分析

默认为英文。判定为中文项目时生成中文消息。

### 消息格式

#### Conventional Commits (默认)

```
<type>: <description>
```

**重要**: 必须生成单行提交消息。不生成多行消息。

**注意**: 如果项目有特有规范，将优先使用。

### 标准类型

**必须类型**:

- `feat`: 新功能（用户可见的功能添加）
- `fix`: 缺陷修复

**可选类型**:

- `build`: 构建系统或外部依赖的更改
- `chore`: 其他更改（不影响发布）
- `ci`: CI 配置文件或脚本的更改
- `docs`: 仅文档更改
- `style`: 不影响代码含义的更改（空格、格式、分号等）
- `refactor`: 既不修复缺陷也不添加功能的代码更改
- `perf`: 性能改进
- `test`: 添加或修正测试

### 输出示例（中文项目）

```bash
$ /commit-message

📝 提交消息建议
━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要候选:
feat: 实现基于 JWT 的认证系统

📋 备选方案:
1. feat: 添加 JWT 令牌的用户认证
2. fix: 解决认证中间件的令牌验证错误
3. refactor: 将认证逻辑提取到独立模块

✅ `git commit -m "feat: 实现基于 JWT 的认证系统"` 已复制到剪贴板
```

**实现示例（修正版）**:

```bash
# 先将提交命令复制到剪贴板（无换行）
printf 'git commit -m "%s"' "$COMMIT_MESSAGE" | pbcopy

# 然后显示消息
cat << EOF
📝 提交消息建议
━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要候选:
$COMMIT_MESSAGE

📋 备选方案:
1. ...
2. ...
3. ...

✅ `git commit -m "$COMMIT_MESSAGE"` 已复制到剪贴板
EOF
```

### Breaking Change 检测

自动检测可能的破坏性更改：

- API 签名更改
- 配置格式更改
- 依赖主版本升级
- 数据库架构更改
- 行为不兼容更改

```bash
$ /commit-message --breaking

⚠️ 检测到 Breaking Change:
- API 端点从 /api/v1/users 更改为 /api/v2/users
- 删除了已弃用的配置选项 `legacy_mode`

feat!: 迁移到 API v2 并删除遗留支持
```

### 项目特定规则

如果检测到项目特定规则，会自动应用：

```bash
# 如果项目使用 scope
feat(auth): 添加双因素认证

# 如果项目使用 issue 编号
fix: 修复登录重定向问题 (#123)

# 如果项目使用 gitmoji
✨ feat: 添加深色模式支持
```

### 最佳实践

1. **简洁明了**: 使用祈使语气，说明做了什么
2. **关注原因**: 说明为什么做这个更改，而不仅是怎么做
3. **引用问题**: 如果相关，引用 issue 或 PR 编号
4. **保持一致**: 遵循项目已有的提交消息风格

### 高级功能

#### 批量提交建议

如果暂存的更改过多且不相关，建议拆分：

```bash
$ /commit-message

⚠️ 检测到多个不相关的更改。建议拆分为多个提交：

1. 认证相关更改:
   feat: 添加 OAuth2 认证支持
   文件: auth/*.js

2. UI 改进:
   style: 更新按钮样式和颜色主题
   文件: components/Button.*

3. 文档更新:
   docs: 更新 API 文档和示例
   文件: docs/*.md
```

#### 智能类型推荐

根据文件更改内容智能推荐类型：

- `.test.js` 更改 → `test:`
- `package.json` 更改 → `deps:` 或 `build:`
- `.github/workflows/` 更改 → `ci:`
- `README.md` 更改 → `docs:`
- 性能相关关键词 → `perf:`
