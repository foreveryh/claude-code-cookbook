## Role Debate

Command for roles with different expertise to debate, consider trade-offs, and derive optimal solutions.

### Usage

```bash
/role-debate <role1>,<role2> [topic]
/role-debate <role1>,<role2>,<role3> [topic]
```

### Basic Examples

```bash
# Security vs Performance trade-offs
/role-debate security,performance
"About JWT token expiration settings"

# Usability vs Security balance
/role-debate frontend,security
"About 2FA UX optimization"

# Technology selection debate
/role-debate architect,mobile
"About choosing React Native vs Flutter"

# Three-party debate
/role-debate architect,security,performance
"About microservices adoption"
```

### Basic Principles of Debate

#### Constructive Debate Guidelines

- **Mutual Respect**: Respect other roles' expertise and perspectives
- **Fact-Based**: Data and evidence-based arguments, not emotional responses
- **Solution-Oriented**: Aim for better solutions, not criticism for its own sake
- **Implementation-Focused**: Consider feasibility, not just ideals

#### Quality Requirements for Arguments

- **Official Documentation**: Reference to standards, guidelines, and official docs
- **Proven Cases**: Specific citations of success and failure cases
- **Quantitative Evaluation**: Comparison with metrics and indicators when possible
- **Time Consideration**: Short-term, medium-term, and long-term impact evaluation

#### Debate Ethics

- **Integrity**: Acknowledge limitations of own expertise
- **Openness**: Flexibility toward new information and perspectives
- **Transparency**: Clear statement of judgment basis and assumptions
- **Responsibility**: Include implementation risks in proposals

### Debate Process

### Phase 1: Initial Position Statement

Each role independently states opinions from their expertise

- Present recommendations
- Specify standards and documentation as basis
- Explain expected risks and challenges
- Define success metrics

### Phase 2: Cross-Debate and Rebuttal

Cross-discussion between roles

- Constructive counter-arguments to other roles' proposals
- Point out overlooked perspectives
- Clarify trade-offs
- Present alternatives

### Phase 3: Compromise Exploration

Seek implementable solutions

- Evaluate importance of each perspective
- Consider win-win solutions
- Phased implementation approach
- Risk mitigation strategies

### Phase 4: Integrated Conclusion

Determine final recommendations

- Agreed solution
- Implementation roadmap
- Success metrics and measurement methods
- Future review points

### Output Format Examples

### For 2-Role Debate

```
Role Debate: Security vs Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: JWT Token Expiration Settings

Security Role's Position:
"Recommend 15-minute short expiration"

Rationale:
- OWASP JWT Security Cheat Sheet compliance
- Minimize damage window on token leak
- Limit attacker's usable time

Concerns:
- Long expiration exponentially increases attack risk
- Short-term required for compliance (financial)

Success Metrics:
- Security incident rate < 0.1%
- Average attack detection time < 5 minutes

Performance Role's Counter:
"Recommend 2-hour expiration"

Rationale:
- Reference Google OAuth 2.0 Best Practices
- Avoid server load increase from frequent re-auth
- Minimize user experience interruption

Concerns:
- 15-minute intervals = 8x API load increase
- Frequent disconnections in mobile environments

Success Metrics:
- API response time < 200ms maintained
- Server CPU usage < 60%

Cross-Discussion:
Security → Performance:
"Business loss from security breach far exceeds server load.
Example: Equifax incident resulted in $700M loss"

Performance → Security:
"Refresh token mechanism enables both.
Background updates ensure security without harming UX"

Security → Performance:
"Refresh tokens are also attack targets. Proper implementation required"

Performance → Security:
"Propose phased approach. 30 min for normal ops, 15 min for sensitive"

Compromise Exploration:
Common Understanding:
- Need both user experience and security
- Flexible response based on risk level
- Realistic consideration of implementation/operation costs

Win-Win Elements:
- Utilize refresh token mechanism
- Phased introduction of risk-based auth
- Complement with auto-logout functionality

Integrated Conclusion:
"30-minute expiration + refresh tokens + risk-based auth"

Implementation Details:
1. Access token: 30-minute expiration
2. Refresh token: 7-day expiration
3. High-risk operations: Force re-auth at 15 minutes
4. Auto-logout after 30 minutes of inactivity

Phased Implementation:
Week 1-2: Basic 30-minute token implementation
Week 3-4: Add refresh token mechanism
Month 2: Introduce risk-based authentication

Success Metrics:
- Security: Incident rate < 0.1%
- Performance: API load increase < 20%
- UX: User satisfaction > 85%

Future Review:
- 3 months: Evaluate actual attack patterns and load
- 6 months: Consider migration to more sophisticated risk-based auth
```

### For 3-Role Debate

```
Role Debate: Architect vs Security vs Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: Microservices Adoption

Architect Role's Position:
"Recommend phased microservices migration"
Rationale: Clear domain boundaries, independent deployment, technology flexibility

Security Role's Concern:
"Service communication security complexity"
Rationale: API Gateway, mTLS, distributed auth management costs

Performance Role's Concern:
"Network communication latency increase"
Rationale: Internal API calls causing N+1 problems, distributed transactions

Three-Party Discussion:
Architect → Security: "Centralized management via API Gateway enables control"
Security → Architect: "Risk of single point of failure"
Performance → Architect: "Service granularity is critical"
...(discussion continues)

Integrated Conclusion:
"Domain-driven phased splitting + security-first design"
```

### Effective Debate Patterns

### Technology Selection

```bash
/role-debate architect,performance
"Database choice: PostgreSQL vs MongoDB"

/role-debate frontend,mobile
"UI framework: React vs Vue"

/role-debate security,architect
"Authentication: JWT vs Session Cookie"
```

### Design Decisions

```bash
/role-debate security,frontend
"User authentication UX design"

/role-debate performance,mobile
"Data sync strategy optimization"

/role-debate architect,qa
"Test strategy and architecture design"
```

### Trade-off Problems

```bash
/role-debate security,performance
"Encryption level vs processing speed"

/role-debate frontend,performance
"Rich UI vs page load speed"

/role-debate mobile,security
"Convenience vs data protection level"
```

### Role-Specific Debate Characteristics

#### 🔒 Security Role

```yaml
Debate Stance:
  - Conservative approach (risk minimization)
  - Rule compliance focus (cautious about deviation)
  - Worst-case assumption (attacker perspective)
  - Long-term impact focus (security as technical debt)

Typical Arguments:
  - "Security vs convenience" trade-offs
  - "Compliance requirements are mandatory"
  - "Attack cost vs defense cost comparison"
  - "Privacy protection thoroughness"

Evidence Sources:
  - OWASP guidelines
  - NIST framework
  - Industry standards (ISO 27001, SOC 2)
  - Actual attack cases and statistics

Debate Strengths:
  - Risk assessment accuracy
  - Regulatory knowledge
  - Attack method understanding

Potential Biases:
  - Excessive conservatism (innovation hindrance)
  - Lack of UX consideration
  - Underestimating implementation costs
```

#### ⚡ Performance Role

```yaml
Debate Stance:
  - Data-driven decisions (measurement-based)
  - Efficiency focus (cost-effectiveness optimization)
  - User experience priority (perceived speed focus)
  - Continuous improvement (phased optimization)

Typical Arguments:
  - "Performance vs security"
  - "Optimization cost vs effect ROI"
  - "Current vs future scalability"
  - "User experience vs system efficiency"

Evidence Sources:
  - Core Web Vitals metrics
  - Benchmark results and statistics
  - User behavior impact data
  - Industry performance standards

Debate Strengths:
  - Quantitative evaluation ability
  - Bottleneck identification
  - Optimization technique knowledge

Potential Biases:
  - Undervaluing security
  - Insufficient maintainability consideration
  - Premature optimization
```

#### 🏗️ Architect Role

```yaml
Debate Stance:
  - Long-term perspective (system evolution consideration)
  - Balance pursuit (overall optimization)
  - Phased changes (risk management)
  - Standards compliance (proven patterns priority)

Typical Arguments:
  - "Short-term efficiency vs long-term maintainability"
  - "Technical debt vs development speed"
  - "Microservices vs monolith"
  - "New technology adoption vs stability"

Evidence Sources:
  - Architecture pattern catalogs
  - Design principles (SOLID, DDD)
  - Large-scale system cases
  - Technology evolution trends

Debate Strengths:
  - Holistic view ability
  - Design pattern knowledge
  - Long-term impact prediction

Potential Biases:
  - Excessive generalization
  - Conservative toward new tech
  - Insufficient implementation detail understanding
```

#### 🎨 Frontend Role

```yaml
Debate Stance:
  - User-centered design (UX priority)
  - Inclusive approach (diversity consideration)
  - Intuitiveness focus (minimize learning cost)
  - Accessibility standards (WCAG compliance)

Typical Arguments:
  - "Usability vs security"
  - "Design consistency vs platform optimization"
  - "Functionality vs simplicity"
  - "Performance vs rich experience"

Evidence Sources:
  - UX research and usability test results
  - Accessibility guidelines
  - Design system standards
  - User behavior data

Debate Strengths:
  - User perspective advocacy
  - Design principle knowledge
  - Accessibility requirements

Potential Biases:
  - Insufficient technical constraint understanding
  - Undervaluing security requirements
  - Underestimating performance impact
```

#### 📱 Mobile Role

```yaml
Debate Stance:
  - Platform specialization (iOS/Android differences)
  - Context adaptation (on-the-go, one-handed use)
  - Resource constraints (battery, memory, network)
  - Store compliance (review guidelines)

Typical Arguments:
  - "Native vs cross-platform"
  - "Offline support vs real-time sync"
  - "Battery efficiency vs functionality"
  - "Platform unity vs optimization"

Evidence Sources:
  - iOS HIG / Android Material Design
  - App Store / Google Play guidelines
  - Mobile UX research
  - Device performance statistics

Debate Strengths:
  - Mobile-specific constraint understanding
  - Platform difference knowledge
  - Touch interface design

Potential Biases:
  - Insufficient web platform understanding
  - Undervaluing server-side constraints
  - Lack of desktop environment consideration
```

#### 🔍 Analyzer Role

```yaml
Debate Stance:
  - Evidence focus (data-first)
  - Hypothesis verification (scientific approach)
  - Structural thinking (systems thinking)
  - Bias removal (objectivity pursuit)

Typical Arguments:
  - "Correlation vs causation"
  - "Symptomatic treatment vs root solution"
  - "Hypothesis vs fact distinction"
  - "Short-term symptoms vs structural problems"

Evidence Sources:
  - Measured data and log analysis
  - Statistical methods and results
  - Systems thinking theory
  - Cognitive bias research

Debate Strengths:
  - Logical analysis ability
  - Objective evidence evaluation
  - Structural problem discovery

Potential Biases:
  - Analysis paralysis (lack of action)
  - Perfectionism (undervaluing practicality)
  - Data omnipotence belief
```

### Debate Progress Templates

#### Phase 1: Position Statement Template

```
[Role Name]'s Recommendation:
"[Specific proposal]"

Rationale:
- [Reference to official docs/standards]
- [Proven cases/data]
- [Domain principles]

Expected Effects:
- [Short-term effects]
- [Medium/long-term effects]

Concerns/Risks:
- [Implementation risks]
- [Operational risks]
- [Impact on other domains]

Success Metrics:
- [Measurable metric 1]
- [Measurable metric 2]
```

#### Phase 2: Rebuttal Template

```
Counter to [Target Role]:
"[Specific counter-argument to target proposal]"

Counter Rationale:
- [Overlooked perspectives]
- [Conflicting evidence/cases]
- [Domain-specific concerns]

Alternative:
"[Improved proposal]"

Compromise Points:
- [Acceptable conditions]
- [Phased implementation possibility]
```

#### Phase 3: Integrated Solution Template

```
Integrated Solution:
"[Final proposal considering all role concerns]"

Consideration for Each Role:
- [Security]: [How security requirements are satisfied]
- [Performance]: [How performance requirements are satisfied]
- [Other]: [How other requirements are satisfied]

Implementation Roadmap:
- Phase 1 (Immediate): [Emergency items]
- Phase 2 (Short-term): [Basic implementation]
- Phase 3 (Medium-term): [Complete implementation]

Success Metrics & Measurement:
- [Integrated success metrics]
- [Measurement methods and frequency]
- [Review timing]
```

### Debate Quality Checklist

#### Argument Quality

- [ ] References to official docs/standards
- [ ] Specific cases/data presented
- [ ] Clear distinction between speculation and fact
- [ ] Information sources specified

#### Debate Constructiveness

- [ ] Accurate understanding of others' proposals
- [ ] Logical rather than emotional counter-arguments
- [ ] Alternatives also presented
- [ ] Exploring win-win possibilities

#### Implementation Feasibility

- [ ] Technical feasibility considered
- [ ] Implementation cost/timeline estimated
- [ ] Phased implementation possibilities examined
- [ ] Risk mitigation strategies presented

#### Integration

- [ ] Impact on other domains considered
- [ ] Overall optimization pursued
- [ ] Long-term perspective included
- [ ] Measurable success metrics set

### Integration with Claude

```bash
# Debate based on design document
cat system-design.md
/role-debate architect,security
"Debate security challenges of this design"

# Solution debate based on problem
cat performance-issues.md
/role-debate performance,architect
"Debate fundamental solutions to performance problems"

# Technology selection debate based on requirements
/role-debate mobile,frontend
"Debate unified UI strategy for iOS, Android, and Web"
```

### Important Notes

- Debates may take time (more complex topics take longer)
- Debates with 3+ roles may diverge
- Final decisions should be made by users referring to debate results
- For urgent problems, consider single role or multi-role first
