## PR Review

Ensure code quality and architecture health through systematic Pull Request reviews.

### Usage

```bash
# Comprehensive PR review
gh pr view 123 --comments
"Please systematically review this PR from code quality, security, and architecture perspectives"

# Security-focused review
gh pr diff 123
"Please review focusing on security risks and vulnerabilities"

# Architecture perspective review
gh pr checkout 123 && find . -name "*.js" | head -10
"Please evaluate architecture from layer separation, dependencies, and SOLID principles perspectives"
```

### Basic Examples

```bash
# Numerical code quality evaluation
find . -name "*.js" -exec wc -l {} + | sort -rn | head -5
"Evaluate code complexity, function size, and duplication to identify improvements"

# Security vulnerability check
grep -r "password\|secret\|token" . --include="*.js" | head -10
"Check for risks of sensitive information leakage, hardcoding, and authentication bypass"

# Architecture violation detection
grep -r "import.*from.*\\.\\./\\.\\." . --include="*.js"
"Evaluate layer violations, circular dependencies, and coupling issues"
```

### Comment Classification System

```
🔴 critical.must: Critical issues
├─ Security vulnerabilities
├─ Data integrity issues
└─ System failure risks

🟡 high.imo: High priority improvements
├─ Malfunction risks
├─ Performance issues
└─ Significant maintainability decrease

🟢 medium.imo: Medium priority improvements
├─ Readability improvements
├─ Code structure improvements
└─ Test quality improvements

🟢 low.nits: Minor suggestions
├─ Style consistency
├─ Typo fixes
└─ Comment additions

🔵 info.q: Questions/Information
├─ Implementation intent confirmation
├─ Design decision background
└─ Best practice sharing
```

### Review Perspectives

#### 1. Code Correctness

- **Logic errors**: Boundary values, null checks, exception handling
- **Data integrity**: Type safety, validation
- **Error handling**: Comprehensiveness, appropriate handling

#### 2. Security

- **Authentication/Authorization**: Proper checks, permission management
- **Input validation**: SQL injection, XSS protection
- **Sensitive information**: No logging, encryption

#### 3. Performance

- **Algorithms**: Time complexity, memory efficiency
- **Database**: N+1 queries, index optimization
- **Resources**: Memory leaks, cache utilization

#### 4. Architecture

- **Layer separation**: Dependency direction, appropriate separation
- **Coupling**: Loose coupling, interface utilization
- **SOLID principles**: Single responsibility, open-closed, dependency inversion

### Review Flow

1. **Pre-check**: PR information, change diff, related issues
2. **Systematic check**: Security → Correctness → Performance → Architecture
3. **Constructive feedback**: Specific improvement suggestions with code examples
4. **Follow-up**: Fix verification, CI status, final approval

### Effective Comment Examples

**Security Issue**

```markdown
**critical.must.** Password is stored in plain text

```javascript
// Fix suggestion
const bcrypt = require('bcrypt');
const hashedPassword = await bcrypt.hash(password, 12);
```

Hashing is required to prevent security risks.

```

**Performance Improvement**
```markdown
**high.imo.** N+1 query problem will occur

```javascript
// Improvement: Eager Loading
const users = await User.findAll({ include: [Post] });
```

This significantly reduces the number of queries.

```

**Architecture Violation**
```markdown
**high.must.** Layer violation detected

Domain layer directly depends on infrastructure layer.
Please introduce interfaces following the dependency inversion principle.
```

### Important Notes

- **Constructive tone**: Collaborative rather than aggressive communication
- **Specific suggestions**: Provide solutions, not just problem identification
- **Prioritization**: Address in order Critical → High → Medium → Low
- **Continuous improvement**: Convert review results to knowledge base
