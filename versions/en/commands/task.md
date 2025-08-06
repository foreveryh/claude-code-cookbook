## Task

Launch dedicated agents to autonomously execute complex search, investigation, and analysis tasks. Handles large-scale information processing by combining multiple tools with a focus on context efficiency.

### Usage

```bash
# Request Claude Task
"[Issue] Investigate with Task"
```

### Task Features

**Autonomous Execution**
- Automatically combines multiple tools for execution
- Staged information collection and analysis
- Result integration and structured reporting

**Efficient Information Processing**
- Optimized context consumption
- Large-scale file search and analysis
- Data collection from external information sources

**Quality Assurance**
- Information source reliability checks
- Multi-perspective verification
- Automatic completion of missing information

### Basic Examples

```bash
# Complex codebase investigation
"Which files implement this feature? Investigate with Task"

# Large-scale file search
"Identify configuration file inconsistencies with Task"

# External information collection
"Investigate latest AI technology trends with Task"
```

### Claude Integration

```bash
# Complex problem analysis
"Analyze the cause of memory leaks with Task. Include profiling results and logs"

# Dependency investigation
"Investigate vulnerabilities in this npm package with Task"

# Competitive analysis
"Investigate competitor service API specifications with Task"

# Architecture analysis
"Analyze microservice dependencies with Task"
```

### Comparison with Other Commands

#### Task vs Other Commands

| Command | Primary Use | Execution Style | Information Collection |
|---------|-------------|-----------------|----------------------|
| **Task** | Investigation/Analysis/Search | Autonomous execution | Multiple sources |
| ultrathink | Deep thinking/judgment | Structured thinking | Primarily existing knowledge |
| sequential-thinking | Problem solving/design | Step-by-step thinking | As needed |
| plan | Implementation planning | Approval process | Requirements analysis |

#### Decision Flow Chart

```
Is information collection needed?
├─ Yes → Multiple sources/large-scale?
│ ├─ Yes → **Task**
│ └─ No → Regular question
└─ No → Deep thinking required?
    ├─ Yes → ultrathink/sequential-thinking
    └─ No → Regular question
```

### Effective Cases & Unnecessary Cases

**Effective Cases**
- Complex codebase investigation (dependency, architecture analysis)
- Large-scale file search (specific implementation patterns, config files)
- External information collection and organization (tech trends, library research)
- Information integration from multiple sources (log analysis, metrics analysis)
- Iterative investigation work (security audits, technical debt investigation)
- Large-scale analysis avoiding context consumption

**Unnecessary Cases**
- Simple questions answerable with existing knowledge
- Quick one-off tasks
- Work requiring interactive confirmation/consultation
- Implementation or design decisions (plan or thinking commands are appropriate)

### Category-Specific Detailed Examples

#### System Analysis & Investigation

```bash
# Complex system analysis
"Identify bottlenecks in the e-commerce site with Task. Investigate database, API, and frontend comprehensively"

# Architecture analysis
"Analyze microservice dependencies with Task. Include API communication and data flow"

# Technical debt investigation
"Analyze technical debt in legacy code with Task. Include refactoring priorities"
```

#### Security & Compliance

```bash
# Security audit
"Investigate application vulnerabilities with Task. Based on OWASP Top 10"

# License investigation
"Investigate project dependency license issues with Task"

# Configuration file audit
"Identify security configuration inconsistencies with Task. Include differences across environments"
```

#### Performance & Optimization

```bash
# Performance analysis
"Identify heavy queries in the application with Task. Include execution plans and optimization suggestions"

# Resource usage investigation
"Investigate memory leak causes with Task. Include profiling results and code analysis"

# Bundle size analysis
"Investigate frontend bundle size issues with Task. Include optimization recommendations"
```

#### External Information Collection

```bash
# Technology trend research
"Investigate 2024 JavaScript framework trends with Task"

# Competitive analysis
"Investigate competitor service API specifications with Task. Include feature comparison table"

# Library evaluation
"Compare state management libraries with Task. Include performance and learning curve"
```

### Execution Flow and Quality Assurance

#### Task Execution Flow

```
1. Initial Analysis
├─ Break down issues and identify investigation scope
├─ Select necessary tools and information sources
└─ Create execution plan

2. Information Collection
├─ File search and code analysis
├─ External information collection
└─ Data structuring

3. Analysis & Integration
├─ Analyze relationships in collected information
├─ Identify patterns and issues
└─ Verify hypotheses

4. Reporting & Recommendations
├─ Structure results
├─ Create improvement proposals
└─ Present next actions
```

#### Quality Assurance
- **Information source reliability checks**: Fact verification through multiple sources
- **Completeness verification**: Check for gaps in investigation targets
- **Consistency validation**: Resolve conflicting information
- **Practicality evaluation**: Assess feasibility and effectiveness of proposals

### Error Handling and Constraints

#### Common Constraints
- **External API usage limits**: Rate limits and authentication errors
- **Large file processing limits**: Memory and timeout constraints
- **Access permission issues**: File or directory access restrictions

#### Error Response
- **Partial result reporting**: Analysis with only obtainable information
- **Alternative method suggestions**: Alternative investigation methods under constraints
- **Staged execution**: Breaking down large tasks for execution

### Important Notes

- Task is optimal for complex autonomous investigation and analysis tasks
- For simple questions or cases requiring immediate answers, use regular question format
- Treat investigation results as reference information and always verify important decisions
- When collecting external information, pay attention to information freshness and accuracy

### Usage Example

```bash
# Usage example
"Investigate GraphQL schema issues with Task"

# Expected behavior
# 1. Dedicated agent starts
# 2. Search for GraphQL-related files
# 3. Analyze schema definitions
# 4. Compare with best practices
# 5. Identify issues and improvement suggestions
# 6. Create structured report
```
