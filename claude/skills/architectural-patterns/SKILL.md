---
name: architectural-patterns
description: SOLID, DDD, Clean Code, and design patterns reference. Use when designing architecture, refactoring code, reviewing for patterns, or discussing best practices.
---

# Architectural Principles & Patterns

## SOLID Principles

### S - Single Responsibility

> "A class/function should have ONE reason to change."

```typescript
// Bad: Multiple responsibilities
class User {
  validate(): boolean { /* validation */ }
  save(): void { /* persistence */ }
  sendWelcomeEmail(): void { /* notification */ }
}

// Good: Separated
class User { constructor(public id: string, public email: string) {} }
class UserValidator { validate(user: User): ValidationResult { } }
class UserRepository { save(user: User): Promise<void> { } }
class UserNotificationService { sendWelcomeEmail(user: User): Promise<void> { } }
```

### O - Open/Closed

> "Open for extension, closed for modification."

```typescript
// Bad: Must modify to add new payment type
class PaymentProcessor {
  process(type: string, amount: number): void {
    if (type === 'credit_card') { }
    else if (type === 'paypal') { }
    // Must add else if for each new type
  }
}

// Good: Extend without modification
interface PaymentMethod {
  process(amount: number): Promise<PaymentResult>
}
class CreditCardPayment implements PaymentMethod { }
class PayPalPayment implements PaymentMethod { }
class CryptoPayment implements PaymentMethod { } // New - no modification needed
```

### L - Liskov Substitution

> "Subclasses must be substitutable for their base class."

```typescript
// Bad: Penguin throws when Bird.fly() is called
class Bird { fly(): void { } }
class Penguin extends Bird { fly(): void { throw new Error() } }

// Good: Common interface, different implementations
interface Bird { move(): void }
class FlyingBird implements Bird { move(): void { this.fly() } }
class Penguin implements Bird { move(): void { this.swim() } }
```

### I - Interface Segregation

> "Clients shouldn't depend on interfaces they don't use."

```typescript
// Bad: Robot forced to implement eat() and sleep()
interface Worker { work(); eat(); sleep(); code(); }

// Good: Segregated interfaces
interface Workable { work(): void }
interface Eatable { eat(): void }
class Developer implements Workable, Eatable { }
class Robot implements Workable { } // Only what it needs
```

### D - Dependency Inversion

> "Depend on abstractions, not concrete implementations."

```typescript
// Bad: Depends on concrete MySQL
class UserService {
  private database = new MySQLDatabase()
}

// Good: Depends on abstraction
class UserService {
  constructor(private database: Database) {}
}
const service = new UserService(new MySQLDatabase()) // or PostgresDatabase
```

## Domain-Driven Design (DDD)

### Entities vs Value Objects

**Entity**: Has identity (ID), mutable, continuity over time
**Value Object**: No identity, immutable, equality by value

```typescript
// Entity
class User {
  constructor(public readonly id: UserId, private email: Email) {}
  changeEmail(newEmail: Email): void { this.email = newEmail }
}

// Value Object
class Money {
  constructor(public readonly amount: number, public readonly currency: Currency) {}
  add(other: Money): Money {
    return new Money(this.amount + other.amount, this.currency) // New object
  }
  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency
  }
}
```

### Aggregates

Cluster of objects treated as unit. Aggregate Root is only entry point.

```typescript
class Order { // Aggregate Root
  private items: OrderItem[] = []

  addItem(product: Product, quantity: number): void {
    // Validates and maintains invariants
    if (this.status !== OrderStatus.Draft) throw new Error()
    this.items.push(new OrderItem(product.id, product.price, quantity))
    this.recalculateTotal()
  }

  getItems(): readonly OrderItem[] {
    return [...this.items] // Defensive copy
  }
}
```

### Domain Events

Capture significant business events. Enable decoupled communication.

```typescript
class OrderConfirmed implements DomainEvent {
  constructor(
    public readonly aggregateId: string,
    public readonly customerId: string,
    public readonly total: Money,
    public readonly occurredAt = new Date()
  ) {}
}

// Handlers react to events
class SendOrderConfirmationEmail {
  async handle(event: OrderConfirmed): Promise<void> {
    await this.emailService.send({ /* ... */ })
  }
}
```

### Repositories

Abstraction over persistence. Interface in domain, implementation in infrastructure.

```typescript
// Domain layer
interface OrderRepository {
  save(order: Order): Promise<void>
  findById(id: string): Promise<Order | null>
}

// Infrastructure layer
class PostgresOrderRepository implements OrderRepository {
  async save(order: Order): Promise<void> { /* SQL */ }
}
```

## Clean Code - Functions

### One Function = One Thing

```typescript
// Bad: Does multiple things
function processUserRegistration(data) {
  // 1. Validation 2. Transformation 3. Persistence 4. Notification 5. Logging
}

// Good: One responsibility each
function registerUser(command) {
  const validated = validateUserData(command)
  const user = createUser(validated)
  await saveUser(user)
  await sendWelcomeEmail(user)
}
```

### Single Abstraction Level

```typescript
// Bad: Mixed levels
function processOrder(orderId) {
  const order = orderRepository.findById(orderId)
  if (order.status === 'pending') {
    let total = 0
    for (let i = 0; i < order.items.length; i++) { // Low-level
      total += order.items[i].price * order.items[i].quantity
    }
    order.confirm() // High-level
  }
}

// Good: Same level
function processOrder(orderId) {
  const order = loadOrder(orderId)
  if (order.isPending()) {
    calculateTotal(order)
    confirmOrder(order)
    notifyCustomer(order)
  }
}
```

### Max 3 Parameters

```typescript
// Bad: Too many params
function createUser(email, password, firstName, lastName, age, country, phone) {}

// Good: Object parameter
interface CreateUserCommand {
  email: string; password: string; firstName: string; /* ... */
}
function createUser(command: CreateUserCommand) {}
```

### Command Query Separation (CQS)

- **Command**: Modifies state, returns void
- **Query**: Returns value, no modification

```typescript
// Bad: Mixed
function getUserAndIncrementAccessCount(id): User {
  const user = db.find(id)
  user.accessCount++ // Modification
  return user // Return
}

// Good: Separated
function getUser(id): User { return db.find(id) }
function incrementUserAccessCount(id): void { /* ... */ }
```

## Error Handling

### Prefer Exceptions

```typescript
// Bad: Error codes
function deleteUser(id): number {
  if (!user) return ERROR_NOT_FOUND
  if (user.hasOrders()) return ERROR_HAS_ORDERS
  return SUCCESS
}

// Good: Exceptions
function deleteUser(id): void {
  const user = findUserOrThrow(id)
  if (user.hasOrders()) throw new UserHasOrdersError(id)
  database.delete(user)
}
```

### Don't Return Null

```typescript
// Bad
function findUser(id): User | null { }

// Good: Throw if required
function findUserOrThrow(id): User {
  const user = db.find(id)
  if (!user) throw new UserNotFoundError(id)
  return user
}

// Good: Special case object
function findUserOrGuest(id): User {
  return db.find(id) ?? new GuestUser()
}
```

### Rich Context in Exceptions

```typescript
// Bad
throw new Error('Invalid amount')

// Good
throw new InvalidAmountError(amount, min, max)
// "Amount 150 is invalid. Must be between 0 and 100"
```

## Design Patterns

### Factory

```typescript
class PaymentMethodFactory {
  create(type: string, config: unknown): PaymentMethod {
    switch (type) {
      case 'credit_card': return new CreditCardPayment(config)
      case 'paypal': return new PayPalPayment(config)
      default: throw new Error(`Unknown: ${type}`)
    }
  }
}
```

### Builder

```typescript
const query = new QueryBuilder()
  .select('id', 'name')
  .from('users')
  .where('age > 18')
  .orderBy('name')
  .limit(10)
  .build()
```

### Strategy

```typescript
interface DiscountStrategy {
  calculate(amount: Money): Money
}
class PercentageDiscount implements DiscountStrategy { }
class FixedDiscount implements DiscountStrategy { }

class PriceCalculator {
  constructor(private strategy: DiscountStrategy) {}
  calculate(price: Money): Money {
    return this.strategy.calculate(price)
  }
}
```

### Observer

```typescript
interface Observer<T> { update(data: T): void }

class EventBus<T> {
  private observers: Observer<T>[] = []
  attach(o: Observer<T>): void { this.observers.push(o) }
  notify(data: T): void { this.observers.forEach(o => o.update(data)) }
}
```

## Architectural Patterns

### Hexagonal (Ports & Adapters)

```
[Adapters (Infrastructure)] → [Ports (Domain Interfaces)] → [Domain Core]
```

```typescript
// Port (Domain)
interface PaymentGateway {
  charge(amount: Money): Promise<PaymentResult>
}

// Adapter (Infrastructure)
class StripePaymentGateway implements PaymentGateway {
  async charge(amount: Money): Promise<PaymentResult> { /* Stripe API */ }
}
```

### CQRS

Separate read and write models.

```typescript
// Write (Command)
class CreateOrderCommand {
  async execute(): Promise<OrderId> {
    const order = Order.create(this.items)
    await orderRepository.save(order)
    return order.id
  }
}

// Read (Query) - optimized for queries
class GetOrderDetailsQuery {
  async execute(): Promise<OrderDetailsDTO> {
    return database.query(`SELECT ... JOIN ...`) // Denormalized
  }
}
```

## General Principles

### Composition > Inheritance

```typescript
// Bad: Rigid inheritance
class FlyingAnimal extends Animal { }
class SwimmingAnimal extends Animal { }
// Can't have animal that flies AND swims

// Good: Composition
class Animal {
  constructor(private moveBehavior: Movable) {}
  move(): void { this.moveBehavior.move() }
}
const duck = new Animal(new FlyingBehavior())
duck.setMoveBehavior(new SwimmingBehavior()) // Flexible
```

### Tell, Don't Ask

```typescript
// Bad: Ask state, then act
if (cart.items.length === 0) throw new Error()
let total = 0
for (const item of cart.items) { total += item.price }

// Good: Tell what to do
const result = cart.checkout() // Cart handles internally
```

### Fail Fast

```typescript
// Validate early
class Email {
  constructor(value: string) {
    if (!value.includes('@')) throw new Error('Invalid email')
    // Email is ALWAYS valid after construction
  }
}
```

## Validation Checklist

```
SOLID
[] SRP: One responsibility per class/function
[] OCP: Extend without modifying
[] LSP: Substitutable subclasses
[] ISP: Small, specific interfaces
[] DIP: Depend on abstractions

DDD
[] Ubiquitous language in code
[] Entities vs Value Objects distinguished
[] Aggregates with clear roots
[] Domain events for significant actions
[] Repositories abstract persistence

CLEAN CODE
[] Functions do ONE thing
[] Single abstraction level per function
[] ≤ 3 parameters (else use object)
[] No hidden side effects
[] CQS respected

ERROR HANDLING
[] Exceptions over error codes
[] Domain vs technical exceptions separated
[] No null returns (throw or special case)
[] Rich context in exceptions

CODE SMELLS ABSENT
[] No long methods (> 30 lines)
[] No large classes
[] No feature envy
[] No data clumps
[] No primitive obsession
```
