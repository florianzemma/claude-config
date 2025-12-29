# Standards de Qualité du Code (Obligatoires)

**⚠️ RÈGLE ABSOLUE : Ces standards de qualité sont OBLIGATOIRES pour TOUS les projets, TOUS les niveaux, avec ou sans outil de vérification.**

## Philosophie

> "Le code doit respecter les standards de qualité élevés, peu importe la taille du projet. L'outil (SonarQube) n'est qu'un moyen de vérifier automatiquement ce qui devrait déjà être respecté."

**Objectif** : Si vous installez SonarQube demain, le code doit avoir une **note A** parce qu'il respectait déjà les règles.

## Standards Obligatoires (Tous Projets)

### 1. Complexité du Code

**Règle : Complexité cyclomatique ≤ 10 par fonction**

```typescript
// ❌ REFUSER : Complexité 15 (trop élevé)
function calculatePrice(user, cart, promo, shipping) {
  if (user.isPremium) {
    if (cart.total > 100) {
      if (promo && promo.isValid) {
        if (promo.type === 'percentage') {
          if (promo.value > 20) {
            // ... 10 autres niveaux d'imbrication
          }
        } else if (promo.type === 'fixed') {
          // ...
        }
      } else {
        // ...
      }
    } else {
      // ...
    }
  } else {
    // ...
  }
}

// ✅ APPROUVER : Complexité 3 (fonctions simples et focalisées)
function calculatePrice(user: User, cart: Cart, promo?: Promo): number {
  const basePrice = cart.total;
  const discount = calculateDiscount(user, cart, promo);
  return applyDiscount(basePrice, discount);
}

function calculateDiscount(user: User, cart: Cart, promo?: Promo): number {
  if (!user.isPremium) return 0;
  if (cart.total <= 100) return 0;
  return promo ? getPromoDiscount(promo) : getDefaultDiscount(cart);
}
```

**Comment vérifier :**
- **Avec outil** : SonarQube/SonarCloud détecte automatiquement
- **Sans outil** : ESLint plugin `eslint-plugin-complexity` + review manuelle ARCHITECT/REVIEWER

**Configuration ESLint obligatoire :**
```json
{
  "rules": {
    "complexity": ["error", 10]
  }
}
```

### 2. Duplication de Code

**Règle : Duplication ≤ 3% du code**

```typescript
// ❌ REFUSER : Code dupliqué
function fetchUsers() {
  const token = localStorage.getItem('token');
  const response = await fetch('/api/users', {
    headers: { Authorization: `Bearer ${token}` }
  });
  return response.json();
}

function fetchOrders() {
  const token = localStorage.getItem('token');
  const response = await fetch('/api/orders', {
    headers: { Authorization: `Bearer ${token}` }
  });
  return response.json();
}

function fetchProducts() {
  const token = localStorage.getItem('token');
  const response = await fetch('/api/products', {
    headers: { Authorization: `Bearer ${token}` }
  });
  return response.json();
}

// ✅ APPROUVER : DRY (Don't Repeat Yourself)
const apiClient = axios.create({
  baseURL: '/api',
});

apiClient.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  config.headers.Authorization = `Bearer ${token}`;
  return config;
});

function fetchUsers() {
  return apiClient.get('/users');
}

function fetchOrders() {
  return apiClient.get('/orders');
}

function fetchProducts() {
  return apiClient.get('/products');
}
```

**Comment vérifier :**
- **Avec outil** : SonarQube détecte les blocs dupliqués automatiquement
- **Sans outil** : ESLint plugin `eslint-plugin-sonarjs` + review manuelle REVIEWER
- **Seuil** : Maximum 3% de duplication sur le projet

**Configuration ESLint obligatoire :**
```json
{
  "plugins": ["sonarjs"],
  "rules": {
    "sonarjs/no-duplicate-string": ["error", 3],
    "sonarjs/no-identical-functions": "error"
  }
}
```

### 3. Longueur des Fonctions et Fichiers

**Règles :**
- Fonctions : ≤ 50 lignes (idéalement ≤ 30)
- Fichiers : ≤ 500 lignes (idéalement ≤ 300)

```typescript
// ❌ REFUSER : Fonction 120 lignes
function processOrder(order, user, payment, shipping, inventory) {
  // Validation (20 lignes)
  if (!order.items.length) throw new Error('Empty cart');
  // ... 20 lignes de validation

  // Payment (30 lignes)
  const paymentMethod = payment.method;
  // ... 30 lignes de logique paiement

  // Inventory (30 lignes)
  for (const item of order.items) {
    // ... 30 lignes de gestion stock
  }

  // Shipping (20 lignes)
  // ... 20 lignes calcul shipping

  // Notifications (20 lignes)
  // ... 20 lignes d'envoi emails
}

// ✅ APPROUVER : Fonctions courtes et focalisées
function processOrder(order: Order, user: User, payment: Payment, shipping: Shipping) {
  validateOrder(order);
  const paymentResult = processPayment(payment, order.total);
  updateInventory(order.items);
  const shippingCost = calculateShipping(shipping, order);
  sendNotifications(user, order);
  return createOrderConfirmation(order, paymentResult, shippingCost);
}
```

**Configuration ESLint obligatoire :**
```json
{
  "rules": {
    "max-lines-per-function": ["error", { "max": 50, "skipBlankLines": true }],
    "max-lines": ["error", { "max": 500, "skipComments": true }]
  }
}
```

### 4. Profondeur d'Imbrication

**Règle : Profondeur maximale ≤ 4 niveaux**

```typescript
// ❌ REFUSER : Profondeur 6
function processData(data) {
  if (data) {                           // Niveau 1
    if (data.user) {                    // Niveau 2
      if (data.user.isActive) {         // Niveau 3
        if (data.user.hasPermission) {  // Niveau 4
          if (data.user.role === 'admin') {  // Niveau 5
            if (data.user.verified) {        // Niveau 6
              return true;
            }
          }
        }
      }
    }
  }
  return false;
}

// ✅ APPROUVER : Early returns
function processData(data: Data): boolean {
  if (!data?.user) return false;
  if (!data.user.isActive) return false;
  if (!data.user.hasPermission) return false;
  if (data.user.role !== 'admin') return false;
  if (!data.user.verified) return false;
  return true;
}

// ✅ ENCORE MIEUX : Fonction dédiée
function canProcessData(user: User): boolean {
  return user.isActive
    && user.hasPermission
    && user.role === 'admin'
    && user.verified;
}
```

**Configuration ESLint obligatoire :**
```json
{
  "rules": {
    "max-depth": ["error", 4]
  }
}
```

### 5. Nombre de Paramètres

**Règle : Maximum 4 paramètres par fonction**

```typescript
// ❌ REFUSER : 7 paramètres
function createUser(
  name: string,
  email: string,
  password: string,
  age: number,
  address: string,
  phone: string,
  newsletter: boolean
) {
  // ...
}

// ✅ APPROUVER : Objet avec types
interface CreateUserDto {
  name: string;
  email: string;
  password: string;
  age: number;
  address: string;
  phone: string;
  newsletter: boolean;
}

function createUser(data: CreateUserDto) {
  // ...
}
```

**Configuration ESLint obligatoire :**
```json
{
  "rules": {
    "max-params": ["error", 4]
  }
}
```

### 6. Bugs Patterns (Critical)

**Règles : Aucun bug pattern accepté**

```typescript
// ❌ REFUSER : Comparaison incorrecte
if (value == null) { } // Utilise == au lieu de ===

// ✅ APPROUVER
if (value === null) { }

// ❌ REFUSER : Variable non initialisée
let total;
items.forEach(item => total += item.price); // total est undefined

// ✅ APPROUVER
let total = 0;
items.forEach(item => total += item.price);

// ❌ REFUSER : Retour incohérent
function getUser(id: string): User | null {
  if (id === '1') return { name: 'John' };
  return undefined; // Devrait retourner null
}

// ✅ APPROUVER
function getUser(id: string): User | null {
  if (id === '1') return { name: 'John' };
  return null;
}

// ❌ REFUSER : Async/await mal utilisé
async function fetchData() {
  return fetch('/api/data'); // Oublie await
}

// ✅ APPROUVER
async function fetchData() {
  return await fetch('/api/data');
}
```

**Configuration ESLint obligatoire :**
```json
{
  "plugins": ["sonarjs"],
  "rules": {
    "eqeqeq": ["error", "always"],
    "no-undef": "error",
    "sonarjs/no-use-of-empty-return-value": "error",
    "sonarjs/no-identical-conditions": "error",
    "sonarjs/no-collection-size-mischeck": "error"
  }
}
```

### 7. Code Smells (Major)

**Règles : Minimiser les code smells**

```typescript
// ❌ REFUSER : Else inutile après return
function getStatus(value: number): string {
  if (value > 0) {
    return 'positive';
  } else {  // Else inutile
    return 'negative';
  }
}

// ✅ APPROUVER
function getStatus(value: number): string {
  if (value > 0) {
    return 'positive';
  }
  return 'negative';
}

// ❌ REFUSER : Variables non utilisées
function calculate(a: number, b: number, c: number) {
  return a + b; // c non utilisé
}

// ✅ APPROUVER
function calculate(a: number, b: number) {
  return a + b;
}

// ❌ REFUSER : Imports non utilisés
import { useState, useEffect, useMemo } from 'react'; // useMemo non utilisé

// ✅ APPROUVER
import { useState, useEffect } from 'react';

// ❌ REFUSER : Expression trop complexe
const result = (a > 0 && b < 10 || c === 5 && d !== 3) && (e > 100 || f === 'test' && g !== h);

// ✅ APPROUVER
const isConditionA = a > 0 && b < 10;
const isConditionB = c === 5 && d !== 3;
const isConditionC = e > 100;
const isConditionD = f === 'test' && g !== h;
const result = (isConditionA || isConditionB) && (isConditionC || isConditionD);
```

**Configuration ESLint obligatoire :**
```json
{
  "rules": {
    "no-else-return": "error",
    "no-unused-vars": "error",
    "@typescript-eslint/no-unused-vars": "error",
    "sonarjs/no-redundant-boolean": "error",
    "sonarjs/prefer-immediate-return": "error"
  }
}
```

### 8. Sécurité (OWASP)

**Règles : Aucune vulnérabilité acceptée**

```typescript
// ❌ REFUSER : Credentials hardcodés
const API_KEY = 'sk-1234567890abcdef';
const DB_PASSWORD = 'admin123';

// ✅ APPROUVER
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

// ❌ REFUSER : SQL Injection
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ APPROUVER
const query = `SELECT * FROM users WHERE id = $1`;
const result = await db.query(query, [userId]);

// ❌ REFUSER : XSS possible
element.innerHTML = userInput;

// ✅ APPROUVER (React échappe automatiquement)
<div>{userInput}</div>

// ❌ REFUSER : Weak crypto
import crypto from 'crypto';
const hash = crypto.createHash('md5').update(password).digest('hex');

// ✅ APPROUVER
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 10);
```

**Configuration ESLint obligatoire :**
```json
{
  "plugins": ["security"],
  "extends": ["plugin:security/recommended"],
  "rules": {
    "security/detect-object-injection": "error",
    "security/detect-non-literal-regexp": "error",
    "security/detect-unsafe-regex": "error"
  }
}
```

### 9. TypeScript Strict

**Règle : Pas de `any`, strict null checks, etc.**

```typescript
// ❌ REFUSER : any
function processData(data: any) {
  return data.value;
}

// ✅ APPROUVER : types spécifiques
function processData(data: unknown) {
  if (typeof data === 'object' && data !== null && 'value' in data) {
    return (data as { value: string }).value;
  }
  throw new Error('Invalid data');
}

// ❌ REFUSER : Implicit any
function getData(url) { // paramètre sans type
  return fetch(url);
}

// ✅ APPROUVER
function getData(url: string): Promise<Response> {
  return fetch(url);
}
```

**Configuration tsconfig.json obligatoire :**
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true
  }
}
```

### 10. Cognitive Complexity

**Règle : Complexité cognitive ≤ 15 par fonction**

La complexité cognitive mesure à quel point le code est difficile à comprendre (différent de la complexité cyclomatique).

```typescript
// ❌ REFUSER : Cognitive Complexity 25
function validateForm(form: Form) {
  if (form.email) {                                    // +1
    if (!form.email.includes('@')) {                   // +2 (imbriqué)
      errors.push('Invalid email');
    } else if (form.email.length < 5) {                // +1
      errors.push('Email too short');
    }
  }

  if (form.password) {                                 // +1
    if (form.password.length < 8) {                    // +2
      errors.push('Password too short');
    } else if (!/[A-Z]/.test(form.password)) {         // +1
      errors.push('Password needs uppercase');
    } else if (!/[0-9]/.test(form.password)) {         // +1
      errors.push('Password needs number');
    }
  }

  // ... 15+ lignes similaires
}

// ✅ APPROUVER : Cognitive Complexity 5
function validateForm(form: Form): ValidationErrors {
  return {
    email: validateEmail(form.email),
    password: validatePassword(form.password),
    name: validateName(form.name),
  };
}

function validateEmail(email?: string): string[] {
  const errors: string[] = [];
  if (!email) return errors;
  if (!email.includes('@')) errors.push('Invalid email');
  if (email.length < 5) errors.push('Email too short');
  return errors;
}
```

**Configuration ESLint obligatoire :**
```json
{
  "plugins": ["sonarjs"],
  "rules": {
    "sonarjs/cognitive-complexity": ["error", 15]
  }
}
```

## Configuration ESLint Complète (Obligatoire)

**Pour TOUS les projets, cette configuration ESLint est OBLIGATOIRE :**

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking"
  ],
  "plugins": [
    "@typescript-eslint",
    "sonarjs",
    "security"
  ],
  "rules": {
    // Complexité
    "complexity": ["error", 10],
    "max-depth": ["error", 4],
    "max-lines-per-function": ["error", { "max": 50 }],
    "max-lines": ["error", { "max": 500 }],
    "max-params": ["error", 4],

    // Code smells
    "no-else-return": "error",
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": "error",
    "eqeqeq": ["error", "always"],

    // TypeScript strict
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": ["error", {
      "allowExpressions": true
    }],

    // SonarJS (qualité)
    "sonarjs/cognitive-complexity": ["error", 15],
    "sonarjs/no-duplicate-string": ["error", 3],
    "sonarjs/no-identical-functions": "error",
    "sonarjs/no-identical-conditions": "error",
    "sonarjs/no-redundant-boolean": "error",
    "sonarjs/prefer-immediate-return": "error",
    "sonarjs/no-use-of-empty-return-value": "error",

    // Sécurité
    "security/detect-object-injection": "warn",
    "security/detect-non-literal-regexp": "warn",
    "security/detect-unsafe-regex": "error"
  }
}
```

**Installation requise :**
```bash
npm install --save-dev \
  eslint \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  eslint-plugin-sonarjs \
  eslint-plugin-security
```

## Vérification selon le Niveau du Projet

### NIVEAU 1 : PROJET SIMPLE

**Outils de vérification :**
- ✅ ESLint avec configuration complète ci-dessus (OBLIGATOIRE)
- ✅ Prettier (OBLIGATOIRE)
- ✅ Pre-commit hooks (husky + lint-staged) (OBLIGATOIRE)
- ✅ Review manuelle ARCHITECT + REVIEWER (OBLIGATOIRE)

**Processus :**
1. FULLSTACK_DEV configure ESLint avec toutes les règles
2. Pre-commit hooks bloquent si violations
3. REVIEWER vérifie manuellement dans la PR :
   - Pas de fonctions > 50 lignes
   - Pas de duplication visible
   - Complexité raisonnable
4. ARCHITECT valide l'architecture globale

**Résultat :** Code de qualité A sans SonarQube

### NIVEAU 2 : PROJET MOYEN

**Outils de vérification :**
- ✅ ESLint (même config que NIVEAU 1) (OBLIGATOIRE)
- ✅ SonarCloud (automatise la vérification) (OBLIGATOIRE)
- ✅ Coverage ≥ 70% (OBLIGATOIRE)

**Processus :**
1. ESLint attrape 80% des problèmes localement
2. SonarCloud scan automatique dans CI/CD
3. Quality Gate DOIT passer (automatique)
4. REVIEWER vérifie le rapport SonarCloud

**Résultat :** Validation automatique + manuelle

### NIVEAU 3 : PROJET COMPLEXE

**Outils de vérification :**
- ✅ ESLint (même config) (OBLIGATOIRE)
- ✅ SonarQube self-hosted ou Enterprise (OBLIGATOIRE)
- ✅ Coverage ≥ 80% (OBLIGATOIRE)
- ✅ Tests E2E (OBLIGATOIRE)
- ✅ Security scanning (Snyk, OWASP ZAP) (OBLIGATOIRE)

**Processus :**
1. ESLint + pre-commit
2. SonarQube scan complet CI/CD
3. Security scans
4. Quality Gate stricte
5. ARCHITECT + REVIEWER validation finale

**Résultat :** Validation multi-niveaux exhaustive

## Responsabilités

### ARCHITECT

**TOUS LES NIVEAUX :**
- ✅ Vérifier la configuration ESLint complète au démarrage
- ✅ Valider que pre-commit hooks sont actifs
- ✅ Bloquer si configuration ESLint incomplète
- ✅ Review manuel pour vérifier complexité, duplication, etc.
- ✅ Rejeter code ne respectant pas les seuils (même sans SonarQube)

**NIVEAU 2 et 3 :**
- ✅ Vérifier SonarCloud/SonarQube configuré
- ✅ Valider Quality Gate settings
- ✅ Bloquer si Quality Gate échoue

### FULLSTACK_DEV

**TOUS LES NIVEAUX :**
- ✅ Installer ESLint avec configuration complète
- ✅ Exécuter `npm run lint` avant commit
- ✅ Corriger TOUTES les erreurs ESLint
- ✅ Respecter les seuils : fonctions < 50 lignes, complexité < 10, etc.
- ✅ Éviter duplication de code
- ✅ Pas de `any` en TypeScript

**NIVEAU 2 et 3 :**
- ✅ Exécuter `npm run sonar:check` avant PR
- ✅ Corriger issues SonarQube Blocker/Critical

### REVIEWER

**TOUS LES NIVEAUX :**
- ✅ Vérifier que ESLint passe (0 erreurs)
- ✅ Review manuel :
  - Pas de fonctions trop longues
  - Pas de duplication évidente
  - Complexité raisonnable
  - Code lisible
- ✅ Rejeter si standards non respectés

**NIVEAU 2 et 3 :**
- ✅ Vérifier SonarQube report
- ✅ Valider Quality Gate status
- ✅ Bloquer si issues non résolues

## Checklist de Qualité (Tous Projets)

```
□ Configuration ESLint complète installée ?
□ Plugins sonarjs + security installés ?
□ Pre-commit hooks bloquent les violations ?
□ Aucune fonction > 50 lignes ?
□ Complexité < 10 pour toutes les fonctions ?
□ Profondeur d'imbrication < 4 ?
□ Maximum 4 paramètres par fonction ?
□ Pas de duplication de code visible ?
□ Pas de `any` en TypeScript ?
□ Pas de credentials hardcodés ?
□ Pas de console.log en production (utiliser logger) ?
□ Pas de code mort (variables/imports inutilisés) ?
□ Early returns utilisés (pas de else après return) ?
□ Fonctions courtes et focalisées ?
□ Code auto-documenté (pas de commentaires superflus) ?
□ Tests couvrent le code critique ?
```

## Pourquoi Ces Standards

1. **Maintenabilité** : Code facile à comprendre et modifier
2. **Onboarding** : Nouveaux devs comprennent rapidement
3. **Bugs** : Moins de bugs grâce aux patterns évités
4. **Sécurité** : Vulnérabilités détectées tôt
5. **Dette technique** : Reste faible dès le début
6. **Qualité constante** : Même niveau pour tous les projets
7. **Future-proof** : Si vous installez SonarQube → note A garantie

## Citation Finale

> "La qualité du code ne dépend pas de l'outil de vérification. Les standards doivent être respectés avec ou sans SonarQube. L'outil n'est qu'un assistant qui automatise ce qui devrait déjà être une pratique."

**⚠️ Ces standards sont NON NÉGOCIABLES, peu importe la taille du projet.**
