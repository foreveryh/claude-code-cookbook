## Multi Role

Command to analyze the same target in parallel with multiple roles and generate an integrated report.

### Usage

```bash
/multi-role <role1>,<role2> [--agent|-a] [analysis_target]
/multi-role <role1>,<role2>,<role3> [--agent|-a] [analysis_target]
```

**Important**:

- Place the `--agent` option immediately after the role specification
- Write messages after `--agent`
- Correct example: `/multi-role qa,architect --agent Evaluate the plan`
- Wrong example: `/multi-role qa,architect Evaluate the plan --agent`

### Options

- `--agent` or `-a` : Execute each role in parallel as sub-agents (recommended for large-scale analysis)
  - When using this option, if each role's description contains automatic delegation promotion phrases (like "use PROACTIVELY"), more aggressive automatic delegation will be enabled

### Basic Examples

```bash
# Security and performance dual analysis (normal)
/multi-role security,performance
"Evaluate this API endpoint"

# Parallel analysis of large-scale system (sub-agent)
/multi-role security,performance --agent
"Comprehensively analyze system-wide security and performance"

# Integrated analysis of frontend, mobile, and performance
/multi-role frontend,mobile,performance
"Consider optimization proposals for this screen"

# Multi-perspective evaluation of architecture design (sub-agent)
/multi-role architect,security,performance --agent
"Evaluate the microservices design"
```

### Analysis Process

### Phase 1: Parallel Analysis

Each role independently analyzes the same target

- Execute evaluation from specialized perspectives
- Judge based on role-specific criteria
- Generate independent recommendations

### Phase 2: Integration Analysis

Structure and integrate results

- Organize evaluation results from each role
- Identify overlaps and contradictions
- Clarify complementary relationships

### Phase 3: Integrated Report

Generate final recommendations

- Priority-based action plan
- Explicit trade-offs
- Implementation roadmap presentation

### Output Format Examples

### For 2-Role Analysis

```
Multi-Role Analysis: Security + Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analysis Target: API endpoint /api/users

Security Analysis Results:
Authentication: JWT validation properly implemented
Authorization: Role-based access control incomplete
Encryption: API keys logged in plaintext

Evaluation Score: 65/100
Importance: High (due to sensitive data access)

Performance Analysis Results:
Response Time: Average 180ms (target within 200ms)
Database Queries: N+1 problem detected
Cache: Redis cache not implemented

Evaluation Score: 70/100
Importance: Medium (currently within acceptable range)

Cross-Correlation Analysis:
Synergy Opportunities:
- Consider encryption when implementing Redis cache
- Improve security + performance by improving log output

Trade-off Points:
- Enhanced authorization checks ↔ Impact on response time
- Log encryption ↔ Reduced debugging efficiency

Integrated Priority:
Critical: Fix API key plaintext output
High: Resolve N+1 queries
Medium: Implement Redis cache + encryption
Low: Refine authorization control

Implementation Roadmap:
Week 1: Implement API key masking
Week 2: Optimize database queries
Week 3-4: Design and implement cache layer
Month 2: Gradually strengthen authorization control
```

### For 3-Role Analysis

```
Multi-Role Analysis: Frontend + Mobile + Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analysis Target: User Profile Screen

Frontend Analysis Results:
Usability: Intuitive layout
Accessibility: 85% WCAG 2.1 compliance
Responsive: Issues with tablet display

Mobile Analysis Results:
Touch Targets: 44pt minimum ensured
One-handed Operation: Important buttons placed at top
Offline Support: Not implemented

Performance Analysis Results:
Initial Display: LCP 2.1 seconds (good)
Image Optimization: WebP not supported
Lazy Loading: Not implemented

Integrated Recommendations:
1. Mobile optimization (one-handed operation + offline support)
2. Image optimization (WebP + lazy loading)
3. Improve tablet UI

Priority: Mobile > Performance > Frontend
Implementation Period: 3-4 weeks
```

### Effective Combination Patterns

### Security Focus

```bash
/multi-role security,architect
"Authentication system design"

/multi-role security,frontend  
"Login screen security"

/multi-role security,mobile
"Mobile app data protection"
```

### Performance Focus

```bash
/multi-role performance,architect
"Scalability design"

/multi-role performance,frontend
"Web page optimization"

/multi-role performance,mobile
"App performance optimization"
```

### User Experience Focus

```bash
/multi-role frontend,mobile
"Cross-platform UI"

/multi-role frontend,performance
"Balance between UX and performance"

/multi-role mobile,performance
"Mobile UX optimization"
```

### Comprehensive Analysis

```bash
/multi-role architect,security,performance
"System-wide evaluation"

/multi-role frontend,mobile,performance
"Comprehensive user experience evaluation"

/multi-role security,performance,mobile
"Comprehensive mobile app diagnosis"
```

### Integration with Claude

```bash
# Combined with file analysis
cat src/components/UserProfile.tsx
/multi-role frontend,mobile
"Evaluate this component from multiple perspectives"

# Design document evaluation
cat architecture-design.md
/multi-role architect,security,performance
"Evaluate this design from multiple specialties"

# Error analysis
cat performance-issues.log
/multi-role performance,analyzer
"Analyze performance issues from multiple angles"
```

### When to Use multi-role vs role-debate

### When to Use multi-role

- Want independent evaluation from each specialty
- Want to create an integrated improvement plan
- Want to organize contradictions and overlaps
- Want to determine implementation priorities

### When to Use role-debate

- There are trade-offs between specialties
- Opinions might differ on technology selection
- Want to decide design policy through discussion
- Want to hear discussions from different perspectives

### Sub-Agent Parallel Execution (--agent)

When using the `--agent` option, each role is executed in parallel as an independent sub-agent.

#### Promotion of Automatic Delegation

When the role file's description field contains phrases like the following, more aggressive automatic delegation is enabled when using `--agent`:

- "use PROACTIVELY"
- "MUST BE USED"
- Other emphasis expressions

#### Execution Flow

```
Normal Execution:
Role 1 → Role 2 → Role 3 → Integration
(Sequential execution, about 3-5 minutes)

--agent Execution:
Role 1 ─┐
Role 2 ─┼→ Integration
Role 3 ─┘
(Parallel execution, about 1-2 minutes)
```

#### Effective Usage Examples

```bash
# Comprehensive evaluation of large-scale system
/multi-role architect,security,performance,qa --agent
"Comprehensive evaluation of new system"

# Detailed analysis from multiple perspectives
/multi-role frontend,mobile,performance --agent
"UX optimization analysis for all screens"
```

#### Performance Comparison

| Number of Roles | Normal Execution | --agent Execution | Reduction Rate |
|-----------------|------------------|-------------------|----------------|
| 2 Roles | 2-3 min | 1 min | 50% |
| 3 Roles | 3-5 min | 1-2 min | 60% |
| 4 Roles | 5-8 min | 2-3 min | 65% |

### Important Notes

- Output becomes longer when executing 3 or more roles simultaneously
- More complex analysis may take longer execution time
- If contradictory recommendations appear, consider role-debate as well
- Final decisions should be made by users referring to integrated results
- **When using --agent**: Uses more resources but is efficient for large-scale analysis
