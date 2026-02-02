---
name: architectural-patterns
description: SOLID, DDD, Clean Code, and design patterns reference. Use when designing architecture, refactoring code, reviewing for patterns, or discussing best practices.
---

# Architectural Principles & Patterns

## SOLID Principles

| Principle | Definition | Key Check |
|-----------|------------|-----------|
| **S** Single Responsibility | One class = one reason to change | Does this class do too many things? |
| **O** Open/Closed | Open for extension, closed for modification | Can I add features without changing existing code? |
| **L** Liskov Substitution | Subtypes must be substitutable for base types | Can I replace parent with child without breaking? |
| **I** Interface Segregation | No fat interfaces | Is client forced to implement unused methods? |
| **D** Dependency Inversion | Depend on abstractions, not concretions | Am I tightly coupled to implementation? |

### S - Single Responsibility
```typescript
// ❌ Bad: Multiple responsibilities
class User {
  validate() { } // Validation
  save() { }     // Persistence
  sendEmail() { } // Notification
}

// ✅ Good: Separated
class User { /* data only */ }
class UserValidator { validate(user) { } }
class UserRepository { save(user) { } }
class NotificationService { sendEmail(user) { } }
```

### O - Open/Closed
```typescript
// ❌ Bad: Must modify for new types
process(type) {
  if (type === 'A') { }
  else if (type === 'B') { } // Add else if each time
}

// ✅ Good: Extend via interface
interface Handler { handle() }
class HandlerA implements Handler { }
class HandlerB implements Handler { } // New - no modification
```

### L - Liskov Substitution
```typescript
// ❌ Bad: Subclass throws on parent method
class Bird { fly() { } }
class Penguin extends Bird { fly() { throw Error() } }

// ✅ Good: Different interfaces
interface FlyingBird { fly() }
interface SwimmingBird { swim() }
```

### I - Interface Segregation
```typescript
// ❌ Bad: Fat interface
interface Worker { work(); eat(); sleep(); code(); }
class Robot implements Worker { } // Must implement eat/sleep

// ✅ Good: Segregated
interface Workable { work() }
interface Eatable { eat() }
class Robot implements Workable { } // Only what needed
```

### D - Dependency Inversion
```typescript
// ❌ Bad: Concrete dependency
class Service {
  private db = new MySQLDatabase() // Tightly coupled
}

// ✅ Good: Abstract dependency
class Service {
  constructor(private db: Database) { } // Any DB works
}
```

## Domain-Driven Design (DDD)

### Core Concepts

| Concept | Purpose | Example |
|---------|---------|---------|
| **Entity** | Object with identity | User, Order (has ID) |
| **Value Object** | Object without identity | Email, Money (immutable) |
| **Aggregate** | Cluster of entities | Order + OrderItems |
| **Repository** | Data access abstraction | UserRepository |
| **Service** | Business logic without state | PaymentService |
| **Factory** | Complex object creation | OrderFactory |

### Bounded Context
- Each subdomain has its own model
- Same concept can mean different things
- Example: "User" in Auth vs "Customer" in Orders

### Aggregate Rules
1. Single entry point (Aggregate Root)
2. Enforce invariants
3. Transaction boundary
4. Load/save as unit

```typescript
// ✅ Good: Aggregate
class Order { // Aggregate Root
  private items: OrderItem[] = []

  addItem(item: OrderItem) {
    if (this.items.length >= 100) throw Error()
    this.items.push(item)
  }

  // Invariant: Total > 0
  getTotal() {
    return this.items.reduce((sum, item) => sum + item.price, 0)
  }
}
```

## Clean Code Principles

### Naming
- **Variables**: Descriptive nouns (`userEmail`, not `ue`)
- **Functions**: Verb + noun (`calculateTotal`, not `calc`)
- **Classes**: Nouns (`UserService`, not `UserManager`)
- **Booleans**: is/has/can (`isValid`, `hasAccess`)
- **Constants**: SCREAMING_SNAKE (`MAX_RETRIES`)

### Functions
- **Small**: ≤ 50 lines (ideal ≤ 30)
- **One thing**: Single responsibility
- **Few parameters**: ≤ 4 parameters
- **No side effects**: Pure when possible
- **Early returns**: Reduce nesting

```typescript
// ✅ Good: Clear, small, single purpose
function calculateDiscount(price: number, isVIP: boolean): number {
  if (price < 0) throw new Error('Invalid price')
  if (isVIP) return price * 0.9
  return price
}
```

### Code Organization
- **File size**: ≤ 500 lines (ideal ≤ 300)
- **Nesting**: ≤ 4 levels
- **Complexity**: Cyclomatic ≤ 10, Cognitive ≤ 15
- **Duplication**: < 3%

### Comments (See `.claude/AGENT_STANDARDS.md`)
- **Avoid**: Code should be self-documenting
- **Allowed**: JSDoc, complex business logic, workarounds

## Design Patterns (Common)

### Creational
| Pattern | Purpose | When |
|---------|---------|------|
| **Singleton** | One instance | Database connection, config |
| **Factory** | Flexible object creation | Multiple types, complex setup |
| **Builder** | Step-by-step construction | Many optional parameters |

### Structural
| Pattern | Purpose | When |
|---------|---------|------|
| **Adapter** | Interface compatibility | Integrate external library |
| **Decorator** | Add behavior dynamically | Extend without subclassing |
| **Facade** | Simplify complex system | Hide complexity |

### Behavioral
| Pattern | Purpose | When |
|---------|---------|------|
| **Strategy** | Interchangeable algorithms | Multiple ways to do something |
| **Observer** | Event notification | Pub/sub, reactive systems |
| **Command** | Encapsulate request | Undo/redo, queue operations |

### Pattern Example: Strategy
```typescript
interface SortStrategy {
  sort(data: number[]): number[]
}

class QuickSort implements SortStrategy {
  sort(data) { /* quicksort */ }
}

class MergeSort implements SortStrategy {
  sort(data) { /* mergesort */ }
}

class Sorter {
  constructor(private strategy: SortStrategy) {}
  sort(data) { return this.strategy.sort(data) }
}

// Usage
const sorter = new Sorter(new QuickSort())
sorter.sort([3, 1, 2])
```

## Anti-Patterns (Avoid)

| Anti-Pattern | Issue | Fix |
|--------------|-------|-----|
| **God Object** | Does everything | Split responsibilities (SRP) |
| **Anemic Domain** | No behavior, only getters/setters | Add business logic to entities |
| **Spaghetti Code** | No structure, high coupling | Apply SOLID, refactor |
| **Premature Optimization** | Optimize before profiling | Measure first |
| **Golden Hammer** | Same pattern everywhere | Choose appropriate pattern |
| **Magic Numbers** | Hardcoded values | Extract to constants |

## Architecture Layers

### Typical Structure
```
Presentation    → UI, Controllers, API endpoints
Application     → Use cases, orchestration
Domain          → Business logic, entities
Infrastructure  → Database, external services
```

### Dependency Rule
- **Outer depends on inner** (never reverse)
- Domain has NO dependencies
- Infrastructure depends on domain

## Code Quality Metrics

| Metric | Target | Tool |
|--------|--------|------|
| Cyclomatic Complexity | ≤ 10 | ESLint, SonarQube |
| Cognitive Complexity | ≤ 15 | SonarQube |
| Duplication | < 3% | SonarQube, jscpd |
| Test Coverage | 70-80% | Jest, Coverage.py |
| Function Length | ≤ 50 lines | ESLint |
| File Length | ≤ 500 lines | Manual review |

## When to Apply Patterns

**DO:**
- When complexity justifies pattern
- When team understands pattern
- When requirements clearly need it

**DON'T:**
- Over-engineer simple problems
- Use pattern for resume points
- Apply without understanding

**Rule:** Start simple, refactor to patterns when needed.

## Quick Reference

**Check your code:**
```
□ Each class has ONE responsibility? (SRP)
□ Can extend without modifying? (OCP)
□ Subtypes work like parent? (LSP)
□ No fat interfaces? (ISP)
□ Depend on abstractions? (DIP)
□ Functions < 50 lines?
□ Complexity < 10?
□ Duplication < 3%?
□ Meaningful names?
□ No magic numbers?
```

## Resources

- **Code standards**: `.claude/AGENT_STANDARDS.md`
- **Refactoring**: Martin Fowler - Refactoring
- **Clean Code**: Robert Martin - Clean Code
- **DDD**: Eric Evans - Domain-Driven Design
- **Patterns**: Gang of Four - Design Patterns

---

**Remember: Patterns are tools, not goals. Use when complexity justifies, not for resume.**
