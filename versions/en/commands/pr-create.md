## PR Create

Achieve efficient Pull Request workflow with automatic PR creation based on Git change analysis.

### Usage

```bash
# Automatic PR creation with change analysis
git add . && git commit -m "feat: Implement user authentication"
"Analyze changes and create a Draft PR with appropriate description and labels"

# Update while preserving existing template
cp .github/PULL_REQUEST_TEMPLATE.md pr_body.md
"Complete the change details while fully preserving template structure"

# Gradual quality improvement
gh pr ready
"After quality check, change to Ready for Review"
```

### Basic Examples

```bash
# 1. Create branch and commit
git checkout main && git pull
git checkout -b feat-user-profile
git add . && git commit -m "feat: Implement user profile feature"
git push -u origin feat-user-profile

# 2. Create PR
"Please create a PR following these steps:
1. Check changes with git diff --cached
2. Create description using .github/PULL_REQUEST_TEMPLATE.md
3. Select up to 3 appropriate labels based on changes
4. Create as Draft PR (preserve HTML comments)"

# 3. Ready after CI check
"Once CI passes, change PR to Ready for Review"
```

### Execution Steps

#### 1. Branch Creation

```bash
# Naming convention following guidelines: {type}-{subject}
git checkout main
git pull
git checkout -b feat-user-authentication

# Verify branch (display current branch name)
git branch --show-current
```

#### 2. Commit

```bash
# Stage changes
git add .

# Commit message following guidelines
git commit -m "feat: Implement user authentication API"
```

#### 3. Push to Remote

```bash
# Initial push (set upstream)
git push -u origin feat-user-authentication

# Subsequent pushes
git push
```

#### 4. Create Draft PR with Automatic Analysis

**Step 1: Analyze Changes**

```bash
# Get file changes (check staged changes)
git diff --cached --name-only

# Content analysis (max 1000 lines)
git diff --cached | head -1000
```

**Step 2: Auto-generate Description**

```bash
# Template processing priority
# 1. Existing PR description (fully preserve)
# 2. .github/PULL_REQUEST_TEMPLATE.md
# 3. Default template

cp .github/PULL_REQUEST_TEMPLATE.md pr_body.md
# Complete only empty sections while preserving HTML comments and dividers
```

**Step 3: Auto-select Labels**

```bash
# Get available labels (non-interactive)
"Get available labels from .github/labels.yml or GitHub repository and auto-select appropriate labels based on changes"

# Auto-selection via pattern matching (max 3)
# - Documentation: *.md, docs/ → documentation|docs
# - Tests: test, spec → test|testing
# - Bug fixes: fix|bug → bug|fix
# - New features: feat|feature → feature|enhancement
```

**Step 4: PR Creation via GitHub API (Preserve HTML Comments)**

```bash
# Create PR
"Create a Draft PR with the following information:
- Title: Auto-generated from commit message
- Description: Properly filled using .github/PULL_REQUEST_TEMPLATE.md
- Labels: Auto-selected based on changes (max 3)
- Base branch: main
- Fully preserve HTML comments"
```

**Method B: GitHub MCP (Fallback)**

```javascript
// PR creation with HTML comment preservation
mcp_github_create_pull_request({
  owner: 'organization',
  repo: 'repository',
  base: 'main',
  head: 'feat-user-authentication',
  title: 'feat: Implement user authentication',
  body: prBodyContent, // Complete content including HTML comments
  draft: true,
  maintainer_can_modify: true,
});
```

### Automatic Label Selection System

#### File Pattern-Based Detection

- **Documentation**: `*.md`, `README`, `docs/` → `documentation|docs|doc`
- **Tests**: `test`, `spec` → `test|testing`
- **CI/CD**: `.github/`, `*.yml`, `Dockerfile` → `ci|build|infra|ops`
- **Dependencies**: `package.json`, `pubspec.yaml` → `dependencies|deps`

#### Change Content-Based Detection

- **Bug fixes**: `fix|bug|error|crash` → `bug|fix`
- **New features**: `feat|feature|add|implement` → `feature|enhancement|feat`
- **Refactoring**: `refactor|clean` → `refactor|cleanup|clean`
- **Performance**: `performance|perf|optimize` → `performance|perf`
- **Security**: `security|secure` → `security`

#### Constraints

- **Maximum 3**: Upper limit for auto-selection
- **Existing labels only**: No creation of new labels
- **Partial match**: Detection by keyword inclusion

### Project Guidelines

#### Basic Principles

1. **Always start with Draft**: All PRs are created in Draft state
2. **Gradual quality improvement**: Phase 1 (basic implementation) → Phase 2 (add tests) → Phase 3 (update documentation)
3. **Appropriate labels**: Always apply up to 3 types of labels
4. **Use template**: Always use `.github/PULL_REQUEST_TEMPLATE.md`
5. **Spacing convention**: Always add single-byte space between Japanese and alphanumeric characters

#### Branch Naming Convention

```text
{type}-{subject}

Examples:
- feat-user-profile
- fix-login-error
- refactor-api-client
```

#### Commit Message

```text
{type}: {description}

Examples:
- feat: Implement user authentication API
- fix: Fix login error
- docs: Update README
```

### Template Processing System

#### Processing Priority

1. **Existing PR description**: **Completely follow** already written content
2. **Project template**: Maintain `.github/PULL_REQUEST_TEMPLATE.md` structure
3. **Default template**: When above don't exist

#### Existing Content Preservation Rules

- **Don't change a single character**: Already written content
- **Complete only empty sections**: Fill placeholder parts with change content
- **Preserve functional comments**: Maintain `<!-- Copilot review rule -->` etc.
- **Preserve HTML comments**: Fully preserve `<!-- ... -->`
- **Preserve dividers**: Maintain structures like `---`

#### Handling HTML Comment Preservation

**Important**: GitHub CLI (`gh pr edit`) automatically escapes HTML comments, and shell processing may introduce invalid strings like `EOF < /dev/null`.

**Fundamental Solutions**:

1. **Use GitHub API --field option**: Preserve HTML comments with proper escaping
2. **Simplify template processing**: Avoid complex pipe processing and redirects
3. **Complete preservation approach**: Abolish HTML comment removal and fully preserve templates

### Review Comment Response

```bash
# Re-commit after changes
git add .
git commit -m "fix: Corrections based on review feedback"
git push
```

### Important Notes

#### Importance of HTML Comment Preservation

- **GitHub CLI limitations**: `gh pr edit` escapes HTML comments, introduces invalid strings
- **Fundamental workaround**: Use GitHub API `--field` option for proper escaping
- **Complete template preservation**: Abolish HTML comment removal, fully maintain structure

#### Automation Constraints

- **No new labels**: Cannot create labels outside `.github/labels.yml` definitions
- **Maximum 3 labels**: Upper limit for auto-selection
- **Existing content priority**: Never change manually written content

#### Gradual Quality Improvement

- **Draft required**: All PRs start as Draft
- **CI check**: Check status with `gh pr checks`
- **Ready transition**: `gh pr ready` after quality confirmation
- **Complete template compliance**: Maintain project-specific structure
