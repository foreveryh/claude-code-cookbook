## Error Fix

Identify root causes from error messages and propose proven solutions.

### Usage

```bash
/fix-error [options]
```

### Options

- None: Standard error analysis
- `--deep`: Deep analysis mode (including dependencies and environmental factors)
- `--preventive`: Focus on preventive measures
- `--quick`: Show only immediately applicable fixes

### Basic Examples

```bash
# Standard error analysis
npm run build 2>&1
/fix-error
"Analyze the build error and suggest fixes"

# Deep analysis mode
python app.py 2>&1
/fix-error --deep
"Analyze the root cause including environmental factors"

# Quick fix focus
cargo test 2>&1
/fix-error --quick
"Provide immediately applicable fixes"

# Prevention focus
./app 2>&1 | tail -50
/fix-error --preventive
"Provide error fixes and future prevention strategies"
```

### Integration with Claude

```bash
# Error log analysis
cat error.log
/fix-error
"Identify root causes and suggest solutions"

# Test failure resolution
npm test 2>&1
/fix-error --quick
"Analyze failed tests and provide immediate fixes"

# Stack trace analysis
python script.py 2>&1
/fix-error --deep
"Identify problem areas from this stack trace including environmental factors"

# Multiple error resolution
grep -E "ERROR|WARN" app.log | tail -20
/fix-error
"Classify these errors and warnings by priority and suggest solutions for each"
```

### Error Analysis Priority

#### 🔴 Urgency: High (Immediate action required)

- **Application crashes**: Crashes, infinite loops, deadlocks
- **Data loss risk**: Database errors, file corruption
- **Security vulnerabilities**: Authentication failures, permission errors, injections
- **Production impact**: Deployment failures, service outages

#### 🟡 Urgency: Medium (Early action recommended)

- **Performance issues**: Memory leaks, latency, timeouts
- **Partial malfunction**: Specific feature errors, UI glitches
- **Development efficiency**: Build errors, test failures

#### 🟢 Urgency: Low (Planned action)

- **Warning messages**: Deprecation, lint errors
- **Development environment only**: Local environment issues
- **Future risks**: Technical debt, maintainability issues

### Analysis Process

#### Phase 1: Error Information Collection

```bash
🔴 Required:
- Complete error message capture
- Stack trace verification
- Occurrence conditions (reproducibility)

🟡 Early collection:
- Environment info (OS, versions, dependencies)
- Recent change history (git log, recent commits)
- Related log verification

🟢 Additional:
- System resource status
- Network state
- External service status
```

#### Phase 2: Root Cause Analysis

1. **Surface symptom organization**
   - Exact error message content
   - Occurrence timing and patterns
   - Impact scope identification

2. **Deep cause identification**
   - 5 Whys analysis application
   - Dependency tracking
   - Environment difference verification

3. **Hypothesis verification**
   - Minimal reproduction code creation
   - Isolation test execution
   - Cause narrowing

#### Phase 3: Solution Implementation

```bash
🔴 Immediate response (hotfix):
- Minimal fix to suppress symptoms
- Temporary workaround application
- Emergency deployment preparation

🟡 Fundamental solution:
- Essential fix for the cause
- Test case addition
- Documentation update

🟢 Preventive measures:
- Error handling enhancement
- Monitoring/alert setup
- CI/CD pipeline improvement
```

### Output Example

```
🚨 Error Analysis Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 Error Overview
├─ Type: [Compile/Runtime/Logic/Environment]
├─ Urgency: 🔴 High / 🟡 Medium / 🟢 Low
├─ Impact: [Feature/Component name]
└─ Reproducibility: [100% / Intermittent / Specific conditions]

🔍 Root Cause
├─ Direct cause: [Specific cause]
├─ Background factors: [Environment/Config/Dependencies]
└─ Trigger: [Occurrence conditions]

💡 Solutions
🔴 Immediate action:
1. [Specific fix command/code]
2. [Temporary workaround]

🟡 Fundamental fix:
1. [Essential fix method]
2. [Required refactoring]

🟢 Prevention:
1. [Error handling improvement]
2. [Test addition]
3. [Monitoring setup]

📝 Verification Steps
1. [Post-fix verification method]
2. [Test execution command]
3. [Operation check items]
```

### Error Type-Specific Analysis Methods

#### Compile/Build Errors

```bash
# TypeScript type errors
Required checks (High):
- tsconfig.json settings
- Type definition files (.d.ts) existence
- Import statement accuracy

# Rust lifetime errors
Required checks (High):
- Ownership transfers
- Reference lifetimes
- Mutability conflicts
```

#### Runtime Errors

```bash
# Null/Undefined references
Required checks (High):
- Missing optional chaining
- Initialization timing
- Async operation completion

# Memory-related errors
Required checks (High):
- Heap dump acquisition
- GC log analysis
- Circular reference detection
```

#### Dependency Errors

```bash
# Version conflicts
Required checks (High):
- Lock file integrity
- Peer dependency requirements
- Transitive dependencies

# Module resolution errors
Required checks (High):
- NODE_PATH settings
- Path alias configuration
- Symbolic links
```

### Important Notes

- **Absolutely forbidden**: Judging based on partial error messages, applying Stack Overflow solutions without verification
- **Exception conditions**: Temporary workarounds allowed only under these 3 conditions:
  1. Production emergency response (fundamental fix required within 24 hours)
  2. External service failure (alternative during recovery wait)
  3. Known framework bugs (waiting for fix release)
- **Recommendation**: Prioritize root cause identification, avoid superficial fixes

### Best Practices

1. **Complete information gathering**: Check error messages from start to end
2. **Reproducibility confirmation**: Prioritize minimal reproduction code creation
3. **Incremental approach**: Start with small fixes and verify
4. **Documentation**: Record solution process for knowledge sharing

#### Common Pitfalls

- **Symptom treatment**: Superficial fixes that miss root causes
- **Over-generalization**: Applying specific case solutions broadly
- **Skipping verification**: Not checking side effects after fixes
- **Knowledge silos**: Not documenting solutions

### Related Commands

- `/design-patterns`: Analyze code structure issues and suggest patterns
- `/tech-debt`: Analyze error root causes from technical debt perspective
- `/analyzer`: When deeper root cause analysis is needed
