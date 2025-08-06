## PR Feedback

Efficiently handle Pull Request review comments and achieve root cause resolution through a 3-stage error analysis approach.

### Usage

```bash
# Get and analyze review comments
gh pr view --comments
"Please classify review comments by priority and create an action plan"

# Detailed analysis of error-related comments
gh pr checks
"Analyze CI errors with a 3-stage approach and identify root causes"

# Quality check after fix completion
npm test && npm run lint
"Check regression tests and code quality as fixes are complete"
```

### Basic Examples

```bash
# Execute comment classification
gh pr view 123 --comments | head -20
"Classify review comments into must/imo/nits/q and determine response order"

# Collect error information
npm run build 2>&1 | tee error.log
"Identify the root cause of build errors and suggest appropriate fixes"

# Verify fix implementation
git diff HEAD~1
"Evaluate if this fix appropriately resolves the review issues"
```

### Comment Classification System

```
🔴 must: Required fixes
├─ Security issues
├─ Functional bugs
├─ Design principle violations
└─ Convention violations

🟡 imo: Improvement suggestions
├─ Better implementation methods
├─ Performance improvements
├─ Readability improvements
└─ Refactoring suggestions

🟢 nits: Minor suggestions
├─ Typo fixes
├─ Indentation adjustments
├─ Comment additions
└─ Naming fine-tuning

🔵 q: Questions/Confirmations
├─ Implementation intent confirmation
├─ Specification clarification
├─ Design decision background
└─ Alternative considerations
```

### 3-Stage Error Analysis Approach

#### Stage 1: Information Collection

**Required execution**

- Complete error message capture
- Stack trace verification
- Reproduction condition identification

**Recommended execution**

- Environment information collection
- Recent change history
- Related log verification

#### Stage 2: Root Cause Analysis

- Apply 5 Whys analysis
- Dependency tracking
- Environment difference verification
- Minimal reproduction code creation

#### Stage 3: Solution Implementation

- Immediate response (hotfix)
- Fundamental solution (essential fix)
- Preventive measures (recurrence prevention)

### Response Flow

1. **Comment analysis**: Priority classification
2. **Fix planning**: Determine response order
3. **Incremental fixes**: Critical → High → Medium → Low
4. **Quality verification**: Test, lint, build
5. **Progress reporting**: Explain specific fix details

### Post-Fix Verification

```bash
# Basic checks
npm test
npm run lint
npm run build

# Regression tests
npm run test:e2e

# Code quality
npm run test:coverage
```

### Reply Templates

**Fix Completion Report**

```markdown
@reviewer Thank you for your feedback.
Fixes completed:

- [Specific fix details]
- [Test results]
- [Verification method]
```

**Technical Decision Explanation**

```markdown
Implementation background: [Reason]
Alternatives considered: [Options and rationale]
Advantages of chosen approach: [Benefits]
```

### Important Notes

- **Priority compliance**: Address in order Critical → High → Medium → Low
- **Test first**: Verify regression tests before fixes
- **Clear reporting**: Specifically describe fix details and verification methods
- **Constructive dialogue**: Polite communication based on technical rationale
