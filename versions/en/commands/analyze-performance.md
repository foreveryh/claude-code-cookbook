## Analyze Performance

Analyze application performance and identify bottlenecks for optimization opportunities.

### Usage

```bash
# Comprehensive performance problem analysis
find . -name "*.js" -o -name "*.ts" | xargs wc -l | sort -rn | head -10
"Identify large files and performance issues and suggest improvements"

# Detect inefficient code patterns
grep -r "for.*await\|forEach.*await" . --include="*.js"
"Analyze N+1 query problems and performance bottlenecks"

# Memory leak possibilities
grep -r "addEventListener\|setInterval" . --include="*.js" | grep -v "removeEventListener\|clearInterval"
"Evaluate memory leak risks and countermeasures"
```

### Basic Examples

```bash
# Bundle size and load time
npm ls --depth=0 && find ./public -name "*.js" -o -name "*.css" | xargs ls -lh
"Identify bundle size and asset optimization improvement points"

# Database performance
grep -r "SELECT\|findAll\|query" . --include="*.js" | head -20
"Analyze database query optimization points"

# Dependencies performance impact
npm outdated && npm audit
"Evaluate the performance impact of outdated dependencies"
```

### Analysis Perspectives

#### 1. Code-Level Issues

- **O(n²) Algorithms**: Detect inefficient array operations
- **Synchronous I/O**: Identify blocking operations
- **Duplicate Processing**: Remove unnecessary calculations and requests
- **Memory Leaks**: Manage event listeners and timers

#### 2. Architecture-Level Issues

- **N+1 Queries**: Database access patterns
- **Insufficient Caching**: Repeated calculations or API calls
- **Bundle Size**: Unnecessary libraries or code splitting
- **Resource Management**: Connection pools and thread usage

#### 3. Technical Debt Impact

- **Legacy Code**: Performance degradation from old implementations
- **Design Issues**: High coupling due to insufficient responsibility distribution
- **Insufficient Testing**: Missed performance regression detection
- **Lack of Monitoring**: Early problem detection systems

### Improvement Priority

```
🔴 Critical: System failure risk
├─ Memory leaks (server crashes)
├─ N+1 queries (database load)
└─ Synchronous I/O (response delays)

🟡 High: User experience impact
├─ Bundle size (initial load time)
├─ Image optimization (display speed)
└─ Caching strategy (response speed)

🟢 Medium: Operational efficiency
├─ Dependency updates (security)
├─ Code duplication (maintainability)
└─ Enhanced monitoring (operational load)
```

### Measurement and Tools

#### Node.js / JavaScript

```bash
# Profiling
node --prof app.js
clinic doctor -- node app.js

# Bundle analysis
npx webpack-bundle-analyzer
lighthouse --chrome-flags="--headless"
```

#### Database

```sql
-- Query analysis
EXPLAIN ANALYZE SELECT ...
SHOW SLOW LOG;
```

#### Frontend

```bash
# React performance
grep -r "useMemo\|useCallback" . --include="*.jsx"

# Resource analysis
find ./src -name "*.png" -o -name "*.jpg" | xargs ls -lh
```

### Continuous Improvement

- **Regular audits**: Execute weekly performance testing
- **Metrics collection**: Track response times and memory usage
- **Alert configuration**: Automatic notifications on threshold violations
- **Team sharing**: Document improvement cases and anti-patterns
