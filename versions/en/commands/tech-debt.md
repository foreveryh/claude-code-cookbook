## Tech Debt

Analyze project technical debt and create a prioritized improvement plan.

### Usage

```bash
# Analyze project structure to identify technical debt
ls -la
"Analyze this project's technical debt and create an improvement plan"
```

### Basic Examples

```bash
# Analyze TODO/FIXME comments
grep -r "TODO\|FIXME\|HACK\|XXX\|WORKAROUND" . --exclude-dir=node_modules --exclude-dir=.git
"Organize these TODO comments by priority and create an improvement plan"

# Check project dependencies
ls -la | grep -E "package.json|Cargo.toml|pubspec.yaml|go.mod|requirements.txt"
"Analyze project dependencies to identify outdated packages and risks"

# Detect large files or complex functions
find . -type f -not -path "*/\.*" -not -path "*/node_modules/*" -exec wc -l {} + | sort -rn | head -10
"Identify files that are too large or have complex structures and suggest improvements"
```

### Claude Integration

```bash
# Comprehensive technical debt analysis
ls -la && find . -name "*.md" -maxdepth 2 -exec head -20 {} \;
"Analyze this project's technical debt from the following perspectives:
1. Code quality (complexity, duplication, maintainability)
2. Dependency health
3. Security risks
4. Performance issues
5. Test coverage gaps"

# Architecture-level debt analysis
find . -type d -name "src" -o -name "lib" -o -name "app" | head -10 | xargs ls -la
"Identify architecture-level technical debt and propose refactoring plans"

# Prioritized improvement plan
"Evaluate technical debt based on the following criteria and present in table format:
- Impact level (High/Medium/Low)
- Fix cost (time)
- Business risk
- Benefits of improvement
- Recommended timeline"
```

### Advanced Examples

```bash
# Auto-detect project type and analyze
find . -maxdepth 2 -type f \( -name "package.json" -o -name "Cargo.toml" -o -name "pubspec.yaml" -o -name "go.mod" -o -name "pom.xml" \)
"Based on detected project type, analyze:
1. Language/framework-specific technical debt
2. Deviations from best practices
3. Modernization opportunities
4. Phased improvement strategy"

# Code quality metrics analysis
find . -type f -name "*" | grep -E "\.(js|ts|py|rs|go|dart|kotlin|swift|java)$" | wc -l
"Analyze project code quality and provide these metrics:
- Functions with high cyclomatic complexity
- Duplicate code detection
- Files/functions that are too long
- Lack of proper error handling"

# Security debt detection
grep -r "password\|secret\|key\|token" . --exclude-dir=.git --exclude-dir=node_modules | grep -v ".env.example"
"Detect security-related technical debt and propose fixes with priority levels"

# Test coverage gap analysis
find . -type f \( -name "*test*" -o -name "*spec*" \) | wc -l && find . -type f -name "*.md" | xargs grep -l "test"
"Analyze test coverage technical debt and propose testing strategy"
```

### Important Notes

- Automatically detects project language and framework for tailored analysis
- Technical debt is classified into "critical issues requiring immediate attention" and "long-term improvement items"
- Provides realistic plans that balance business value with technical improvement
- Considers ROI (Return on Investment) for improvement initiatives
