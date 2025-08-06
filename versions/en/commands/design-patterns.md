## Design Patterns

Apply and suggest appropriate design patterns for better code organization and maintainability.

### Usage

```bash
/design-patterns [target] [Options]
```

### Options

- `--suggest` : Suggest applicable patterns (default)
- `--analyze` : Analyze existing pattern usage
- `--refactor` : Generate refactoring suggestions
- `--solid` : Check SOLID principle compliance
- `--anti-patterns` : Detect anti-patterns

### Basic Examples

```bash
# Analyze patterns across entire project
/design-patterns

# Suggest patterns for specific file
/design-patterns src/services/user.js --suggest

# Check SOLID principles
/design-patterns --solid

# Detect anti-patterns
/design-patterns --anti-patterns
```

### Analysis Categories

#### 1. Creational Patterns

- **Factory Pattern**: Abstract object creation
- **Builder Pattern**: Sequential construction of complex objects
- **Singleton Pattern**: Ensure instance uniqueness
- **Prototype Pattern**: Clone-based object creation

#### 2. Structural Patterns

- **Adapter Pattern**: Interface conversion
- **Decorator Pattern**: Dynamic feature addition
- **Facade Pattern**: Simplify complex subsystems
- **Proxy Pattern**: Control access to objects

#### 3. Behavioral Patterns

- **Observer Pattern**: Event notification implementation
- **Strategy Pattern**: Algorithm switching
- **Command Pattern**: Operation encapsulation
- **Iterator Pattern**: Collection traversal

### SOLID Principles Checklist

```
S - Single Responsibility Principle
O - Open/Closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
```

### Output Examples

```
Design Patterns Analysis Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Currently Used Patterns
├─ Observer Pattern: EventEmitter (12 locations)
├─ Factory Pattern: UserFactory (3 locations)
├─ Singleton Pattern: DatabaseConnection (1 location)
└─ Strategy Pattern: PaymentProcessor (5 locations)

Recommended Patterns
├─ [HIGH] Repository Pattern
│  └─ Target: src/models/*.js
│  └─ Reason: Separate data access logic
│  └─ Example:
│      class UserRepository {
│        async findById(id) { ... }
│        async save(user) { ... }
│      }
│
├─ [MED] Command Pattern
│  └─ Target: src/api/handlers/*.js
│  └─ Reason: Unify request processing
│
└─ [LOW] Decorator Pattern
   └─ Target: src/middleware/*.js
   └─ Reason: Improve feature composition

SOLID Principle Violations
├─ [S] UserService: Handles both authentication and authorization
├─ [O] PaymentGateway: Requires modification for new payment methods
├─ [D] EmailService: Direct dependency on concrete class
└─ [I] IDataStore: Contains unused methods

Refactoring Suggestions
1. Split UserService into authentication and authorization
2. Introduce PaymentStrategy interface
3. Define EmailService interface
4. Separate IDataStore by usage
```

### Advanced Usage Examples

```bash
# Analyze impact of pattern application
/design-patterns --impact-analysis Repository

# Generate implementation example for specific pattern
/design-patterns --generate Factory --for src/models/Product.js

# Suggest pattern combinations
/design-patterns --combine --context "API with caching"

# Evaluate architectural patterns
/design-patterns --architecture MVC
```

### Pattern Application Examples

#### Before (Problematic Code)

```javascript
class OrderService {
  processOrder(order, paymentType) {
    if (paymentType === "credit") {
      // Credit card processing
    } else if (paymentType === "paypal") {
      // PayPal processing
    }
    // Other payment methods...
  }
}
```

#### After (Strategy Pattern Applied)

```javascript
// Strategy interface
class PaymentStrategy {
  process(amount) {
    throw new Error("Must implement process method");
  }
}

// Concrete strategies
class CreditCardPayment extends PaymentStrategy {
  process(amount) {
    /* implementation */
  }
}

// Context
class OrderService {
  constructor(paymentStrategy) {
    this.paymentStrategy = paymentStrategy;
  }

  processOrder(order) {
    this.paymentStrategy.process(order.total);
  }
}
```

### Anti-Pattern Detection

- **God Object**: Classes with too many responsibilities
- **Spaghetti Code**: Complex intertwined control flow
- **Copy-Paste Programming**: Excessive code duplication
- **Magic Numbers**: Hard-coded constants
- **Callback Hell**: Deeply nested callbacks

### Best Practices

1. **Gradual application**: Don't apply too many patterns at once
2. **Verify necessity**: Patterns are problem-solving tools, not goals
3. **Team consensus**: Discuss with team before applying patterns
4. **Documentation**: Record the intent of applied patterns
