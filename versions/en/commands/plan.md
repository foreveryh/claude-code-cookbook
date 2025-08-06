## Plan

Activate pre-implementation planning mode to develop detailed implementation strategies. Support efficient development by creating structured plans before code implementation.

### Usage

```bash
# Request Plan Mode from Claude
"Create an implementation plan for [implementation content]"
```

### Basic Examples

```bash
# New feature implementation plan
"Create an implementation plan for user authentication feature"

# System design planning
"Create an implementation plan for microservices split"

# Refactoring plan
"Create a refactoring plan for legacy code"
```

### Integration with Claude

```bash
# Complex feature implementation
"Create an implementation plan for chat feature. Include WebSocket, real-time notifications, and history management"

# Database design
"Create a database design plan for e-commerce site. Include products, orders, and user management"

# API design
"Create an implementation plan for GraphQL API. Include authentication, caching, and rate limiting"

# Infrastructure design
"Create a Dockerization implementation plan. Include development environment, production environment, and CI/CD"
```

### Plan Mode Features

**Automatic Activation**

- Plan Mode activates automatically when implementation tasks are detected
- Can be explicitly activated with keywords like "create implementation plan"

**Structured Specifications**

- Requirements definition (user stories, acceptance criteria)
- Design documents (architecture, data design, UI design)
- Implementation plan (task breakdown, progress tracking, quality assurance)
- Risk analysis and mitigation

**Approval Process**

- Present plan with `exit_plan_mode` tool
- **Important**: Always wait for explicit user approval regardless of tool return value
- Implementation without approval is prohibited
- Plan modification and adjustment possible
- Start task management with TodoWrite only after approval

### Detailed Examples

```bash
# Complex system implementation
"Create an implementation plan for online payment system. Include Stripe integration, security, and error handling"

# Frontend implementation
"Create an implementation plan for React dashboard. Include state management, component design, and testing"

# Backend implementation
"Create an implementation plan for RESTful API. Include authentication, validation, and logging"

# DevOps implementation
"Create an implementation plan for CI/CD pipeline. Include test automation, deployment, and monitoring"
```

### 3-Phase Workflow

#### Phase 1: Requirements

- **User Stories**: Clarify feature purpose and value
- **Acceptance Criteria**: Define completion conditions and quality standards
- **Constraints & Prerequisites**: Organize technical and time constraints
- **Prioritization**: Must-have/Nice-to-have classification

#### Phase 2: Design

- **Architecture Design**: System configuration and technology selection
- **Data Design**: Schema, API specifications, data flow
- **UI/UX Design**: Screen layout and operation flow
- **Risk Analysis**: Potential problems and countermeasures

#### Phase 3: Implementation

- **Task Breakdown**: Decomposition into implementable units
- **Progress Tracking**: State management via TodoWrite
- **Quality Assurance**: Test strategy and verification methods
- **Approval Process**: Plan presentation via exit_plan_mode and explicit approval wait

### Important Notes

**Scope of Application**

- Plan Mode is optimal for complex implementation tasks
- Use normal implementation format for simple fixes or small changes
- Recommended for work with 3+ steps or new feature development

**Technical Constraints**

- Do not trust `exit_plan_mode` tool return values
- Judge approval process by explicit user intention
- Different from CLI plan mode functionality

**Execution Precautions**

- Implementation before approval is strictly prohibited
- Always wait for user response after plan presentation
- Provide alternatives on error

### Execution Example

```bash
# Usage example
"Create an implementation plan for user management system"

# Expected behavior
# 1. Plan Mode activates automatically
# 2. Requirements analysis and technology selection
# 3. Implementation step structuring
# 4. Plan presentation via exit_plan_mode
# 5. Implementation starts after approval
```
