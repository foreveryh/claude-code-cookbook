## Analyze Dependencies

Analyze project dependencies and evaluate architecture health. Visualizes dependency structures and identifies circular dependencies and architectural violations.

### Usage

```bash
/analyze-dependencies [Options]
```

### Options

- `--visual` : Display dependencies graphically
- `--circular` : Detect circular dependencies only
- `--depth <number>` : Specify analysis depth (default: 3)
- `--focus <path>` : Focus on specific module/directory

### Basic Examples

```bash
# Analyze entire project dependencies
/analyze-dependencies

# Detect circular dependencies
/analyze-dependencies --circular

# Detailed analysis of specific module
/analyze-dependencies --focus src/core --depth 5
```

### Analysis Items

#### 1. Dependency Matrix

Quantify and display inter-module dependencies:

- Direct dependencies
- Indirect dependencies
- Dependency depth
- Fan-in/Fan-out metrics

#### 2. Architecture Violation Detection

- Layer violations (lower layer depending on upper layer)
- Circular dependencies
- Excessive coupling (high dependency count)
- Isolated modules

#### 3. Clean Architecture Compliance Check

- Domain layer independence
- Infrastructure layer proper separation
- Use case layer dependency direction
- Interface implementation status

### Output Examples

```
Dependency Analysis Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Metrics Overview
├─ Total modules: 42
├─ Average dependencies: 3.2
├─ Maximum dependency depth: 5
└─ Circular dependencies: 2 detected

⚠️  Architecture Violations
├─ [HIGH] src/domain/user.js → src/infra/database.js
│  └─ Domain layer directly depends on infrastructure layer
├─ [MED] src/api/auth.js ⟲ src/services/user.js
│  └─ Circular dependency detected
└─ [LOW] src/utils/helper.js → 12 modules
   └─ Excessive fan-out

✅ Recommended Actions
1. Introduce UserRepository interface
2. Redesign authentication service responsibilities
3. Split helper functions by feature

📈 Dependency Graph
[Visual dependency diagram displayed in ASCII art]
```

### Advanced Usage Examples

```bash
# Automated check in CI/CD pipeline
/analyze-dependencies --circular --fail-on-violation

# Define and verify architecture rules
/analyze-dependencies --rules .architecture-rules.yml

# Track dependency changes over time
/analyze-dependencies --compare HEAD~10
```

### Configuration File Example (.dependency-analysis.yml)

```yaml
rules:
  - name: "Domain Independence"
    source: "src/domain/**"
    forbidden: ["src/infra/**", "src/api/**"]

  - name: "API Layer Dependencies"
    source: "src/api/**"
    allowed: ["src/domain/**", "src/application/**"]
    forbidden: ["src/infra/**"]

thresholds:
  max_dependencies: 8
  max_depth: 4
  coupling_threshold: 0.7

ignore:
  - "**/test/**"
  - "**/mocks/**"
```

### Integration Tools

- `madge` : JavaScript/TypeScript dependency visualization
- `dep-cruiser` : Dependency rules verification
- `nx` : Monorepo dependency management
- `plato` : Integrated complexity and dependency analysis

### Claude Integration Examples

```bash
# Analysis including package.json
cat package.json
/analyze-dependencies
"Analyze the dependency issues in this project"

# Combine with specific module source code
ls -la src/core/
/analyze-dependencies --focus src/core
"Evaluate the core module dependencies in detail"

# Compare with architecture documentation
cat docs/architecture.md
/analyze-dependencies --visual
"Check for discrepancies between design documentation and implementation"
```

### Important Notes

- **Prerequisites**: Must be executed from project root
- **Limitations**: Analysis of large projects may take considerable time
- **Recommendations**: Consider immediate action when circular dependencies are found

### Best Practices

1. **Regular analysis**: Weekly dependency health checks
2. **Document rules**: Manage architecture rules in configuration files
3. **Gradual improvement**: Avoid massive refactoring, prefer incremental improvements
4. **Track metrics**: Monitor dependency complexity over time
