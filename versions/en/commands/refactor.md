## Refactor

Perform safe and incremental code refactoring while evaluating SOLID principle compliance.

### Usage

```bash
# Identify complex code and plan refactoring
find . -name "*.js" -exec wc -l {} + | sort -rn | head -10
"Refactor large files to reduce complexity"

# Detect and consolidate duplicate code
grep -r "function processUser" . --include="*.js"
"Consolidate duplicate functions using Extract Method"

# Detect SOLID principle violations
grep -r "class.*Service" . --include="*.js" | head -10
"Evaluate if these classes follow the Single Responsibility Principle"
```

### Basic Examples

```bash
# Detect long methods
grep -A 50 "function" src/*.js | grep -B 50 -A 50 "return" | wc -l
"Split methods longer than 50 lines using Extract Method"

# Conditional complexity
grep -r "if.*if.*if" . --include="*.js"
"Improve nested conditionals using Strategy pattern"

# Code smell detection
grep -r "TODO\|FIXME\|HACK" . --exclude-dir=node_modules
"Resolve technical debt in these comments"
```

### Refactoring Techniques

#### Extract Method

```javascript
// Before: Long method
function processOrder(order) {
  // 50 lines of complex logic
}

// After: Separated responsibilities
function processOrder(order) {
  validateOrder(order);
  calculateTotal(order);
  saveOrder(order);
}
```

#### Replace Conditional with Polymorphism

```javascript
// Before: Switch statement
function getPrice(user) {
  switch (user.type) {
    case 'premium': return basePrice * 0.8;
    case 'regular': return basePrice;
  }
}

// After: Strategy pattern
class PremiumPricing {
  calculate(basePrice) { return basePrice * 0.8; }
}
```

### SOLID Principles Check

```
S - Single Responsibility
├─ Each class has a single responsibility
├─ Only one reason to change
└─ Clear responsibility boundaries

O - Open/Closed
├─ Open for extension
├─ Closed for modification
└─ Existing code protection when adding features

L - Liskov Substitution
├─ Derived class substitutability
├─ Contract compliance
└─ Expected behavior maintenance

I - Interface Segregation
├─ Appropriate interface granularity
├─ Avoid depending on unused methods
└─ Role-based interface definition

D - Dependency Inversion
├─ Depend on abstractions
├─ Separation from concrete implementations
└─ Leverage dependency injection
```

### Refactoring Process

1. **Current State Analysis**
   - Complexity measurement (cyclomatic complexity)
   - Duplicate code detection
   - Dependency analysis

2. **Incremental Execution**
   - Small steps (15-30 minute units)
   - Test execution after each change
   - Frequent commits

3. **Quality Verification**
   - Maintain test coverage
   - Performance measurement
   - Code review

### Common Code Smells

- **God Object**: Class with too many responsibilities
- **Long Method**: Methods exceeding 50 lines
- **Duplicate Code**: Repeated logic
- **Large Class**: Classes exceeding 300 lines
- **Long Parameter List**: More than 4 parameters

### Automation Support

```bash
# Static analysis
npx complexity-report src/
sonar-scanner

# Code formatting
npm run lint:fix
prettier --write src/

# Test execution
npm test
npm run test:coverage
```

### Important Notes

- **No functional changes**: Do not change external behavior
- **Test first**: Add tests before refactoring
- **Incremental approach**: Avoid large changes at once
- **Continuous verification**: Test execution at each step
