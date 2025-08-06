## Check Prompt

A comprehensive best practices collection for evaluating and improving prompt quality for AI agents. This systematizes insights gained from actual prompt improvement processes, covering all critical aspects including ambiguity elimination, information consolidation, enforcement strengthening, tracking systems, and continuous improvement.

### Usage

```bash
# Check quality of a prompt file
cat your-prompt.md | /check-prompt "Check this prompt's quality and provide improvement suggestions"
```

### Options

- None: Analyze current file or selected text
- `--category <name>`: Check only specific category (structure/execution/restrictions/quality/roles/improvement)
- `--score`: Calculate quality score only
- `--fix`: Auto-suggest fixes for detected issues
- `--deep`: Deep analysis mode (focus on ambiguity, information dispersion, enforcement strength)

### Basic Examples

```bash
# Overall prompt quality evaluation
cat devin/playbooks/code-review.md | /check-prompt "Evaluate this prompt's quality across 6 categories and provide issues and improvement suggestions"

# Deep analysis mode
/check-prompt --deep "Focus on checking ambiguity, information dispersion, and insufficient enforcement for fundamental improvement suggestions"

# Check specific category
/check-prompt --category structure "Check this prompt from structure and clarity perspective"

# Detect and fix ambiguous expressions
/check-prompt --fix "Detect ambiguous expressions and suggest clear expression corrections"
```

---

## Core Design Principles

### Principle 1: Completely Eliminate Room for Interpretation

- **Absolutely Forbidden**: "in principle", "recommended", "if possible", "as appropriate", "judge accordingly"
- **Must Use**: "definitely", "absolutely", "strictly observe", "without exception", "mandatory"
- **Exception Conditions**: Strictly limited numerically ("only the following 3 conditions", "except these 2 cases")

### Principle 2: Strategic Information Integration

- Complete integration of related important information into one section
- Summarize overall picture in execution checklist
- Thoroughly eliminate reference cycles and dispersion

### Principle 3: Build Graduated Enforcement

- Clear hierarchy: 🔴 (execution halt level) → 🟡 (quality important) → 🟢 (recommendations)
- Gradual upgrade from recommendation level to mandatory level
- Clear indication of impact and response for violations

### Principle 4: Ensure Traceability

- All execution results recordable and verifiable
- Technical prevention of false reporting
- Objective criteria for success/failure judgment

### Principle 5: Feedback-Driven Improvement

- Learn from actual failure cases
- Continuous effectiveness verification
- Automatic detection of new patterns

---

## 📋 Comprehensive Check Items

### 1. 📐 Structure and Clarity (25 points)

#### 1.1 Instruction Priority Display (8 points)
- [ ] 🔴🟡🟢 priorities clearly marked for all important instructions
- [ ] Execution halt level conditions specifically and clearly defined
- [ ] Each priority's judgment criteria objective and verifiable
- [ ] Priority hierarchy consistently applied

#### 1.2 Complete Elimination of Ambiguous Expressions (9 points)
- [ ] **Critical ambiguous expressions**: "in principle", "recommended", "if possible" - 0 instances
- [ ] **Use of mandatory expressions**: Proper use of "definitely", "absolutely", "strictly observe", "without exception"
- [ ] **Numerical limitation of exception conditions**: Clear boundaries like "only 3 conditions"
- [ ] **Elimination of judgment room**: Only expressions that allow no multiple interpretations
- [ ] **Eradication of gray zones**: Clear judgment criteria for all situations

#### 1.3 Strategic Information Integration (8 points)
- [ ] Multiple-location dispersion of important information completely resolved
- [ ] Related instructions logically integrated into one section
- [ ] Overall picture completely summarized in execution checklist
- [ ] No reference cycles or infinite loops exist

### 2. 🎯 Executability (20 points)

#### 2.1 Concrete Procedure Completeness (7 points)
- [ ] All command examples actually executable and verified
- [ ] Environment variables, prerequisites, dependencies completely specified
- [ ] Error handling concrete and executable
- [ ] Procedure order logical and necessary

#### 2.2 Ensuring Verifiability (7 points)
- [ ] Execution result success/failure objectively determinable
- [ ] Output examples, log formats, expected values specifically shown
- [ ] Test methods and verification procedures implementable
- [ ] Intermediate result confirmation points appropriately placed

#### 2.3 Automation Adaptability (6 points)
- [ ] Easy format for scripting and CI/CD integration
- [ ] Clear separation between human judgment and AI execution parts
- [ ] Support for batch processing and parallel execution

### 3. 🚫 Clarification of Prohibitions (15 points)

#### 3.1 Systematization of Absolute Prohibitions (8 points)
- [ ] Complete listing of operations that must not be executed
- [ ] Clear indication of violation impact level (minor/major/critical) for each prohibition
- [ ] Concrete presentation of alternative methods and workarounds
- [ ] Explanation of technical rationale for prohibitions

#### 3.2 Strict Limitation of Exception Conditions (7 points)
- [ ] Conditions allowing exceptions specific and limited (numerical specification)
- [ ] Objective judgment criteria like "completely duplicate", "explicitly stated"
- [ ] Clear boundaries leaving no gray zones
- [ ] Clear additional conditions and constraints when applying exceptions

### 4. 📊 Quality Assurance Mechanisms (20 points)

#### 4.1 Tracking System Completeness (8 points)
- [ ] Automatic recording and statistics acquisition for all execution results
- [ ] Verification function to technically prevent false reporting
- [ ] Real-time monitoring and alert functions
- [ ] Tamper-proof audit logs

#### 4.2 Template Compliance Enforcement (7 points)
- [ ] Clear definition and check function for mandatory elements
- [ ] Technical restrictions on non-customizable parts
- [ ] Automated checkpoints for compliance verification
- [ ] Automatic correction and warning functions for violations

#### 4.3 Error Handling Comprehensiveness (5 points)
- [ ] Complete cataloging of expected error patterns
- [ ] Staged response processes for errors
- [ ] Technical prevention of reporting failures as successes

### 5. 🎭 Role and Responsibility Clarification (10 points)

#### 5.1 AI Agent Authority Scope (5 points)
- [ ] Clear boundaries between executable and prohibited operations
- [ ] Specific range and constraints of judgment authority
- [ ] Clear separation of operations requiring human confirmation

#### 5.2 Unified Classification System (5 points)
- [ ] Classification definitions clear, unique, and exclusive
- [ ] Explicit explanations to prevent importance misunderstandings between classifications
- [ ] Specific usage examples and judgment flowcharts for each classification

### 6. 🔄 Continuous Improvement (10 points)

#### 6.1 Automated Feedback Collection (5 points)
- [ ] Automatic improvement point extraction from execution logs
- [ ] Machine learning-based analysis of failure patterns
- [ ] Best practices auto-update mechanisms

#### 6.2 Learning Function Implementation (5 points)
- [ ] Automatic detection and classification of new patterns
- [ ] Continuous monitoring of existing rule effectiveness
- [ ] Automatic suggestions for gradual improvements

---

## 🚨 Critical Problem Patterns (Immediate Fix Required)

### ❌ Level 1: Critical Ambiguity (Execution Halt Level)

- **Multiple-interpretation possible instructions**: "judge appropriately", "according to situation", "in principle"
- **Ambiguous exception conditions**: "in special cases", "when necessary"
- **Subjective judgment criteria**: "appropriately", "sufficiently", "as much as possible"
- **Undefined important concepts**: "standard", "general", "basic"

### ❌ Level 2: Structural Defects (Quality Important Level)

- **Information dispersion**: Important related information scattered in 3 or more locations
- **Circular references**: Section A→B→C→A infinite loops
- **Contradictory instructions**: Conflicting instructions in different sections
- **Unclear execution order**: Procedures with unclear dependencies

### ❌ Level 3: Quality Degradation (Recommended Improvement Level)

- **Unverifiability**: Unclear success/failure judgment criteria
- **Automation difficulty**: Design dependent on human subjective judgment
- **Maintenance difficulty**: Structure where update impact range is unpredictable
- **Learning difficulty**: Complexity that takes time for newcomers to understand

---

## 🎯 Proven Improvement Methods

### ✅ Gradual Strengthening Approach

1. **Current Analysis**: Problem classification, prioritization, impact assessment
2. **Critical Problem Priority**: Complete resolution of Level 1 problems as top priority
3. **Gradual Implementation**: Implement in verifiable units, not all changes at once
4. **Effect Measurement**: Quantitative comparison before and after improvement
5. **Continuous Monitoring**: Confirm sustainability of improvement effects

### ✅ Practical Ambiguity Elimination Methods

```markdown
# ❌ Before improvement (ambiguous)
"Issues should, in principle, be recorded as inline comments on the relevant changed locations on GitHub"

# ✅ After improvement (clear)
"Issues must definitely be recorded as inline comments on the relevant changed locations on GitHub. Exceptions are only the 3 conditions defined in Section 3.3"
```

### ✅ Practical Information Integration Methods

```markdown
# ❌ Before improvement (dispersed)
Section 2.1: "Use mandatory 6 sections"
Section 3.5: "📊 Overall evaluation, 📋 Issues..."
Section 4.2: "Section deletion prohibited"

# ✅ After improvement (integrated)
Execution Checklist:
□ 10. Post summary comment (use mandatory 6 sections)

🔴 Mandatory 6 sections:
1) 📊 Overall evaluation
2) 📋 Issue classification summary
3) ⚠️ Major concerns
4) ✅ Commendable points
5) 🎯 Conclusion
6) 🤖 AI review quality self-assessment

❌ Absolutely prohibited: Section deletion, addition, name changes
```

### ✅ Tracking System Implementation Patterns

```bash
# Strict tracking of execution results
POSTED_COMMENTS=0
FAILED_COMMENTS=0
TOTAL_COMMENTS=0

# Record results of each operation
if [ $? -eq 0 ]; then
    echo "✅ Success: $OPERATION" >> /tmp/execution_log.txt
    POSTED_COMMENTS=$((POSTED_COMMENTS + 1))
else
    echo "❌ Failed: $OPERATION" >> /tmp/execution_log.txt
    FAILED_COMMENTS=$((FAILED_COMMENTS + 1))
fi

# Prevent false reporting
if [ $POSTED_COMMENTS -ne $REPORTED_COMMENTS ]; then
    echo "🚨 Warning: Reported count doesn't match actual posts"
    exit 1
fi
```

---

## 📈 Quality Score Calculation (Improved Version)

### Overall Score Calculation

```
Basic score = Σ(Each category score × points) / 100

Critical problem penalties:
- Level 1 problems: -20 points/case
- Level 2 problems: -10 points/case  
- Level 3 problems: -5 points/case

Bonus elements:
- Automation support: +5 points
- Learning function implementation: +5 points
- Proven improvement cases: +5 points

Final score = Basic score + Bonus - Penalties
```

### Quality Level Determination

```
95-100 points: World-class standard (recommendable as industry standard)
90-94 points: Excellent (production-ready)
80-89 points: Good (operational with minor improvements)
70-79 points: Average (improvements needed)
60-69 points: Needs improvement (major modifications required)
50-59 points: Major revision needed (fundamental review required)
49 points or below: Usage prohibited (complete redesign required)
```

---

## 🔧 Practical Improvement Process

### Phase 1: Diagnosis and Analysis (1-2 days)

1. **Overall structure understanding**: Visualization of section composition, information flow, dependencies
2. **Ambiguity detection**: Complete extraction of interpretable expressions
3. **Information dispersion analysis**: Mapping of related information scatter patterns
4. **Enforcement evaluation**: Classification and effectiveness evaluation of recommendations/mandatory items
5. **Traceability confirmation**: Evaluation of execution result recording and verification functions

### Phase 2: Prioritization and Planning (half day)

1. **Criticality classification**: Problem classification Level 1-3 and impact assessment
2. **Improvement order determination**: Optimal order considering interdependencies
3. **Resource allocation**: Balance optimization of improvement effects and costs
4. **Risk evaluation**: Prediction of side effects and compatibility issues during improvement

### Phase 3: Gradual Implementation (2-5 days)

1. **Level 1 problem resolution**: Complete elimination of critical ambiguity
2. **Information integration implementation**: Strategic consolidation of dispersed information
3. **Enforcement strengthening**: Gradual upgrade from recommendations to mandatory
4. **Tracking system implementation**: Automatic recording and verification functions for execution results
5. **Template strengthening**: Clarification of mandatory elements and compliance enforcement

### Phase 4: Verification and Adjustment (1-2 days)

1. **Function testing**: Operation confirmation of all changes
2. **Integration testing**: System-wide consistency confirmation
3. **Performance testing**: Execution efficiency and response confirmation
4. **Usability testing**: Verification in actual usage scenarios

### Phase 5: Operation and Monitoring (continuous)

1. **Effect measurement**: Quantitative comparison before and after improvement
2. **Continuous monitoring**: Early detection of quality degradation
3. **Feedback collection**: Problem point extraction in actual operation
4. **Continued optimization**: Continuous improvement cycle

---

## 📊 Actual Improvement Case Study (Detailed Version)

### Case Study: Large-Scale Prompt Quality Improvement

#### Pre-improvement Situation

```bash
Quality score: 70/100 points
- Ambiguous expressions: 15 locations found
- Information dispersion: Important info scattered in 6 locations
- Insufficient enforcement: 80% recommendation-level expressions
- Tracking function: No execution result recording
- Error handling: Unclear response for failures
```

#### Implemented Improvements

```bash
# 1. Ambiguity elimination (2 days)
- "in principle" → "exceptions only 3 conditions in Section 3.3"
- "recommended" → "mandatory" (importance level 2 and above)
- "appropriately" → specific judgment criteria indication

# 2. Information integration (1 day)
- Scattered mandatory 6 sections info → integrated into execution checklist
- Related prohibitions → consolidated into one section
- Resolved reference cycles → linear information flow

# 3. Tracking system implementation (1 day)
- Automatic log recording of execution results
- Verification function preventing false reporting
- Real-time statistics display

# 4. Error handling strengthening (half day)
- Complete cataloging of expected error patterns
- Documentation of staged response processes
- Implementation of automatic recovery functions
```

#### Post-improvement Results

```bash
Quality score: 90/100 points (+20 point improvement)
- Ambiguous expressions: 0 locations (complete elimination)
- Information integration: Important info consolidated into 3 locations
- Enforcement: 95% mandatory-level expressions
- Tracking function: Complete automation
- Error handling: Automatic resolution of 90% of problems

Actual improvement effects:
- Judgment errors: 85% reduction
- Execution time: 40% reduction
- Error occurrence rate: 70% reduction
- User satisfaction: 95% improvement
```

### Lessons and Best Practices

#### Success Factors

1. **Gradual approach**: Implement in verifiable units, not all changes at once
2. **Data-driven**: Improvements based on measured data, not subjective judgment
3. **Continuous monitoring**: Regular confirmation of improvement effect sustainability
4. **Feedback emphasis**: Actively collect opinions from actual users

#### Failure Avoidance Strategies

1. **Excessive perfectionism**: Start operation at 90 points, aim for 100 through continuous improvement
2. **Danger of bulk changes**: Definitely implement large-scale changes gradually
3. **Backward compatibility**: Minimize impact on existing workflows
4. **Insufficient documentation**: Record and share all changes in detail

---

### Integration with Claude

```bash
# Quality check combined with prompt file
cat your-prompt.md | /check-prompt "Evaluate this prompt's quality and suggest improvements"

# Comparison of multiple prompt files
cat prompt-v1.md && echo "---" && cat prompt-v2.md | /check-prompt "Compare these two versions and analyze improved points and remaining issues"

# Analysis combined with actual error logs
cat execution-errors.log | /check-prompt --deep "Identify prompt issues that may have caused these errors"
```

### Notes

- **Prerequisites**: Prompt files recommended to be written in Markdown format
- **Limitations**: For large prompts (10,000+ lines), recommend splitting for analysis
- **Recommendations**: Regularly perform prompt quality checks and continuously improve

---

_This checklist is the complete version of insights proven in actual prompt improvement projects and continues to evolve continuously._
