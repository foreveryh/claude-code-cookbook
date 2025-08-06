## Smart Review

Analyze the current situation and automatically suggest optimal roles and approaches.

### Usage

```bash
/smart-review                    # Analyze current directory
/smart-review <file/directory>  # Analyze specific target
```

### Automatic Detection Logic

### Detection by File Extension

- `package.json`, `*.tsx`, `*.jsx`, `*.css`, `*.scss` → **frontend**
- `Dockerfile`, `docker-compose.yml`, `*.yaml` → **architect**
- `*.test.js`, `*.spec.ts`, `test/`, `__tests__/` → **qa**
- `*.rs`, `Cargo.toml`, `performance/` → **performance**

### Security-Related File Detection

- `auth.js`, `security.yml`, `.env`, `config/auth/` → **security**
- `login.tsx`, `signup.js`, `jwt.js` → **security + frontend**
- `api/auth/`, `middleware/auth/` → **security + architect**

### Combined Detection Patterns

- `mobile/` + `*.swift`, `*.kt`, `react-native/` → **mobile**
- `webpack.config.js`, `vite.config.js`, `large-dataset/` → **performance**
- `components/` + `responsive.css` → **frontend + mobile**
- `api/` + `auth/` → **security + architect**

### Error/Problem Analysis

- Stack traces, `error.log`, `crash.log` → **analyzer**
- `memory leak`, `high CPU`, `slow query` → **performance + analyzer**
- `SQL injection`, `XSS`, `CSRF` → **security + analyzer**

### Suggestion Patterns

### Single Role Suggestion

```bash
$ /smart-review src/auth/login.js
→ "Authentication file detected"
→ "Recommending security role analysis"
→ "Execute? [y]es / [n]o / [m]ore options"
```

### Multiple Role Suggestion

```bash
$ /smart-review src/mobile/components/
→ "📱🎨 Mobile + Frontend elements detected"
→ "Recommended approaches:"
→ "[1] mobile role only"
→ "[2] frontend role only"  
→ "[3] multi-role mobile,frontend"
→ "[4] role-debate mobile,frontend"
```

### Problem Analysis Suggestions

```bash
$ /smart-review error.log
→ "⚠️ Error log detected"
→ "Starting root cause analysis with analyzer role"
→ "[Auto-executing] /role analyzer"

$ /smart-review slow-api.log
→ "🐌 Performance issue detected"
→ "Recommended: [1]/role performance [2]/role-debate performance,analyzer"
```

### Complex Design Decision Suggestions

```bash
$ /smart-review architecture-design.md
→ "🏗️🔒⚡ Architecture + Security + Performance elements detected"
→ "Complex design decision, recommending discussion format"
→ "[Recommended] /role-debate architect,security,performance"
→ "[Alternative] /multi-role architect,security,performance"
```

### Detailed Suggestion Logic

### Priority Determination

1. **Security** - Authentication/authorization/encryption takes priority
2. **Critical Errors** - System crashes/data loss are urgent
3. **Architecture** - Large-scale changes/tech selection needs careful consideration
4. **Performance** - Directly impacts user experience
5. **Frontend/Mobile** - UI/UX improvements
6. **QA** - Quality assurance/testing related

### Discussion Recommendation Conditions

- When 3+ roles are involved
- When there's a security vs performance tradeoff
- When major architecture changes are involved
- When both mobile + web are affected

### Basic Examples

```bash
# Analyze current directory
/smart-review
"Suggest optimal roles and approaches"

# Analyze specific file
/smart-review src/auth/login.js
"Suggest the best review method for this file"

# Analyze error log
/smart-review error.log
"Suggest the best approach to resolve this error"
```

### Practical Examples

### Full Project Analysis

```bash
$ /smart-review
→ "📊 Analyzing project..."
→ "React + TypeScript project detected"
→ "Authentication + API + Mobile support confirmed"
→ ""
→ "💡 Recommended workflow:"
→ "1. security for auth system check"
→ "2. frontend for UI/UX evaluation"
→ "3. mobile for mobile optimization"
→ "4. architect for overall design review"
→ ""
→ "Auto-execute? [y]es / [s]elect role / [c]ustom"
```

### Specific Problem Analysis

```bash
$ /smart-review "How should we set JWT expiration?"
→ "🤔 Technical design decision detected"
→ "This problem requires multiple expert perspectives"
→ ""
→ "Recommended approach:"
→ "/role-debate security,performance,frontend"
→ "Reason: Balance between security, performance, and UX is critical"
```

### Integration with Claude

```bash
# Analysis combined with file content
cat src/auth/middleware.js
/smart-review
"Analyze this file content from a security perspective"

# Analysis combined with errors
npm run build 2>&1 | tee build-error.log
/smart-review build-error.log
"Suggest solutions for build errors"

# Design consultation
/smart-review
"Debate whether to choose React Native or Progressive Web App"
```

### Important Notes

- Suggestions are for reference. Final decisions should be made by users
- More complex problems warrant discussion format (role-debate)
- Simple problems often need only a single role
- Security-related issues always warrant specialist role review
