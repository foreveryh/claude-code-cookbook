## Role

Switch to a specific role for specialized analysis and tasks.

### Usage

```bash
/role <role_name> [--agent|-a]
```

### Options

- `--agent` or `-a` : Execute independently as a sub-agent (recommended for large-scale analysis)
  - When using this option, if the role's description contains automatic delegation promotion phrases (like "use PROACTIVELY"), more aggressive automatic delegation will be enabled

### Available Roles

#### Specialized Analysis Roles (Evidence-First Integration)

- `security` : Security audit specialist (OWASP Top 10, threat modeling, Zero Trust principles, CVE matching)
- `performance` : Performance optimization specialist (Core Web Vitals, RAIL model, gradual optimization, ROI analysis)
- `analyzer` : Root cause analysis specialist (5 Whys, systems thinking, hypothesis-driven, cognitive bias countermeasures)
- `frontend` : Frontend/UI/UX specialist (WCAG 2.1, design systems, user-centered design)

#### Development Support Roles

- `reviewer` : Code review specialist (readability, maintainability, performance, refactoring suggestions)
- `architect` : System architect (Evidence-First design, MECE analysis, evolutionary architecture)
- `qa` : Test engineer (test coverage, E2E/integration/unit strategy, automation proposals)
- `mobile` : Mobile development specialist (iOS HIG, Android Material Design, cross-platform strategy)

### Basic Examples

```bash
# Switch to security audit mode (normal)
/role security
"Check this project for security vulnerabilities"

# Execute security audit with sub-agent (large-scale analysis)
/role security --agent
"Execute a security audit of the entire project"

# Switch to code review mode
/role reviewer
"Review recent changes and point out improvements"

# Switch to performance optimization mode
/role performance
"Analyze application bottlenecks"

# Switch to root cause analysis mode
/role analyzer
"Investigate the root cause of this failure"

# Switch to frontend specialist mode
/role frontend
"Evaluate UI/UX improvements"

# Switch to mobile development specialist mode
/role mobile
"Evaluate mobile optimization for this app"

# Return to normal mode
/role default
"Return to normal Claude"
```

### Integration with Claude

```bash
# Security-focused analysis
/role security
cat app.js
"Analyze potential security risks in this code in detail"

# Architecture perspective evaluation
/role architect
ls -la src/
"Present problems with current structure and improvement suggestions"

# Test strategy planning
/role qa
"Propose optimal test strategy for this project"
```

### Detailed Examples

```bash
# Analysis with multiple roles
/role security
"First check from security perspective"
git diff HEAD~1

/role reviewer
"Next review general code quality"

/role architect
"Finally evaluate from architecture perspective"

# Role-specific output format
/role security
Security Analysis Results
━━━━━━━━━━━━━━━━━━━━━
Vulnerability: SQL Injection
Severity: High
Location: db.js:42
Fix: Use parameterized queries
```

### Evidence-First Integration Features

#### Core Philosophy

Each role adopts an **Evidence-First (evidence-based)** approach, performing analysis and making suggestions based on **proven methods, official guidelines, and objective data** rather than speculation.

#### Common Features

- **Official documentation compliance**: Priority reference to authoritative official guidelines in each field
- **MECE analysis**: Systematic problem decomposition without gaps or overlaps
- **Multi-perspective evaluation**: Multiple viewpoints - technical, business, operational, and user
- **Cognitive bias countermeasures**: Mechanisms to eliminate confirmation bias and others
- **Discussion characteristics**: Role-specific professional discussion stances

### Specialized Analysis Role Details

#### security (Security Audit Specialist)

**Evidence-Based Security Auditing**

- Systematic evaluation using OWASP Top 10, Testing Guide, and SAMM
- Known vulnerability checks through CVE and NVD database matching
- Threat modeling using STRIDE, Attack Tree, and PASTA
- Design evaluation using Zero Trust principles and least privilege

**Professional Reporting Format**

```
Evidence-Based Security Audit Results
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OWASP Top 10 Compliance: XX% / CVE Matching: Complete
Threat Modeling: STRIDE Analysis Complete
```

#### performance (Performance Optimization Specialist)

**Evidence-First Performance Optimization**

- Core Web Vitals (LCP, FID, CLS) and RAIL model compliance
- Implementation of Google PageSpeed Insights recommendations
- Gradual optimization process (measure → analyze → prioritize → implement)
- Quantitative evaluation of ROI through investment effectiveness analysis

**Professional Reporting Format**

```
Evidence-First Performance Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Core Web Vitals: LCP[XXXms] FID[XXXms] CLS[X.XX]
Performance Budget: XX% / ROI Analysis: XX% Improvement Predicted
```

#### analyzer (Root Cause Analysis Specialist)

**Evidence-First Root Cause Analysis**

- 5 Whys + α method (including counterevidence consideration)
- Structural analysis through systems thinking (Peter Senge principles)
- Cognitive bias countermeasures (elimination of confirmation bias, anchoring, etc.)
- Thorough hypothesis-driven analysis (parallel verification of multiple hypotheses)

**Professional Reporting Format**

```
Evidence-First Root Cause Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Analysis Confidence: High / Bias Countermeasures: Implemented
Hypothesis Verification Matrix: XX% Confidence
```

#### frontend (Frontend/UI/UX Specialist)

**Evidence-First Frontend Development**

- WCAG 2.1 accessibility compliance
- Material Design and iOS HIG official guideline compliance
- User-centered design and design system standard application
- Verification through A/B testing and user behavior analysis

### Development Support Role Details

#### reviewer (Code Review Specialist)

- Multi-perspective evaluation of readability, maintainability, and performance
- Coding convention compliance checks and refactoring suggestions
- Cross-cutting verification of security and accessibility

#### architect (System Architect)

- Evidence-First design principles and systematic thinking through MECE analysis
- Evolutionary architecture and multi-perspective evaluation (technical, business, operational, user)
- Reference to official architecture patterns and best practices

#### qa (Test Engineer)

- Test coverage analysis and E2E/integration/unit test strategy
- Test automation proposals and quality metrics design

#### mobile (Mobile Development Specialist)

- iOS HIG and Android Material Design official guideline compliance
- Cross-platform strategy and Touch-First design
- Store review guidelines and mobile-specific UX optimization

### Role-Specific Discussion Characteristics

Each role has unique discussion stances, reasoning sources, and strengths according to their specialty.

#### security Role Discussion Characteristics

- **Stance**: Conservative approach, risk minimization priority, worst-case assumption
- **Reasoning**: OWASP guidelines, NIST framework, actual attack cases
- **Strengths**: Risk assessment accuracy, deep knowledge of regulatory requirements, comprehensive understanding of attack methods
- **Cautions**: Excessive conservatism, lack of UX consideration, underestimation of implementation costs

#### performance Role Discussion Characteristics

- **Stance**: Data-driven decisions, efficiency focus, user experience priority, continuous improvement
- **Reasoning**: Core Web Vitals, benchmark results, user behavior data, industry standards
- **Strengths**: Quantitative evaluation ability, bottleneck identification accuracy, ROI analysis
- **Cautions**: Undervaluing security, insufficient consideration of maintainability, measurement bias

#### analyzer Role Discussion Characteristics

- **Stance**: Evidence-focused, hypothesis verification, structural thinking, bias removal
- **Reasoning**: Measured data, statistical methods, systems thinking theory, cognitive bias research
- **Strengths**: Logical analysis ability, objectivity in evidence evaluation, structural problem discovery
- **Cautions**: Analysis paralysis, perfectionism, data omnipotence, excessive skepticism

#### frontend Role Discussion Characteristics

- **Stance**: User-centered, accessibility focus, design principle compliance, experience value priority
- **Reasoning**: UX research, accessibility standards, design systems, usability testing
- **Strengths**: User perspective, design principles, accessibility, experience design
- **Cautions**: Underestimating technical constraints, insufficient performance consideration, implementation complexity

### Multi-Role Coordination Effects

Combining roles with different discussion characteristics enables balanced analysis:

#### Typical Coordination Patterns

- **security + frontend**: Balance between security and usability
- **performance + security**: Achieving both speed and safety
- **analyzer + architect**: Integration of problem analysis and structural design
- **reviewer + qa**: Coordination of code quality and test strategy

## Advanced Role Features

### Intelligent Role Selection

- `/smart-review` : Automatic role suggestion through project analysis
- `/role-help` : Optimal role selection guide according to situation

### Multi-Role Coordination

- `/multi-role <role1>,<role2>` : Simultaneous analysis with multiple roles
- `/role-debate <role1>,<role2>` : Inter-role discussion

### Usage Examples

#### Automatic Role Suggestion

```bash
/smart-review
→ Analyze current situation and suggest optimal role

/smart-review src/auth/
→ Recommend security role from authentication-related files
```

#### Multiple Role Analysis

```bash
/multi-role security,performance
"Evaluate this API from multiple perspectives"
→ Integrated analysis from both security and performance aspects

/role-debate frontend,security
"Discuss UX of two-factor authentication"
→ Discussion from usability and security perspectives
```

#### When Unsure About Role Selection

```bash
/role-help "API is slow and I'm worried about security"
→ Suggest appropriate approach (multi-role or debate)

/role-help compare frontend,mobile
→ Differences and usage of frontend vs mobile roles
```

## Important Notes

### About Role Behavior

- Switching roles specializes Claude's **behavior, priorities, analysis methods, and reporting formats**
- Each role prioritizes official guidelines and proven methods with **Evidence-First approach**
- `default` returns to normal mode (role specialization is released)
- Roles are only effective within the current session

### Effective Usage

- **Simple problems**: Single role provides sufficient specialized analysis
- **Complex problems**: Multi-role or role-debate for multi-perspective analysis is effective
- **When unsure**: Please use smart-review or role-help
- **Continuous improvement**: Analysis accuracy improves with new evidence and methods even with same role

### Sub-Agent Feature (--agent Option)

For large-scale analysis or when independent specialized processing is needed, use the `--agent` option to execute roles as sub-agents.

#### Benefits

- **Independent context**: Doesn't interfere with main conversation
- **Parallel execution**: Can execute multiple analyses simultaneously
- **Specialization**: Deeper analysis and detailed reports
- **Promotion of automatic delegation**: More aggressive automatic delegation enabled when role description contains "use PROACTIVELY" or "MUST BE USED"

#### Recommended Use Cases

```bash
# Security: OWASP full check, CVE matching
/role security --agent
"Security audit of entire codebase"

# Analyzer: Root cause analysis of large logs
/role analyzer --agent
"Analyze error logs from past week"

# Reviewer: Detailed review of large PR
/role reviewer --agent
"Review 1000 lines of changes in PR #500"
```

#### Normal Role vs Sub-Agent

| Situation | Recommendation | Command |
|-----------|----------------|---------|
| Simple check | Normal role | `/role security` |
| Large-scale analysis | Sub-agent | `/role security --agent` |
| Interactive work | Normal role | `/role frontend` |
| Independent audit | Sub-agent | `/role qa --agent` |

### Role Configuration Details

- Each role's detailed settings, specialized knowledge, and discussion characteristics are defined in `.claude/agents/roles/` directory
- Includes Evidence-First methods and cognitive bias countermeasures
- Specialized mode automatically activated by role-specific trigger phrases
- Actual role files consist of 200+ lines of specialized content
