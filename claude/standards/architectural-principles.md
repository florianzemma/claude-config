# Principes Architecturaux Fondamentaux

**⚠️ RÈGLE ABSOLUE : Ces principes sont issus des meilleures pratiques éprouvées de l'industrie et sont NON NÉGOCIABLES.**

Ce document définit les principes architecturaux et de design que **TOUT** code doit respecter.

---

## Table des Matières

1. [Principes SOLID](#1-principes-solid)
2. [Design Orienté Domaine (DDD)](#2-design-orienté-domaine-ddd)
3. [Test-Driven Development (TDD)](#3-test-driven-development-tdd)
4. [Clean Code - Fonctions et Méthodes](#4-clean-code---fonctions-et-méthodes)
5. [Gestion des Erreurs](#5-gestion-des-erreurs)
6. [Refactoring - Code Smells](#6-refactoring---code-smells)
7. [Design Patterns](#7-design-patterns)
8. [Patterns Architecturaux](#8-patterns-architecturaux)
9. [Principes Généraux](#9-principes-généraux)

---

## 1. Principes SOLID

### S - Single Responsibility Principle (SRP)

> "Une classe/fonction/module doit avoir UNE SEULE raison de changer."

**Principe :**
- Chaque unité de code (classe, fonction, module) ne doit avoir qu'UNE responsabilité
- Si vous pouvez décrire ce que fait le code avec "ET", il viole probablement SRP

**Exemples :**

```typescript
// ❌ MAUVAIS : Plusieurs responsabilités
class User {
  constructor(public name: string, public email: string) {}

  // Responsabilité 1 : Logique métier
  validate(): boolean {
    return this.email.includes('@')
  }

  // Responsabilité 2 : Persistance
  save(): void {
    database.save(this)
  }

  // Responsabilité 3 : Notification
  sendWelcomeEmail(): void {
    emailService.send(this.email, 'Welcome!')
  }
}

// ✅ BON : Responsabilités séparées
class User {
  constructor(
    public readonly id: string,
    public readonly email: string,
    public readonly name: string
  ) {}
}

class UserValidator {
  validate(user: User): ValidationResult {
    const errors: string[] = []
    if (!user.email.includes('@')) {
      errors.push('Invalid email format')
    }
    return { isValid: errors.length === 0, errors }
  }
}

class UserRepository {
  async save(user: User): Promise<void> {
    await this.database.insert('users', user)
  }

  async findById(id: string): Promise<User | null> {
    return this.database.findOne('users', { id })
  }
}

class UserNotificationService {
  async sendWelcomeEmail(user: User): Promise<void> {
    await this.emailService.send({
      to: user.email,
      subject: 'Welcome!',
      template: 'welcome',
      data: { name: user.name }
    })
  }
}
```

### O - Open/Closed Principle (OCP)

> "Les entités doivent être ouvertes à l'extension, mais fermées à la modification."

**Principe :**
- Ajouter de nouvelles fonctionnalités sans modifier le code existant
- Utiliser l'abstraction (interfaces, classes abstraites) et la composition

**Exemples :**

```typescript
// ❌ MAUVAIS : Modification nécessaire pour ajouter un type
class PaymentProcessor {
  processPayment(type: string, amount: number): void {
    if (type === 'credit_card') {
      // Process credit card
    } else if (type === 'paypal') {
      // Process PayPal
    } else if (type === 'crypto') { // Modification nécessaire
      // Process crypto
    }
  }
}

// ✅ BON : Extension sans modification
interface PaymentMethod {
  process(amount: number): Promise<PaymentResult>
}

class CreditCardPayment implements PaymentMethod {
  async process(amount: number): Promise<PaymentResult> {
    // Process credit card
    return { success: true, transactionId: '...' }
  }
}

class PayPalPayment implements PaymentMethod {
  async process(amount: number): Promise<PaymentResult> {
    // Process PayPal
    return { success: true, transactionId: '...' }
  }
}

// Nouveau type ajouté SANS modifier PaymentProcessor
class CryptoPayment implements PaymentMethod {
  async process(amount: number): Promise<PaymentResult> {
    // Process crypto
    return { success: true, transactionId: '...' }
  }
}

class PaymentProcessor {
  constructor(private paymentMethod: PaymentMethod) {}

  async processPayment(amount: number): Promise<PaymentResult> {
    return this.paymentMethod.process(amount)
  }
}
```

### L - Liskov Substitution Principle (LSP)

> "Les objets d'une classe dérivée doivent pouvoir remplacer les objets de la classe de base sans altérer le comportement du programme."

**Principe :**
- Les sous-classes doivent respecter le contrat de la classe parente
- Pas de surprises lors du remplacement

**Exemples :**

```typescript
// ❌ MAUVAIS : Violation de LSP
class Bird {
  fly(): void {
    console.log('Flying')
  }
}

class Penguin extends Bird {
  fly(): void {
    throw new Error('Penguins cannot fly!') // Violation
  }
}

function makeBirdFly(bird: Bird): void {
  bird.fly() // Crash si Penguin
}

// ✅ BON : Respect de LSP
interface Bird {
  move(): void
}

class FlyingBird implements Bird {
  move(): void {
    this.fly()
  }

  private fly(): void {
    console.log('Flying')
  }
}

class Penguin implements Bird {
  move(): void {
    this.swim()
  }

  private swim(): void {
    console.log('Swimming')
  }
}

function makeBirdMove(bird: Bird): void {
  bird.move() // Fonctionne pour tous les oiseaux
}
```

### I - Interface Segregation Principle (ISP)

> "Les clients ne doivent pas être forcés de dépendre d'interfaces qu'ils n'utilisent pas."

**Principe :**
- Interfaces petites et spécifiques plutôt que grosses et générales
- Un client ne doit implémenter que ce dont il a besoin

**Exemples :**

```typescript
// ❌ MAUVAIS : Interface trop grosse
interface Worker {
  work(): void
  eat(): void
  sleep(): void
  code(): void
  attendMeetings(): void
}

class Developer implements Worker {
  work(): void { /* code */ }
  eat(): void { /* ok */ }
  sleep(): void { /* ok */ }
  code(): void { /* ok */ }
  attendMeetings(): void { /* ok */ }
}

class Robot implements Worker {
  work(): void { /* ok */ }
  eat(): void { throw new Error('Robots don\'t eat') } // Forcé d'implémenter
  sleep(): void { throw new Error('Robots don\'t sleep') } // Forcé d'implémenter
  code(): void { /* ok */ }
  attendMeetings(): void { throw new Error('Robots don\'t attend') } // Forcé d'implémenter
}

// ✅ BON : Interfaces ségrégées
interface Workable {
  work(): void
}

interface Eatable {
  eat(): void
}

interface Sleepable {
  sleep(): void
}

interface Codable {
  code(): void
}

interface MeetingAttendable {
  attendMeetings(): void
}

class Developer implements Workable, Eatable, Sleepable, Codable, MeetingAttendable {
  work(): void { /* code */ }
  eat(): void { /* ok */ }
  sleep(): void { /* ok */ }
  code(): void { /* ok */ }
  attendMeetings(): void { /* ok */ }
}

class Robot implements Workable, Codable {
  work(): void { /* ok */ }
  code(): void { /* ok */ }
  // N'implémente QUE ce dont il a besoin
}
```

### D - Dependency Inversion Principle (DIP)

> "Les modules de haut niveau ne doivent pas dépendre des modules de bas niveau. Les deux doivent dépendre d'abstractions."

**Principe :**
- Dépendre d'interfaces/abstractions, pas d'implémentations concrètes
- Injection de dépendances

**Exemples :**

```typescript
// ❌ MAUVAIS : Dépendance directe sur implémentation
class UserService {
  private database = new MySQLDatabase() // Dépendance concrète

  async getUser(id: string): Promise<User> {
    return this.database.query(`SELECT * FROM users WHERE id = ${id}`)
  }
}

// ✅ BON : Dépendance sur abstraction
interface Database {
  query<T>(sql: string, params?: unknown[]): Promise<T>
}

class MySQLDatabase implements Database {
  async query<T>(sql: string, params?: unknown[]): Promise<T> {
    // MySQL implementation
    return {} as T
  }
}

class PostgreSQLDatabase implements Database {
  async query<T>(sql: string, params?: unknown[]): Promise<T> {
    // PostgreSQL implementation
    return {} as T
  }
}

class UserService {
  constructor(private database: Database) {} // Injection d'abstraction

  async getUser(id: string): Promise<User> {
    return this.database.query<User>(
      'SELECT * FROM users WHERE id = $1',
      [id]
    )
  }
}

// Usage
const mysqlDb = new MySQLDatabase()
const userService = new UserService(mysqlDb) // Facile de changer de DB
```

---

## 2. Design Orienté Domaine (DDD)

### 2.1 Ubiquitous Language (Langage Omniprésent)

**Principe :**
- Utiliser le même vocabulaire métier dans le code et les discussions
- Le code doit refléter exactement la terminologie du domaine métier

**Exemples :**

```typescript
// ❌ MAUVAIS : Vocabulaire technique, pas métier
class DataObject {
  id: string
  amt: number
  stat: string

  proc(): void {
    if (this.stat === 'pending') {
      this.stat = 'done'
    }
  }
}

// ✅ BON : Ubiquitous Language
class Order {
  constructor(
    public readonly orderId: string,
    private amount: Money,
    private status: OrderStatus
  ) {}

  approve(): void {
    if (this.status === OrderStatus.Pending) {
      this.status = OrderStatus.Approved
    }
  }

  reject(reason: string): void {
    this.status = OrderStatus.Rejected
    // Emit domain event
    DomainEvents.raise(new OrderRejected(this.orderId, reason))
  }
}

enum OrderStatus {
  Pending = 'pending',
  Approved = 'approved',
  Rejected = 'rejected'
}
```

### 2.2 Entities vs Value Objects

**Entities :**
- Identité unique (ID)
- Mutable
- Continuité dans le temps

**Value Objects :**
- Pas d'identité (égalité par valeur)
- Immutable
- Interchangeables

**Exemples :**

```typescript
// ✅ Entity : Identité unique
class User {
  constructor(
    public readonly id: UserId, // Identity
    private email: Email,
    private name: string
  ) {}

  changeEmail(newEmail: Email): void {
    this.email = newEmail
    // Toujours le même User (même ID)
  }
}

// ✅ Value Object : Immutable, pas d'ID
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: Currency
  ) {
    if (amount < 0) {
      throw new Error('Amount cannot be negative')
    }
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies')
    }
    return new Money(this.amount + other.amount, this.currency) // Nouveau objet
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency
  }
}

class Email {
  constructor(public readonly value: string) {
    if (!value.includes('@')) {
      throw new Error('Invalid email format')
    }
  }

  equals(other: Email): boolean {
    return this.value === other.value
  }
}

enum Currency {
  USD = 'USD',
  EUR = 'EUR',
  GBP = 'GBP'
}
```

### 2.3 Aggregates et Aggregate Roots

**Principe :**
- Un Aggregate est un cluster d'objets traités comme une unité
- L'Aggregate Root est le seul point d'entrée vers l'aggregate
- Garantit la cohérence des invariants

**Exemples :**

```typescript
// ✅ Aggregate : Order avec OrderItems
class Order {
  private items: OrderItem[] = []
  private _status: OrderStatus = OrderStatus.Draft

  constructor(
    public readonly orderId: string,
    private customerId: string
  ) {}

  // Aggregate Root : seul point d'entrée pour modifier les items
  addItem(product: Product, quantity: number): void {
    if (this._status !== OrderStatus.Draft) {
      throw new Error('Cannot modify confirmed order')
    }

    const existingItem = this.items.find(i => i.productId === product.id)
    if (existingItem) {
      existingItem.increaseQuantity(quantity)
    } else {
      this.items.push(new OrderItem(product.id, product.price, quantity))
    }

    this.recalculateTotal() // Maintient les invariants
  }

  removeItem(productId: string): void {
    if (this._status !== OrderStatus.Draft) {
      throw new Error('Cannot modify confirmed order')
    }

    this.items = this.items.filter(i => i.productId !== productId)
    this.recalculateTotal()
  }

  confirm(): void {
    if (this.items.length === 0) {
      throw new Error('Cannot confirm empty order')
    }

    this._status = OrderStatus.Confirmed
    DomainEvents.raise(new OrderConfirmed(this.orderId))
  }

  private recalculateTotal(): void {
    this.total = this.items.reduce((sum, item) => sum + item.subtotal(), 0)
  }

  // Pas d'accès direct aux items depuis l'extérieur
  getItems(): readonly OrderItem[] {
    return [...this.items] // Copie défensive
  }
}

class OrderItem {
  constructor(
    public readonly productId: string,
    public readonly price: Money,
    private quantity: number
  ) {
    if (quantity <= 0) {
      throw new Error('Quantity must be positive')
    }
  }

  increaseQuantity(amount: number): void {
    this.quantity += amount
  }

  subtotal(): number {
    return this.price.amount * this.quantity
  }
}
```

### 2.4 Domain Events

**Principe :**
- Capturer les événements significatifs du domaine
- Communication découplée entre aggregates
- Historique des actions

**Exemples :**

```typescript
// ✅ Domain Events
interface DomainEvent {
  occurredAt: Date
  aggregateId: string
}

class OrderConfirmed implements DomainEvent {
  public readonly occurredAt = new Date()

  constructor(
    public readonly aggregateId: string,
    public readonly customerId: string,
    public readonly total: Money
  ) {}
}

class OrderShipped implements DomainEvent {
  public readonly occurredAt = new Date()

  constructor(
    public readonly aggregateId: string,
    public readonly trackingNumber: string
  ) {}
}

// Event Handler
class SendOrderConfirmationEmail {
  async handle(event: OrderConfirmed): Promise<void> {
    const customer = await this.customerRepository.findById(event.customerId)
    await this.emailService.send({
      to: customer.email,
      subject: 'Order Confirmed',
      template: 'order-confirmation',
      data: { orderId: event.aggregateId, total: event.total }
    })
  }
}

class UpdateInventory {
  async handle(event: OrderConfirmed): Promise<void> {
    const order = await this.orderRepository.findById(event.aggregateId)
    for (const item of order.getItems()) {
      await this.inventoryService.reduceStock(item.productId, item.quantity)
    }
  }
}
```

### 2.5 Repositories

**Principe :**
- Abstraction sur la persistance des données
- Interface métier, pas technique
- Un Repository par Aggregate Root

**Exemples :**

```typescript
// ✅ Repository Interface (Domain Layer)
interface OrderRepository {
  save(order: Order): Promise<void>
  findById(orderId: string): Promise<Order | null>
  findByCustomerId(customerId: string): Promise<Order[]>
  findPendingOrders(): Promise<Order[]>
}

// ✅ Implementation (Infrastructure Layer)
class PostgresOrderRepository implements OrderRepository {
  constructor(private database: Database) {}

  async save(order: Order): Promise<void> {
    await this.database.transaction(async (trx) => {
      // Sauvegarder l'aggregate complet
      await trx('orders').insert({
        order_id: order.orderId,
        customer_id: order.customerId,
        status: order.status,
        total: order.total
      })

      for (const item of order.getItems()) {
        await trx('order_items').insert({
          order_id: order.orderId,
          product_id: item.productId,
          quantity: item.quantity,
          price: item.price.amount
        })
      }
    })
  }

  async findById(orderId: string): Promise<Order | null> {
    const orderData = await this.database
      .select('*')
      .from('orders')
      .where({ order_id: orderId })
      .first()

    if (!orderData) return null

    const items = await this.database
      .select('*')
      .from('order_items')
      .where({ order_id: orderId })

    // Reconstruire l'aggregate depuis les données
    return this.reconstitute(orderData, items)
  }

  private reconstitute(orderData: unknown, itemsData: unknown[]): Order {
    // Mapper les données DB vers domain objects
    // ...
  }
}
```

### 2.6 Domain Services vs Application Services

**Domain Service :**
- Logique métier qui ne rentre pas dans une Entity/Value Object
- Opérations impliquant plusieurs aggregates
- Pas de dépendances techniques

**Application Service :**
- Orchestration des use cases
- Transaction management
- Coordination des domain services
- Peut avoir des dépendances techniques

**Exemples :**

```typescript
// ✅ Domain Service : Logique métier pure
class PricingService {
  calculateOrderPrice(order: Order, customer: Customer): Money {
    let total = order.calculateSubtotal()

    // Règle métier : clients premium ont 10% de réduction
    if (customer.isPremium()) {
      total = total.applyDiscount(0.10)
    }

    // Règle métier : livraison gratuite > 100€
    if (total.amount < 100) {
      total = total.add(new Money(10, total.currency)) // Frais de port
    }

    return total
  }
}

// ✅ Application Service : Orchestration use case
class PlaceOrderService {
  constructor(
    private orderRepository: OrderRepository,
    private customerRepository: CustomerRepository,
    private pricingService: PricingService,
    private paymentGateway: PaymentGateway,
    private eventBus: EventBus
  ) {}

  async execute(command: PlaceOrderCommand): Promise<PlaceOrderResult> {
    // 1. Charger les données
    const customer = await this.customerRepository.findById(command.customerId)
    if (!customer) {
      throw new CustomerNotFoundError(command.customerId)
    }

    // 2. Créer l'aggregate
    const order = Order.create(command.customerId, command.items)

    // 3. Appliquer règles métier (Domain Service)
    const total = this.pricingService.calculateOrderPrice(order, customer)
    order.setTotal(total)

    // 4. Valider et confirmer
    order.confirm()

    // 5. Traiter paiement (Infrastructure)
    const paymentResult = await this.paymentGateway.charge(
      customer.paymentMethod,
      total
    )

    if (!paymentResult.success) {
      throw new PaymentFailedError(paymentResult.reason)
    }

    order.markAsPaid(paymentResult.transactionId)

    // 6. Persister
    await this.orderRepository.save(order)

    // 7. Publier events
    await this.eventBus.publish(order.getDomainEvents())

    return {
      orderId: order.orderId,
      total: total,
      paymentTransactionId: paymentResult.transactionId
    }
  }
}
```

### 2.7 Bounded Contexts et Anti-Corruption Layer

**Principe :**
- Isoler les modèles métier différents
- Éviter la pollution d'un contexte par un autre
- Traduction entre contextes

**Exemples :**

```typescript
// Context 1 : Sales (ventes)
namespace Sales {
  export class Customer {
    constructor(
      public readonly customerId: string,
      public readonly email: string,
      public readonly creditLimit: Money
    ) {}
  }

  export class Order {
    constructor(
      public readonly orderId: string,
      public readonly customerId: string,
      public readonly items: OrderItem[]
    ) {}
  }
}

// Context 2 : Shipping (livraison)
namespace Shipping {
  export class Recipient {
    constructor(
      public readonly name: string,
      public readonly address: Address,
      public readonly phone: string
    ) {}
  }

  export class Shipment {
    constructor(
      public readonly shipmentId: string,
      public readonly recipient: Recipient,
      public readonly packages: Package[]
    ) {}
  }
}

// ✅ Anti-Corruption Layer : Traduction entre contextes
class ShippingAdapter {
  // Traduit Order (Sales) -> Shipment (Shipping)
  toShipment(order: Sales.Order, customer: Sales.Customer): Shipping.Shipment {
    const recipient = new Shipping.Recipient(
      customer.name,
      customer.shippingAddress,
      customer.phone
    )

    const packages = order.items.map(item =>
      new Shipping.Package(item.productId, item.quantity, item.weight)
    )

    return new Shipping.Shipment(
      this.generateShipmentId(order.orderId),
      recipient,
      packages
    )
  }

  private generateShipmentId(orderId: string): string {
    return `SHIP-${orderId}`
  }
}

// Usage
class OrderFulfillmentService {
  constructor(
    private shippingAdapter: ShippingAdapter,
    private shippingService: Shipping.ShippingService
  ) {}

  async fulfillOrder(order: Sales.Order, customer: Sales.Customer): Promise<void> {
    // Traduire via Anti-Corruption Layer
    const shipment = this.shippingAdapter.toShipment(order, customer)

    // Utiliser le service du contexte Shipping
    await this.shippingService.createShipment(shipment)
  }
}
```

---

## 3. Test-Driven Development (TDD)

### 3.1 Red-Green-Refactor Cycle

**Principe :**
1. **RED** : Écrire un test qui échoue
2. **GREEN** : Écrire le minimum de code pour le faire passer
3. **REFACTOR** : Améliorer le code sans changer le comportement

**Exemple :**

```typescript
// ÉTAPE 1 : RED - Écrire le test d'abord
describe('Money', () => {
  it('should add two money amounts with same currency', () => {
    const fiveEuros = new Money(5, Currency.EUR)
    const tenEuros = new Money(10, Currency.EUR)

    const result = fiveEuros.add(tenEuros)

    expect(result.amount).toBe(15)
    expect(result.currency).toBe(Currency.EUR)
  })
})

// ❌ Test échoue : Money n'existe pas encore

// ÉTAPE 2 : GREEN - Implémenter le minimum
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: Currency
  ) {}

  add(other: Money): Money {
    return new Money(this.amount + other.amount, this.currency)
  }
}

// ✅ Test passe

// ÉTAPE 3 : REFACTOR - Ajouter validation
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: Currency
  ) {
    if (amount < 0) {
      throw new Error('Amount cannot be negative')
    }
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies')
    }
    return new Money(this.amount + other.amount, this.currency)
  }
}

// Ajouter tests pour les cas d'erreur
describe('Money', () => {
  it('should throw when adding different currencies', () => {
    const fiveEuros = new Money(5, Currency.EUR)
    const tenDollars = new Money(10, Currency.USD)

    expect(() => fiveEuros.add(tenDollars)).toThrow('Cannot add different currencies')
  })

  it('should throw when amount is negative', () => {
    expect(() => new Money(-5, Currency.EUR)).toThrow('Amount cannot be negative')
  })
})
```

### 3.2 Principes de Tests

**Tests doivent être :**
- **FIRST** :
  - **F**ast : Rapides à exécuter
  - **I**ndependent : Indépendants les uns des autres
  - **R**epeatable : Reproductibles dans n'importe quel environnement
  - **S**elf-Validating : Passe ou échoue clairement (pas d'interprétation manuelle)
  - **T**imely : Écrits au bon moment (avant le code en TDD)

**Exemples :**

```typescript
// ✅ BON : Tests indépendants
describe('UserService', () => {
  let userService: UserService
  let userRepository: MockUserRepository

  beforeEach(() => {
    // Setup frais pour chaque test
    userRepository = new MockUserRepository()
    userService = new UserService(userRepository)
  })

  it('should create a new user', async () => {
    const userData = { email: 'test@test.com', name: 'Test' }

    const user = await userService.createUser(userData)

    expect(user.email).toBe(userData.email)
    expect(user.name).toBe(userData.name)
  })

  it('should throw when email already exists', async () => {
    userRepository.setExistingEmails(['test@test.com'])

    await expect(
      userService.createUser({ email: 'test@test.com', name: 'Test' })
    ).rejects.toThrow('Email already exists')
  })
})

// ❌ MAUVAIS : Tests dépendants
describe('UserService', () => {
  it('should create a user and then find it', async () => {
    // Test fait 2 choses : création ET recherche
    const user = await userService.createUser({ email: 'test@test.com' })
    const found = await userService.findById(user.id)

    expect(found).toEqual(user)
    // Si création échoue, recherche échoue aussi
    // Ne teste pas réellement findById
  })
})
```

### 3.3 Test Doubles

**Types :**
- **Stub** : Retourne des données prédéfinies
- **Mock** : Vérifie que des méthodes sont appelées
- **Spy** : Enregistre les appels
- **Fake** : Implémentation simplifiée (ex: in-memory DB)

**Exemples :**

```typescript
// ✅ Stub : Retourne des données
class StubUserRepository implements UserRepository {
  async findById(id: string): Promise<User> {
    return new User(id, 'test@test.com', 'Test User')
  }
}

// ✅ Mock : Vérifie appels
class MockEmailService implements EmailService {
  private sentEmails: Email[] = []

  async send(email: Email): Promise<void> {
    this.sentEmails.push(email)
  }

  verifySent(to: string, subject: string): void {
    const found = this.sentEmails.find(e => e.to === to && e.subject === subject)
    if (!found) {
      throw new Error(`Expected email to ${to} with subject "${subject}" was not sent`)
    }
  }
}

// Usage
it('should send welcome email when user is created', async () => {
  const emailService = new MockEmailService()
  const userService = new UserService(userRepository, emailService)

  await userService.createUser({ email: 'test@test.com', name: 'Test' })

  emailService.verifySent('test@test.com', 'Welcome!')
})
```

---

## 4. Clean Code - Fonctions et Méthodes

### 4.1 Fonctions Doivent Faire UNE Chose

**Principe :**
> "Les fonctions doivent faire une chose, la faire bien, et ne faire que ça."

**Exemples :**

```typescript
// ❌ MAUVAIS : Fonction fait plusieurs choses
function processUserRegistration(userData: unknown): void {
  // 1. Validation
  if (!userData.email || !userData.email.includes('@')) {
    throw new Error('Invalid email')
  }

  // 2. Transformation
  const user = {
    id: generateId(),
    email: userData.email.toLowerCase(),
    name: userData.name.trim(),
    createdAt: new Date()
  }

  // 3. Persistance
  database.insert('users', user)

  // 4. Notification
  emailService.send(user.email, 'Welcome!')

  // 5. Logging
  logger.info(`User ${user.id} registered`)
}

// ✅ BON : Une fonction = une responsabilité
function registerUser(command: RegisterUserCommand): Promise<User> {
  const validatedData = validateUserData(command)
  const user = createUser(validatedData)
  await saveUser(user)
  await sendWelcomeEmail(user)
  logUserRegistration(user)
  return user
}

function validateUserData(command: RegisterUserCommand): ValidatedUserData {
  const errors = []
  if (!command.email.includes('@')) {
    errors.push('Invalid email')
  }
  if (errors.length > 0) {
    throw new ValidationError(errors)
  }
  return {
    email: command.email.toLowerCase(),
    name: command.name.trim()
  }
}

function createUser(data: ValidatedUserData): User {
  return new User(
    generateUserId(),
    data.email,
    data.name,
    new Date()
  )
}

async function saveUser(user: User): Promise<void> {
  await userRepository.save(user)
}

async function sendWelcomeEmail(user: User): Promise<void> {
  await emailService.send(user.email, 'Welcome!')
}

function logUserRegistration(user: User): void {
  logger.info('User registered', { userId: user.id, email: user.email })
}
```

### 4.2 Niveau d'Abstraction Unique par Fonction

**Principe :**
- Toutes les instructions d'une fonction doivent être au même niveau d'abstraction
- Éviter de mélanger haut niveau et détails d'implémentation

**Exemples :**

```typescript
// ❌ MAUVAIS : Niveaux d'abstraction mélangés
function processOrder(orderId: string): void {
  // Haut niveau
  const order = orderRepository.findById(orderId)

  // Détails bas niveau mélangés
  if (order.status === 'pending') {
    const total = 0
    for (let i = 0; i < order.items.length; i++) {
      total += order.items[i].price * order.items[i].quantity
    }
    order.total = total

    // Retour haut niveau
    order.confirm()
    emailService.send(order.customerEmail, 'Order confirmed')
  }
}

// ✅ BON : Niveau d'abstraction unique
function processOrder(orderId: string): void {
  const order = loadOrder(orderId)

  if (order.isPending()) {
    calculateTotal(order)
    confirmOrder(order)
    notifyCustomer(order)
  }
}

function loadOrder(orderId: string): Order {
  return orderRepository.findById(orderId)
}

function calculateTotal(order: Order): void {
  const total = order.items.reduce((sum, item) => sum + item.subtotal(), 0)
  order.setTotal(total)
}

function confirmOrder(order: Order): void {
  order.confirm()
}

function notifyCustomer(order: Order): void {
  emailService.send(order.customerEmail, 'Order confirmed')
}
```

### 4.3 Paramètres de Fonction

**Principe :**
- Idéal : 0 paramètre (niladic)
- Acceptable : 1-2 paramètres (monadic, dyadic)
- À éviter : 3+ paramètres (triadic, polyadic)
- Solution : Regrouper en objet

**Exemples :**

```typescript
// ❌ MAUVAIS : Trop de paramètres
function createUser(
  email: string,
  password: string,
  firstName: string,
  lastName: string,
  age: number,
  country: string,
  phoneNumber: string
): User {
  // ...
}

// ✅ BON : Paramètre objet
interface CreateUserCommand {
  email: string
  password: string
  firstName: string
  lastName: string
  age: number
  country: string
  phoneNumber: string
}

function createUser(command: CreateUserCommand): User {
  // ...
}

// ✅ ENCORE MIEUX : Value Objects
function createUser(
  credentials: UserCredentials,
  profile: UserProfile
): User {
  // ...
}

class UserCredentials {
  constructor(
    public readonly email: Email,
    public readonly password: Password
  ) {}
}

class UserProfile {
  constructor(
    public readonly name: PersonName,
    public readonly age: Age,
    public readonly contactInfo: ContactInfo
  ) {}
}
```

### 4.4 Pas d'Effets de Bord (Side Effects)

**Principe :**
- Une fonction ne doit pas modifier l'état en dehors de sa portée
- Si modification nécessaire, le nom doit l'indiquer

**Exemples :**

```typescript
// ❌ MAUVAIS : Effet de bord caché
function checkPassword(password: string): boolean {
  const isValid = password.length >= 8

  // Effet de bord caché !
  if (isValid) {
    session.initialize() // Modification d'état globale
  }

  return isValid
}

// ✅ BON : Séparation claire
function isPasswordValid(password: string): boolean {
  return password.length >= 8 // Pure function, pas d'effet de bord
}

function loginUser(username: string, password: string): LoginResult {
  if (!isPasswordValid(password)) {
    return { success: false, reason: 'Invalid password' }
  }

  // Effet de bord explicite dans le nom
  session.initialize()
  return { success: true }
}
```

### 4.5 Command Query Separation (CQS)

**Principe :**
- **Command** : Modifie l'état, ne retourne rien (void)
- **Query** : Retourne une valeur, ne modifie rien
- Ne jamais mélanger les deux

**Exemples :**

```typescript
// ❌ MAUVAIS : Mélange Command et Query
function getUserAndIncrementAccessCount(userId: string): User {
  const user = database.findUser(userId)
  user.accessCount++ // Modification
  database.save(user)
  return user // Retour de valeur
}

// ✅ BON : Séparation Command/Query
// Query : retourne valeur, pas de modification
function getUser(userId: string): User {
  return database.findUser(userId)
}

// Command : modifie état, pas de retour
function incrementUserAccessCount(userId: string): void {
  const user = database.findUser(userId)
  user.accessCount++
  database.save(user)
}

// Usage
const user = getUser(userId) // Query
incrementUserAccessCount(userId) // Command
```

---

## 5. Gestion des Erreurs

### 5.1 Préférer les Exceptions aux Codes d'Erreur

**Principe :**
- Les exceptions séparent la logique métier de la gestion d'erreur
- Codes d'erreur mélangent tout

**Exemples :**

```typescript
// ❌ MAUVAIS : Codes d'erreur
function deleteUser(userId: string): number {
  const user = database.findUser(userId)
  if (!user) return ERROR_USER_NOT_FOUND

  if (user.hasOrders()) return ERROR_USER_HAS_ORDERS

  database.delete(user)
  return SUCCESS
}

// Appelant doit vérifier constamment
const result = deleteUser('123')
if (result === ERROR_USER_NOT_FOUND) {
  // ...
} else if (result === ERROR_USER_HAS_ORDERS) {
  // ...
}

// ✅ BON : Exceptions
function deleteUser(userId: string): void {
  const user = findUserOrThrow(userId)

  if (user.hasOrders()) {
    throw new UserHasOrdersError(userId)
  }

  database.delete(user)
}

function findUserOrThrow(userId: string): User {
  const user = database.findUser(userId)
  if (!user) {
    throw new UserNotFoundError(userId)
  }
  return user
}

// Usage avec try/catch centralisé
try {
  deleteUser('123')
} catch (error) {
  if (error instanceof UserNotFoundError) {
    // Handle
  } else if (error instanceof UserHasOrdersError) {
    // Handle
  } else {
    throw error
  }
}
```

### 5.2 Exceptions Métier vs Techniques

**Principe :**
- **Domain Exceptions** : Violations de règles métier
- **Technical Exceptions** : Erreurs infrastructure (DB, réseau, etc.)
- Séparer clairement

**Exemples :**

```typescript
// ✅ Domain Exceptions : Règles métier
class InsufficientFundsError extends Error {
  constructor(
    public readonly accountId: string,
    public readonly requested: Money,
    public readonly available: Money
  ) {
    super(`Insufficient funds in account ${accountId}`)
    this.name = 'InsufficientFundsError'
  }
}

class OrderAlreadyShippedError extends Error {
  constructor(public readonly orderId: string) {
    super(`Order ${orderId} has already been shipped`)
    this.name = 'OrderAlreadyShippedError'
  }
}

// ✅ Technical Exceptions : Infrastructure
class DatabaseConnectionError extends Error {
  constructor(public readonly cause: Error) {
    super(`Database connection failed: ${cause.message}`)
    this.name = 'DatabaseConnectionError'
  }
}

class PaymentGatewayTimeoutError extends Error {
  constructor(public readonly gatewayName: string) {
    super(`Payment gateway ${gatewayName} timed out`)
    this.name = 'PaymentGatewayTimeoutError'
  }
}

// Usage dans Application Service
class WithdrawMoneyService {
  async execute(command: WithdrawMoneyCommand): Promise<void> {
    try {
      const account = await this.accountRepository.findById(command.accountId)

      // Domain exception
      if (account.balance.isLessThan(command.amount)) {
        throw new InsufficientFundsError(
          account.id,
          command.amount,
          account.balance
        )
      }

      account.withdraw(command.amount)
      await this.accountRepository.save(account)
    } catch (error) {
      // Technical exception wrapping
      if (error instanceof DatabaseError) {
        throw new DatabaseConnectionError(error)
      }
      throw error
    }
  }
}
```

### 5.3 Ne Pas Retourner Null

**Principe :**
- `null` force des vérifications partout
- Utiliser Optional/Maybe pattern ou exceptions
- Retourner objets vides ou Special Case pattern

**Exemples :**

```typescript
// ❌ MAUVAIS : Retourne null
function findUser(userId: string): User | null {
  return database.findUser(userId)
}

// Appelant doit toujours vérifier
const user = findUser('123')
if (user !== null) { // Vérification obligatoire
  console.log(user.name)
}

// ✅ BON : Exception si non trouvé
function findUserOrThrow(userId: string): User {
  const user = database.findUser(userId)
  if (!user) {
    throw new UserNotFoundError(userId)
  }
  return user
}

// ✅ BON : Optional/Maybe pour cas valides
type Optional<T> = T | undefined

function tryFindUser(userId: string): Optional<User> {
  return database.findUser(userId)
}

// ✅ BON : Special Case Object
class NullUser implements User {
  get name(): string { return 'Guest' }
  get email(): string { return 'guest@example.com' }
  isGuest(): boolean { return true }
}

function findUserOrGuest(userId: string): User {
  const user = database.findUser(userId)
  return user ?? new NullUser()
}

// Pas de vérification null nécessaire
const user = findUserOrGuest('123')
console.log(user.name) // Fonctionne toujours
```

### 5.4 Contexte dans les Exceptions

**Principe :**
- Les exceptions doivent fournir assez de contexte pour debugger
- Inclure les valeurs pertinentes

**Exemples :**

```typescript
// ❌ MAUVAIS : Pas assez de contexte
throw new Error('Invalid amount')

// ✅ BON : Contexte complet
class InvalidAmountError extends Error {
  constructor(
    public readonly amount: number,
    public readonly min: number,
    public readonly max: number
  ) {
    super(`Amount ${amount} is invalid. Must be between ${min} and ${max}`)
    this.name = 'InvalidAmountError'
  }
}

throw new InvalidAmountError(amount, 0, 1000)

// ✅ BON : Contexte métier riche
class OrderCancellationError extends Error {
  constructor(
    public readonly orderId: string,
    public readonly orderStatus: OrderStatus,
    public readonly reason: string
  ) {
    super(
      `Cannot cancel order ${orderId} with status ${orderStatus}: ${reason}`
    )
    this.name = 'OrderCancellationError'
  }
}

if (order.status === OrderStatus.Shipped) {
  throw new OrderCancellationError(
    order.id,
    order.status,
    'Order has already been shipped'
  )
}
```

---

## 6. Refactoring - Code Smells

### 6.1 Long Method (Méthode Trop Longue)

**Code Smell :**
- Fonction > 30 lignes
- Fait plusieurs choses
- Difficile à comprendre d'un coup d'œil

**Refactoring :** Extract Method

**Exemples :**

```typescript
// ❌ Code Smell : Long Method
function processOrder(orderId: string): void {
  const order = database.query(`SELECT * FROM orders WHERE id = '${orderId}'`)
  const customer = database.query(`SELECT * FROM customers WHERE id = '${order.customerId}'`)

  let total = 0
  for (let i = 0; i < order.items.length; i++) {
    const item = order.items[i]
    const product = database.query(`SELECT * FROM products WHERE id = '${item.productId}'`)

    if (product.stock < item.quantity) {
      throw new Error('Out of stock')
    }

    total += product.price * item.quantity
  }

  if (customer.isPremium && total > 100) {
    total = total * 0.9
  }

  order.total = total
  order.status = 'confirmed'
  database.update('orders', order)

  const email = {
    to: customer.email,
    subject: 'Order confirmed',
    body: `Your order #${order.id} for $${total} has been confirmed`
  }
  emailService.send(email)
}

// ✅ Refactoring : Extract Method
function processOrder(orderId: string): void {
  const order = loadOrder(orderId)
  const customer = loadCustomer(order.customerId)

  validateStock(order)
  const total = calculateTotal(order, customer)

  confirmOrder(order, total)
  sendConfirmationEmail(customer, order, total)
}

function loadOrder(orderId: string): Order {
  return orderRepository.findById(orderId)
}

function loadCustomer(customerId: string): Customer {
  return customerRepository.findById(customerId)
}

function validateStock(order: Order): void {
  for (const item of order.items) {
    const product = productRepository.findById(item.productId)
    if (product.stock < item.quantity) {
      throw new OutOfStockError(product.id, product.stock, item.quantity)
    }
  }
}

function calculateTotal(order: Order, customer: Customer): number {
  let total = order.items.reduce((sum, item) => sum + item.subtotal(), 0)

  if (customer.isPremium && total > 100) {
    total = applyPremiumDiscount(total)
  }

  return total
}

function applyPremiumDiscount(total: number): number {
  return total * 0.9
}

function confirmOrder(order: Order, total: number): void {
  order.setTotal(total)
  order.confirm()
  orderRepository.save(order)
}

function sendConfirmationEmail(customer: Customer, order: Order, total: number): void {
  emailService.send({
    to: customer.email,
    subject: 'Order confirmed',
    template: 'order-confirmation',
    data: { orderId: order.id, total }
  })
}
```

### 6.2 Large Class (Classe Trop Grosse)

**Code Smell :**
- Classe avec trop de responsabilités
- Violations de SRP
- Difficile à tester et maintenir

**Refactoring :** Extract Class

**Exemples :**

```typescript
// ❌ Code Smell : Large Class
class User {
  id: string
  email: string
  password: string
  name: string
  address: string
  phone: string
  orders: Order[]
  wishlist: Product[]

  // Authentification
  authenticate(password: string): boolean { /* ... */ }
  changePassword(oldPassword: string, newPassword: string): void { /* ... */ }
  resetPassword(): void { /* ... */ }

  // Profil
  updateProfile(name: string, phone: string): void { /* ... */ }
  updateAddress(address: string): void { /* ... */ }
  uploadAvatar(file: File): void { /* ... */ }

  // Commandes
  placeOrder(items: CartItem[]): Order { /* ... */ }
  cancelOrder(orderId: string): void { /* ... */ }
  getOrderHistory(): Order[] { /* ... */ }

  // Wishlist
  addToWishlist(product: Product): void { /* ... */ }
  removeFromWishlist(productId: string): void { /* ... */ }

  // Notifications
  sendEmailNotification(subject: string, body: string): void { /* ... */ }
  sendSMSNotification(message: string): void { /* ... */ }
}

// ✅ Refactoring : Extract Class
class User {
  constructor(
    public readonly id: UserId,
    public readonly email: Email,
    private profile: UserProfile,
    private credentials: UserCredentials
  ) {}

  getProfile(): UserProfile {
    return this.profile
  }

  updateProfile(newProfile: UserProfile): void {
    this.profile = newProfile
  }

  authenticate(password: string): boolean {
    return this.credentials.matches(password)
  }
}

class UserProfile {
  constructor(
    public readonly name: string,
    public readonly phone: PhoneNumber,
    public readonly address: Address
  ) {}
}

class UserCredentials {
  constructor(
    private readonly passwordHash: string
  ) {}

  matches(password: string): boolean {
    return bcrypt.compare(password, this.passwordHash)
  }

  changePassword(oldPassword: string, newPassword: string): UserCredentials {
    if (!this.matches(oldPassword)) {
      throw new InvalidPasswordError()
    }
    return new UserCredentials(bcrypt.hash(newPassword))
  }
}

class OrderService {
  placeOrder(userId: UserId, items: CartItem[]): Order { /* ... */ }
  cancelOrder(orderId: OrderId): void { /* ... */ }
  getOrderHistory(userId: UserId): Order[] { /* ... */ }
}

class WishlistService {
  addProduct(userId: UserId, product: Product): void { /* ... */ }
  removeProduct(userId: UserId, productId: ProductId): void { /* ... */ }
  getWishlist(userId: UserId): Product[] { /* ... */ }
}
```

### 6.3 Feature Envy (Envie de Fonctionnalité)

**Code Smell :**
- Une méthode utilise plus de données d'une autre classe que de la sienne
- Indique que la méthode est dans la mauvaise classe

**Refactoring :** Move Method

**Exemples :**

```typescript
// ❌ Code Smell : Feature Envy
class Order {
  constructor(
    public id: string,
    public customerId: string,
    public items: OrderItem[]
  ) {}
}

class OrderPrinter {
  printInvoice(order: Order): string {
    let invoice = `Order #${order.id}\n`

    // Feature Envy : utilise beaucoup order.items
    let total = 0
    for (const item of order.items) {
      invoice += `${item.productName} x${item.quantity} = $${item.price * item.quantity}\n`
      total += item.price * item.quantity
    }

    invoice += `\nTotal: $${total}`
    return invoice
  }
}

// ✅ Refactoring : Move Method to Order
class Order {
  constructor(
    public readonly id: string,
    public readonly customerId: string,
    private items: OrderItem[]
  ) {}

  calculateTotal(): number {
    return this.items.reduce((sum, item) => sum + item.subtotal(), 0)
  }

  getInvoiceLines(): string[] {
    return this.items.map(item =>
      `${item.productName} x${item.quantity} = $${item.subtotal()}`
    )
  }
}

class OrderPrinter {
  printInvoice(order: Order): string {
    let invoice = `Order #${order.id}\n`
    invoice += order.getInvoiceLines().join('\n')
    invoice += `\nTotal: $${order.calculateTotal()}`
    return invoice
  }
}
```

### 6.4 Data Clumps (Agrégats de Données)

**Code Smell :**
- Même groupe de données apparaît ensemble dans plusieurs endroits
- Devrait être un objet

**Refactoring :** Extract Class / Introduce Parameter Object

**Exemples :**

```typescript
// ❌ Code Smell : Data Clumps
function createUser(
  firstName: string,
  lastName: string,
  street: string,
  city: string,
  zipCode: string,
  country: string
): User {
  // ...
}

function updateUserAddress(
  userId: string,
  street: string,
  city: string,
  zipCode: string,
  country: string
): void {
  // ...
}

function formatAddress(
  street: string,
  city: string,
  zipCode: string,
  country: string
): string {
  // ...
}

// ✅ Refactoring : Extract Class
class Address {
  constructor(
    public readonly street: string,
    public readonly city: string,
    public readonly zipCode: string,
    public readonly country: string
  ) {}

  format(): string {
    return `${this.street}, ${this.zipCode} ${this.city}, ${this.country}`
  }

  equals(other: Address): boolean {
    return this.street === other.street &&
           this.city === other.city &&
           this.zipCode === other.zipCode &&
           this.country === other.country
  }
}

function createUser(name: PersonName, address: Address): User {
  // ...
}

function updateUserAddress(userId: string, address: Address): void {
  // ...
}
```

### 6.5 Primitive Obsession (Obsession des Primitifs)

**Code Smell :**
- Utiliser des types primitifs (string, number) au lieu d'objets métier
- Perte de validation et de sémantique

**Refactoring :** Replace Primitive with Object

**Exemples :**

```typescript
// ❌ Code Smell : Primitive Obsession
class User {
  constructor(
    public id: string, // Simple string, pas de validation
    public email: string, // Peut être invalide
    public age: number // Peut être négatif
  ) {}
}

function sendEmail(to: string, subject: string, body: string): void {
  // string peut être n'importe quoi
}

// ✅ Refactoring : Value Objects
class UserId {
  private constructor(public readonly value: string) {}

  static create(): UserId {
    return new UserId(crypto.randomUUID())
  }

  static fromString(value: string): UserId {
    if (!value.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)) {
      throw new Error('Invalid user ID format')
    }
    return new UserId(value)
  }

  equals(other: UserId): boolean {
    return this.value === other.value
  }
}

class Email {
  private constructor(public readonly value: string) {}

  static fromString(value: string): Email {
    const normalized = value.trim().toLowerCase()
    if (!normalized.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
      throw new Error('Invalid email format')
    }
    return new Email(normalized)
  }

  getDomain(): string {
    return this.value.split('@')[1]
  }

  equals(other: Email): boolean {
    return this.value === other.value
  }
}

class Age {
  private constructor(public readonly value: number) {}

  static fromNumber(value: number): Age {
    if (value < 0 || value > 150) {
      throw new Error('Age must be between 0 and 150')
    }
    return new Age(value)
  }

  isAdult(): boolean {
    return this.value >= 18
  }
}

class User {
  constructor(
    public readonly id: UserId,
    public readonly email: Email,
    public readonly age: Age
  ) {}
}

// Impossible de passer des valeurs invalides
const user = new User(
  UserId.create(),
  Email.fromString('test@test.com'),
  Age.fromNumber(25)
)
```

---

## 7. Design Patterns

### 7.1 Creational Patterns

#### Factory Pattern

**Utilisation :**
- Création d'objets complexes
- Logique de création centralisée

**Exemples :**

```typescript
// ✅ Factory Pattern
interface PaymentMethod {
  process(amount: Money): Promise<PaymentResult>
}

class PaymentMethodFactory {
  create(type: string, config: unknown): PaymentMethod {
    switch (type) {
      case 'credit_card':
        return new CreditCardPayment(config as CreditCardConfig)
      case 'paypal':
        return new PayPalPayment(config as PayPalConfig)
      case 'crypto':
        return new CryptoPayment(config as CryptoConfig)
      default:
        throw new Error(`Unknown payment type: ${type}`)
    }
  }
}

// Usage
const factory = new PaymentMethodFactory()
const paymentMethod = factory.create('credit_card', creditCardConfig)
await paymentMethod.process(new Money(100, Currency.USD))
```

#### Builder Pattern

**Utilisation :**
- Construction d'objets complexes étape par étape
- Rendre l'objet immutable après construction

**Exemples :**

```typescript
// ✅ Builder Pattern
class QueryBuilder {
  private table: string = ''
  private selectFields: string[] = []
  private whereConditions: string[] = []
  private limitValue?: number
  private orderByField?: string

  select(...fields: string[]): this {
    this.selectFields.push(...fields)
    return this
  }

  from(table: string): this {
    this.table = table
    return this
  }

  where(condition: string): this {
    this.whereConditions.push(condition)
    return this
  }

  limit(value: number): this {
    this.limitValue = value
    return this
  }

  orderBy(field: string): this {
    this.orderByField = field
    return this
  }

  build(): string {
    let query = `SELECT ${this.selectFields.join(', ')} FROM ${this.table}`

    if (this.whereConditions.length > 0) {
      query += ` WHERE ${this.whereConditions.join(' AND ')}`
    }

    if (this.orderByField) {
      query += ` ORDER BY ${this.orderByField}`
    }

    if (this.limitValue) {
      query += ` LIMIT ${this.limitValue}`
    }

    return query
  }
}

// Usage fluide
const query = new QueryBuilder()
  .select('id', 'name', 'email')
  .from('users')
  .where('age > 18')
  .where('country = "US"')
  .orderBy('name')
  .limit(10)
  .build()
```

### 7.2 Structural Patterns

#### Adapter Pattern

**Utilisation :**
- Adapter une interface existante à une interface attendue
- Intégration de librairies tierces

**Exemples :**

```typescript
// Interface attendue par notre application
interface Logger {
  info(message: string, context?: object): void
  error(message: string, error?: Error): void
}

// Librairie tierce avec interface différente
class Winston {
  log(level: string, msg: string, meta: object): void {
    // Winston implementation
  }
}

// ✅ Adapter Pattern
class WinstonLoggerAdapter implements Logger {
  constructor(private winston: Winston) {}

  info(message: string, context?: object): void {
    this.winston.log('info', message, context || {})
  }

  error(message: string, error?: Error): void {
    this.winston.log('error', message, {
      errorMessage: error?.message,
      stack: error?.stack
    })
  }
}

// Usage
const winstonInstance = new Winston()
const logger: Logger = new WinstonLoggerAdapter(winstonInstance)
logger.info('User logged in', { userId: '123' })
```

#### Decorator Pattern

**Utilisation :**
- Ajouter des fonctionnalités dynamiquement
- Composition plutôt qu'héritage

**Exemples :**

```typescript
// ✅ Decorator Pattern
interface DataSource {
  readData(): string
  writeData(data: string): void
}

class FileDataSource implements DataSource {
  constructor(private filename: string) {}

  readData(): string {
    return fs.readFileSync(this.filename, 'utf-8')
  }

  writeData(data: string): void {
    fs.writeFileSync(this.filename, data)
  }
}

class EncryptionDecorator implements DataSource {
  constructor(private wrappee: DataSource) {}

  readData(): string {
    const data = this.wrappee.readData()
    return this.decrypt(data)
  }

  writeData(data: string): void {
    const encrypted = this.encrypt(data)
    this.wrappee.writeData(encrypted)
  }

  private encrypt(data: string): string {
    return Buffer.from(data).toString('base64')
  }

  private decrypt(data: string): string {
    return Buffer.from(data, 'base64').toString('utf-8')
  }
}

class CompressionDecorator implements DataSource {
  constructor(private wrappee: DataSource) {}

  readData(): string {
    const data = this.wrappee.readData()
    return this.decompress(data)
  }

  writeData(data: string): void {
    const compressed = this.compress(data)
    this.wrappee.writeData(compressed)
  }

  private compress(data: string): string {
    return zlib.gzipSync(data).toString('base64')
  }

  private decompress(data: string): string {
    return zlib.gunzipSync(Buffer.from(data, 'base64')).toString()
  }
}

// Usage : composition de décorateurs
let source: DataSource = new FileDataSource('data.txt')
source = new EncryptionDecorator(source)
source = new CompressionDecorator(source)

source.writeData('Hello World') // Compressé puis chiffré
const data = source.readData() // Déchiffré puis décompressé
```

### 7.3 Behavioral Patterns

#### Strategy Pattern

**Utilisation :**
- Algorithmes interchangeables
- Éviter les conditionnels

**Exemples :**

```typescript
// ✅ Strategy Pattern
interface DiscountStrategy {
  calculate(amount: Money): Money
}

class NoDiscount implements DiscountStrategy {
  calculate(amount: Money): Money {
    return amount
  }
}

class PercentageDiscount implements DiscountStrategy {
  constructor(private percentage: number) {}

  calculate(amount: Money): Money {
    const discount = amount.amount * (this.percentage / 100)
    return new Money(amount.amount - discount, amount.currency)
  }
}

class FixedAmountDiscount implements DiscountStrategy {
  constructor(private discountAmount: Money) {}

  calculate(amount: Money): Money {
    if (amount.currency !== this.discountAmount.currency) {
      throw new Error('Currency mismatch')
    }
    return new Money(
      Math.max(0, amount.amount - this.discountAmount.amount),
      amount.currency
    )
  }
}

class PriceCalculator {
  constructor(private discountStrategy: DiscountStrategy) {}

  calculateFinalPrice(basePrice: Money): Money {
    return this.discountStrategy.calculate(basePrice)
  }

  setDiscountStrategy(strategy: DiscountStrategy): void {
    this.discountStrategy = strategy
  }
}

// Usage
const calculator = new PriceCalculator(new NoDiscount())
let price = calculator.calculateFinalPrice(new Money(100, Currency.USD))

calculator.setDiscountStrategy(new PercentageDiscount(10))
price = calculator.calculateFinalPrice(new Money(100, Currency.USD)) // 90 USD
```

#### Observer Pattern (Pub/Sub)

**Utilisation :**
- Découplage entre émetteurs et receveurs d'événements
- Un objet notifie automatiquement ses observateurs

**Exemples :**

```typescript
// ✅ Observer Pattern
interface Observer<T> {
  update(data: T): void
}

interface Subject<T> {
  attach(observer: Observer<T>): void
  detach(observer: Observer<T>): void
  notify(data: T): void
}

class EventBus<T> implements Subject<T> {
  private observers: Observer<T>[] = []

  attach(observer: Observer<T>): void {
    this.observers.push(observer)
  }

  detach(observer: Observer<T>): void {
    this.observers = this.observers.filter(o => o !== observer)
  }

  notify(data: T): void {
    for (const observer of this.observers) {
      observer.update(data)
    }
  }
}

// Observers concrets
class EmailNotificationObserver implements Observer<OrderPlaced> {
  update(event: OrderPlaced): void {
    console.log(`Sending email for order ${event.orderId}`)
    // Send email...
  }
}

class InventoryUpdateObserver implements Observer<OrderPlaced> {
  update(event: OrderPlaced): void {
    console.log(`Updating inventory for order ${event.orderId}`)
    // Update inventory...
  }
}

class AnalyticsObserver implements Observer<OrderPlaced> {
  update(event: OrderPlaced): void {
    console.log(`Recording analytics for order ${event.orderId}`)
    // Record analytics...
  }
}

// Usage
const orderPlacedBus = new EventBus<OrderPlaced>()
orderPlacedBus.attach(new EmailNotificationObserver())
orderPlacedBus.attach(new InventoryUpdateObserver())
orderPlacedBus.attach(new AnalyticsObserver())

// Quand une commande est placée
const event = new OrderPlaced('order-123', 'customer-456')
orderPlacedBus.notify(event) // Tous les observers sont notifiés
```

---

## 8. Patterns Architecturaux

### 8.1 Layered Architecture (Architecture en Couches)

**Principe :**
- Séparation en couches avec dépendances unidirectionnelles
- Chaque couche ne connaît que la couche directement en dessous

**Structure :**

```
Presentation Layer (Controllers, UI)
        ↓
Application Layer (Use Cases, Application Services)
        ↓
Domain Layer (Entities, Value Objects, Domain Services)
        ↓
Infrastructure Layer (Database, External APIs, etc.)
```

**Exemples :**

```typescript
// ✅ Layered Architecture

// 1. DOMAIN LAYER (Coeur métier, pas de dépendances externes)
class Order {
  constructor(
    public readonly id: OrderId,
    private items: OrderItem[],
    private status: OrderStatus
  ) {}

  confirm(): void {
    if (this.items.length === 0) {
      throw new EmptyOrderError()
    }
    this.status = OrderStatus.Confirmed
  }
}

// 2. APPLICATION LAYER (Orchestration use cases)
class PlaceOrderUseCase {
  constructor(
    private orderRepository: OrderRepository,
    private eventBus: EventBus
  ) {}

  async execute(command: PlaceOrderCommand): Promise<OrderId> {
    const order = Order.create(command.items)
    order.confirm()

    await this.orderRepository.save(order)
    await this.eventBus.publish(new OrderPlaced(order.id))

    return order.id
  }
}

// 3. INFRASTRUCTURE LAYER (Implémentations techniques)
class PostgresOrderRepository implements OrderRepository {
  async save(order: Order): Promise<void> {
    await this.database.insert('orders', this.toDTO(order))
  }
}

// 4. PRESENTATION LAYER (Controllers, API)
@Controller('/orders')
class OrderController {
  constructor(private placeOrderUseCase: PlaceOrderUseCase) {}

  @Post()
  async placeOrder(@Body() dto: PlaceOrderDTO): Promise<Response> {
    const command = this.toCommand(dto)
    const orderId = await this.placeOrderUseCase.execute(command)
    return { orderId }
  }
}
```

### 8.2 Hexagonal Architecture (Ports & Adapters)

**Principe :**
- Le domaine est au centre, isolé
- Ports = interfaces définies par le domaine
- Adapters = implémentations techniques

**Structure :**

```
        [Adapters (Infrastructure)]
                    ↓
        [Ports (Interfaces Domain)]
                    ↓
           [Domain (Core)]
                    ↓
        [Ports (Interfaces Domain)]
                    ↓
        [Adapters (Infrastructure)]
```

**Exemples :**

```typescript
// ✅ Hexagonal Architecture

// DOMAIN (Hexagone central)
class Order {
  // Pure business logic
}

// PORTS (Interfaces définies par le domaine)
interface OrderRepository {
  save(order: Order): Promise<void>
  findById(id: OrderId): Promise<Order | null>
}

interface PaymentGateway {
  charge(amount: Money, paymentMethod: PaymentMethod): Promise<PaymentResult>
}

interface EventPublisher {
  publish(event: DomainEvent): Promise<void>
}

// APPLICATION SERVICES (Utilise les ports)
class PlaceOrderService {
  constructor(
    private orderRepository: OrderRepository,
    private paymentGateway: PaymentGateway,
    private eventPublisher: EventPublisher
  ) {}

  async execute(command: PlaceOrderCommand): Promise<OrderId> {
    const order = Order.create(command.items)

    const paymentResult = await this.paymentGateway.charge(
      order.total,
      command.paymentMethod
    )

    if (!paymentResult.success) {
      throw new PaymentFailedError()
    }

    order.confirm()
    await this.orderRepository.save(order)
    await this.eventPublisher.publish(new OrderPlaced(order.id))

    return order.id
  }
}

// ADAPTERS (Implémentations techniques des ports)
class PostgresOrderRepository implements OrderRepository {
  async save(order: Order): Promise<void> {
    // PostgreSQL implementation
  }
}

class StripePaymentGateway implements PaymentGateway {
  async charge(amount: Money, method: PaymentMethod): Promise<PaymentResult> {
    // Stripe API call
  }
}

class RabbitMQEventPublisher implements EventPublisher {
  async publish(event: DomainEvent): Promise<void> {
    // RabbitMQ publish
  }
}

// Dependency Injection (composition root)
const orderRepository = new PostgresOrderRepository(database)
const paymentGateway = new StripePaymentGateway(stripeConfig)
const eventPublisher = new RabbitMQEventPublisher(rabbitMQConfig)

const placeOrderService = new PlaceOrderService(
  orderRepository,
  paymentGateway,
  eventPublisher
)
```

### 8.3 CQRS (Command Query Responsibility Segregation)

**Principe :**
- Séparer les modèles de lecture (Query) et d'écriture (Command)
- Optimisations différentes pour chaque cas

**Exemples :**

```typescript
// ✅ CQRS Pattern

// WRITE MODEL (Commands)
interface Command {
  execute(): Promise<void>
}

class CreateOrderCommand implements Command {
  constructor(
    private customerId: string,
    private items: OrderItemDTO[]
  ) {}

  async execute(): Promise<OrderId> {
    const order = Order.create(this.customerId, this.items)
    await orderRepository.save(order)
    await eventBus.publish(new OrderCreated(order.id))
    return order.id
  }
}

class ConfirmOrderCommand implements Command {
  constructor(private orderId: OrderId) {}

  async execute(): Promise<void> {
    const order = await orderRepository.findById(this.orderId)
    order.confirm()
    await orderRepository.save(order)
    await eventBus.publish(new OrderConfirmed(order.id))
  }
}

// READ MODEL (Queries) - Optimized for queries
interface Query<T> {
  execute(): Promise<T>
}

class GetOrderDetailsQuery implements Query<OrderDetailsDTO> {
  constructor(private orderId: string) {}

  async execute(): Promise<OrderDetailsDTO> {
    // Query optimisé directement sur read model (peut être denormalisé)
    return database.query(`
      SELECT o.*, c.name as customer_name, c.email as customer_email
      FROM orders o
      JOIN customers c ON o.customer_id = c.id
      WHERE o.id = $1
    `, [this.orderId])
  }
}

class GetCustomerOrdersQuery implements Query<OrderSummaryDTO[]> {
  constructor(private customerId: string) {}

  async execute(): Promise<OrderSummaryDTO[]> {
    // Vue optimisée pour affichage
    return database.query(`
      SELECT id, total, status, created_at
      FROM orders
      WHERE customer_id = $1
      ORDER BY created_at DESC
    `, [this.customerId])
  }
}

// Usage dans controller
@Controller('/orders')
class OrderController {
  @Post()
  async create(@Body() dto: CreateOrderDTO): Promise<Response> {
    const command = new CreateOrderCommand(dto.customerId, dto.items)
    const orderId = await command.execute()
    return { orderId }
  }

  @Get(':id')
  async getDetails(@Param('id') id: string): Promise<OrderDetailsDTO> {
    const query = new GetOrderDetailsQuery(id)
    return query.execute()
  }
}
```

---

## 9. Principes Généraux

### 9.1 Composition Over Inheritance (Composition > Héritage)

**Principe :**
- Préférer composer des objets plutôt que hériter
- Plus flexible, moins couplé

**Exemples :**

```typescript
// ❌ MAUVAIS : Héritage rigide
class Animal {
  move(): void { console.log('Moving') }
}

class FlyingAnimal extends Animal {
  fly(): void { console.log('Flying') }
}

class SwimmingAnimal extends Animal {
  swim(): void { console.log('Swimming') }
}

// Problème : Et si un animal vole ET nage ?
// On ne peut pas hériter de 2 classes

// ✅ BON : Composition
interface Movable {
  move(): void
}

class WalkingBehavior implements Movable {
  move(): void { console.log('Walking') }
}

class FlyingBehavior implements Movable {
  move(): void { console.log('Flying') }
}

class SwimmingBehavior implements Movable {
  move(): void { console.log('Swimming') }
}

class Animal {
  constructor(private moveBehavior: Movable) {}

  performMove(): void {
    this.moveBehavior.move()
  }

  setMoveBehavior(behavior: Movable): void {
    this.moveBehavior = behavior
  }
}

// Flexible : on peut combiner et changer dynamiquement
const duck = new Animal(new FlyingBehavior())
duck.performMove() // Flying
duck.setMoveBehavior(new SwimmingBehavior())
duck.performMove() // Swimming
```

### 9.2 Dependency Injection

**Principe :**
- Ne pas instancier les dépendances dans la classe
- Les injecter depuis l'extérieur
- Facilite les tests et la flexibilité

**Exemples :**

```typescript
// ❌ MAUVAIS : Dépendance hard-codée
class UserService {
  private database = new MySQLDatabase() // Hard-coded
  private emailService = new SendGridEmailService() // Hard-coded

  async createUser(data: CreateUserDTO): Promise<User> {
    const user = await this.database.save(data)
    await this.emailService.send(user.email, 'Welcome')
    return user
  }
}

// ✅ BON : Dependency Injection
class UserService {
  constructor(
    private database: Database, // Injecté
    private emailService: EmailService // Injecté
  ) {}

  async createUser(data: CreateUserDTO): Promise<User> {
    const user = await this.database.save(data)
    await this.emailService.send(user.email, 'Welcome')
    return user
  }
}

// Composition Root (main.ts ou container DI)
const database = new MySQLDatabase(config)
const emailService = new SendGridEmailService(apiKey)
const userService = new UserService(database, emailService)

// Tests faciles avec mocks
const mockDatabase = new InMemoryDatabase()
const mockEmailService = new MockEmailService()
const userServiceForTest = new UserService(mockDatabase, mockEmailService)
```

### 9.3 Tell, Don't Ask

**Principe :**
- Dire aux objets quoi faire plutôt que demander leur état
- Encapsulation de la logique

**Exemples :**

```typescript
// ❌ MAUVAIS : Ask (demander l'état puis agir)
class ShoppingCart {
  constructor(public items: CartItem[]) {}
}

// Client code demande et agit
function checkout(cart: ShoppingCart): void {
  if (cart.items.length === 0) {
    throw new Error('Cart is empty')
  }

  let total = 0
  for (const item of cart.items) {
    total += item.price * item.quantity
  }

  processPayment(total)
}

// ✅ BON : Tell (dire quoi faire)
class ShoppingCart {
  private items: CartItem[] = []

  addItem(item: CartItem): void {
    this.items.push(item)
  }

  checkout(): CheckoutResult {
    if (this.items.length === 0) {
      throw new EmptyCartError()
    }

    const total = this.calculateTotal()
    return this.processPayment(total)
  }

  private calculateTotal(): number {
    return this.items.reduce((sum, item) => sum + item.subtotal(), 0)
  }

  private processPayment(total: number): CheckoutResult {
    // Payment logic
    return { success: true, total }
  }
}

// Client code simple
const cart = new ShoppingCart()
cart.addItem(item)
const result = cart.checkout() // Tell, don't ask
```

### 9.4 Law of Demeter (Loi de Déméter)

**Principe :**
- "Ne parle qu'à tes amis directs"
- Éviter les chaînes d'appels
- Réduire le couplage

**Exemples :**

```typescript
// ❌ MAUVAIS : Violation de la loi de Déméter
class Customer {
  getAddress(): Address { /* ... */ }
}

class Address {
  getCity(): City { /* ... */ }
}

class City {
  getZipCode(): string { /* ... */ }
}

// Chaîne d'appels (train wreck)
const zipCode = customer.getAddress().getCity().getZipCode()

// ✅ BON : Délégation
class Customer {
  getZipCode(): string {
    return this.address.getZipCode()
  }
}

class Address {
  getZipCode(): string {
    return this.city.getZipCode()
  }
}

class City {
  constructor(private zipCode: string) {}

  getZipCode(): string {
    return this.zipCode
  }
}

// Usage simple
const zipCode = customer.getZipCode() // Direct
```

### 9.5 Fail Fast

**Principe :**
- Détecter et signaler les erreurs le plus tôt possible
- Ne pas continuer avec des données invalides

**Exemples :**

```typescript
// ❌ MAUVAIS : Fail late
class Order {
  private items: OrderItem[] = []

  addItem(item: OrderItem): void {
    this.items.push(item) // Pas de validation
  }

  confirm(): void {
    // Validation tardive
    if (this.items.length === 0) {
      throw new Error('Cannot confirm empty order')
    }
    // ...
  }
}

// ✅ BON : Fail fast
class Order {
  private items: OrderItem[] = []

  addItem(item: OrderItem): void {
    if (!item) {
      throw new Error('Item cannot be null')
    }
    if (item.quantity <= 0) {
      throw new Error('Quantity must be positive')
    }
    if (item.price.amount < 0) {
      throw new Error('Price cannot be negative')
    }

    this.items.push(item) // Validation immédiate
  }

  confirm(): void {
    if (this.items.length === 0) {
      throw new EmptyOrderError() // Fail fast
    }
    // Continue seulement si valide
  }
}

// Value Objects fail fast dans le constructeur
class Email {
  constructor(public readonly value: string) {
    if (!value) {
      throw new Error('Email cannot be empty')
    }
    if (!value.includes('@')) {
      throw new Error('Invalid email format')
    }
    // Garanti que Email est TOUJOURS valide
  }
}

// Impossible de créer un Email invalide
const email = new Email('invalid') // Throw immédiatement
```

---

## 10. Checklist de Validation pour l'ARCHITECT

**L'ARCHITECT doit vérifier que le code respecte :**

```
SOLID
□ SRP : Chaque classe/fonction a UNE responsabilité
□ OCP : Extension sans modification (interfaces/abstraction)
□ LSP : Sous-classes substituables sans surprises
□ ISP : Interfaces spécifiques, pas grosses interfaces
□ DIP : Dépendance sur abstractions, pas implémentations

DESIGN ORIENTÉ DOMAINE
□ Ubiquitous Language utilisé dans le code
□ Entities vs Value Objects clairement distingués
□ Aggregates bien définis avec Aggregate Roots
□ Domain Events pour actions significatives
□ Repositories abstraits pour persistance
□ Bounded Contexts respectés (Anti-Corruption Layer)

CLEAN CODE
□ Fonctions font UNE chose
□ Niveau d'abstraction unique par fonction
□ ≤ 3 paramètres (sinon objet paramètre)
□ Pas d'effets de bord cachés
□ Command Query Separation respecté

GESTION D'ERREURS
□ Exceptions plutôt que codes d'erreur
□ Exceptions métier vs techniques séparées
□ Pas de retour null (exceptions ou Optional)
□ Contexte riche dans les exceptions

CODE SMELLS ABSENTS
□ Pas de Long Methods (> 30 lignes)
□ Pas de Large Classes (trop de responsabilités)
□ Pas de Feature Envy
□ Pas de Data Clumps (agrégats = objets)
□ Pas de Primitive Obsession (Value Objects)

PATTERNS APPROPRIÉS
□ Factory pour création complexe
□ Builder pour objets complexes
□ Adapter pour intégrations tierces
□ Strategy pour algorithmes interchangeables
□ Observer/Pub-Sub pour découplage événements

ARCHITECTURE
□ Layered ou Hexagonal architecture claire
□ Dependency Injection utilisée
□ Composition > Inheritance
□ Tell, Don't Ask respecté
□ Law of Demeter (pas de chaînes d'appels)
□ Fail Fast (validation immédiate)

TESTS (TDD)
□ Tests écrits (idéalement avant le code)
□ Tests FIRST (Fast, Independent, Repeatable, Self-Validating, Timely)
□ Test Doubles appropriés (Stub, Mock, Fake)
□ Coverage ≥ 80%
```

**Si 1 seul principe violé → REJETER et demander refactoring**

---

## ✅ Conclusion

Ces principes sont **NON NÉGOCIABLES** et doivent être respectés dans **TOUT** le code produit.

**L'ARCHITECT a le devoir de :**
- ✅ Bloquer tout code ne respectant pas ces principes
- ✅ Former les développeurs à ces pratiques
- ✅ Reviewer avec ces principes en tête
- ✅ Encourager le refactoring continu

**Références implicites** (non citées dans le code mais sources de ces principes) :
- Principes SOLID, DDD, TDD, Clean Code
- Patterns de conception éprouvés
- Pratiques XP et Agile
- Refactoring et élimination des code smells

**Le code de qualité n'est pas négociable.**
