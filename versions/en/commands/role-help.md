## Role Help

Get help with role selection and usage.

### Usage

```bash
/role-help                      # General role selection guide
/role-help <situation/problem>  # Recommended role for specific situation
/role-help compare <role1>,<role2> # Role comparison
```

### Basic Examples

```bash
# General guidance
/role-help
→ Display list of available roles and features

# Situation-specific recommendations
/role-help "API security concerns"
→ Security role recommendation and usage

# Role comparison
/role-help compare frontend,mobile
→ Differences and use cases for frontend vs mobile
```

### Situation-Based Role Selection Guide

### Security Related

```
When to use security role:
✅ Login and authentication feature implementation
✅ API security vulnerability checks
✅ Data encryption and privacy protection
✅ Security compliance verification
✅ Penetration testing

Usage: /role security
```

### 🏗️ Architecture & Design

```
When to use architect role:
✅ System-wide design evaluation
✅ Microservices vs Monolith decisions
✅ Database design and technology selection
✅ Scalability and extensibility considerations
✅ Technical debt assessment and improvement planning

Usage: /role architect
```

### ⚡ Performance Issues

```
When to use performance role:
✅ Slow application
✅ Database query optimization
✅ Web page load speed improvement
✅ Memory and CPU usage optimization
✅ Scaling and load management

Usage: /role performance
```

### 🔍 Problem Investigation

```
When to use analyzer role:
✅ Bug and error root cause analysis
✅ System failure investigation
✅ Complex problem structural analysis
✅ Data analysis and statistical investigation
✅ Understanding why problems occur

Usage: /role analyzer
```

### 🎨 Frontend & UI/UX

```
When to use frontend role:
✅ User interface improvements
✅ Accessibility compliance
✅ Responsive design
✅ Usability enhancements
✅ Web frontend technologies in general

Usage: /role frontend
```

### 📱 Mobile App Development

```
When to use mobile role:
✅ iOS and Android app optimization
✅ Mobile-specific UX design
✅ Touch interface optimization
✅ Offline support and sync features
✅ App Store and Google Play compliance

Usage: /role mobile
```

### 👀 Code Review & Quality

```
When to use reviewer role:
✅ Code quality checks
✅ Readability and maintainability evaluation
✅ Coding convention verification
✅ Refactoring suggestions
✅ PR and commit reviews

Usage: /role reviewer
```

### 🧪 Testing & Quality Assurance

```
When to use qa role:
✅ Test strategy planning
✅ Test coverage evaluation
✅ Automated testing implementation approach
✅ Bug prevention and quality improvement
✅ CI/CD test automation

Usage: /role qa
```

### When Multiple Roles Are Needed

### 🔄 multi-role (Parallel Analysis)

```
When to use multi-role:
✅ Need evaluations from multiple expert perspectives
✅ Want to create integrated improvement plans
✅ Want to compare evaluations from each field
✅ Need to resolve conflicts and redundancies

Example: /multi-role security,performance
```

### 🗣️ role-debate (Discussion)

```
When to use role-debate:
✅ Trade-offs between specialized fields
✅ Divided opinions on technology selection
✅ Need to decide design policies through discussion
✅ Want to hear arguments from different perspectives

Example: /role-debate security,performance
```

### 🤖 smart-review (Auto Suggestion)

```
When to use smart-review:
✅ Unsure which role to use
✅ Want to know optimal approach for current situation
✅ Want to choose from multiple options
✅ Beginner uncertain about decisions

Example: /smart-review
```

### Role Comparison Table

### Security Category

| Role | Primary Use | Strengths | Weaknesses |
|------|------------|-----------|------------|
| security | Vulnerabilities & attack prevention | Threat analysis, authentication design | UX, performance |
| analyzer | Root cause analysis | Logical analysis, evidence collection | Prevention, future planning |

### Design Category

| Role | Primary Use | Strengths | Weaknesses |
|------|------------|-----------|------------|
| architect | System design | Long-term perspective, overall optimization | Detailed implementation, short-term solutions |
| reviewer | Code quality | Implementation level, maintainability | Business requirements, UX |

### Performance Category

| Role | Primary Use | Strengths | Weaknesses |
|------|------------|-----------|------------|
| performance | Speed optimization | Measurement, bottleneck identification | Security, UX |
| qa | Quality assurance | Testing, automation | Design, architecture |

### User Experience Category

| Role | Primary Use | Strengths | Weaknesses |
|------|------------|-----------|------------|
| frontend | Web UI/UX | Browser, accessibility | Server-side, DB |
| mobile | Mobile UX | Touch, offline support | Server-side, Web |

### Decision Flowchart

```
Problem type?
├─ Security related → security
├─ Performance issues → performance  
├─ Bug/failure investigation → analyzer
├─ UI/UX improvements → frontend or mobile
├─ Design/architecture → architect
├─ Code quality → reviewer
├─ Testing related → qa
└─ Complex/compound → smart-review suggestion

Multiple fields involved?
├─ Want integrated analysis → multi-role
├─ Discussion/trade-offs → role-debate
└─ Uncertain decision → smart-review
```

### Frequently Asked Questions

### Q: What's the difference between frontend and mobile?

```
A: 
frontend: Web browser-focused, HTML/CSS/JavaScript
mobile: Mobile app-focused, iOS/Android native, React Native etc.

For both, recommend multi-role frontend,mobile
```

### Q: How to choose between security and analyzer?

```
A:
security: Attack/threat prevention, security design
analyzer: Investigate causes of existing problems

For security incident investigation, use multi-role security,analyzer
```

### Q: What's the difference between architect and performance?

```
A:
architect: Long-term system-wide design, extensibility
performance: Specific speed and efficiency improvements

For large-scale system performance design, use multi-role architect,performance
```

### Claude Integration

```bash
# Combine with situation description
/role-help
"React app page loading is slow and users are complaining"

# Combine with file content
cat problem-description.md
/role-help
"Recommend the optimal role for this problem"

# When uncertain between specific choices
/role-help compare security,performance
"Which role is appropriate for JWT token expiration issues?"
```

### Important Notes

- Complex problems benefit from combining multiple roles
- For urgent issues, single role enables quick response
- When uncertain, recommend using smart-review for automatic suggestions
- Final decision should consider the nature of the user's problem
