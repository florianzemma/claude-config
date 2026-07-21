---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(npm test*), Bash(pnpm test*), Bash(npx vitest*), Bash(npx jest*), Bash(npx playwright*)
description: Test-Driven Development strict — red → green → refactor, coverage quasi-totale, happy path + edge cases
---

Implémente la feature suivante en TDD strict :

$ARGUMENTS

---

## Philosophie

Les tests vérifient le **comportement via l'interface publique**, jamais les détails d'implémentation. Le code peut changer entièrement — les tests, non.

Un bon test = une spécification. "user can checkout with valid cart" dit exactement quelle capacité existe. Il survit à un refactor interne car il ne connaît pas la structure.

Un mauvais test est couplé à l'implémentation : il mocke des collaborateurs internes, teste des méthodes privées, ou vérifie via des moyens détournés (ex : query DB directe au lieu de l'interface). Signe d'alarme : le test casse après un rename interne sans que le comportement ait changé.

---

## Code existant non testé — characterization test d'abord (Feathers)

Avant de modifier du code sans test : écris d'abord un **characterization test** qui capture le comportement **actuel** (même s'il te paraît faux) — c'est ton filet. Tu ne modifies qu'une fois le comportement figé. Le TDD ci-dessous suppose du greenfield ; ceci couvre le cas réel le plus fréquent : toucher du legacy.

---

## Anti-pattern à bannir : Horizontal Slicing

**NE PAS écrire tous les tests d'abord, puis tout le code.**

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical — tracer bullet):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

Le slicing horizontal produit des tests qui testent la *forme* imaginée des choses, pas le comportement réel. Ils passent quand le comportement est cassé, échouent quand il est correct.

---

## Workflow

### 1. Planning (avant d'écrire la moindre ligne)

- Confirme avec l'utilisateur quels comportements tester (priorise)
- Liste les behaviors à couvrir (pas les étapes d'implémentation)
- Identifie les happy paths ET les edge cases pour chaque behavior
- Obtiens validation avant de commencer

### 2. Tracer Bullet

Écris UN test qui confirme UNE chose sur le système :

```
RED:   test pour le premier comportement → doit échouer
GREEN: code minimal pour faire passer → passe
```

Ce premier cycle prouve que le chemin end-to-end fonctionne.

### 3. Boucle incrémentale — Red → Green → Repeat

Pour chaque comportement restant :

- **🔴 RED** — Un test qui échoue
  - Interface publique uniquement
  - Si le test passe déjà sans code, il est mal écrit
  - Lance les tests — confirmation que ça échoue

- **🟢 GREEN** — Code minimal pour faire passer
  - Pas d'optimisation, pas d'abstraction prématurée
  - Un seul objectif : faire passer ce test rouge
  - Lance les tests — confirmation que ça passe

- Répète pour le test suivant

### 4. Refactor (seulement après que tous les tests passent)

Cherche :
- Duplication → extraire une fonction/classe
- Méthodes longues → décomposer (tests restent sur l'interface publique)
- Modules plats → approfondir
- Feature envy → déplacer la logique là où vivent les données
- Primitive obsession → introduire des value objects

**Jamais refactorer en RED. Aller au GREEN d'abord.**

---

## Coverage : quasi-totalité du code

Chaque fonction, branche, et module doit être couverte sauf :
- Code boilerplate de framework (config, DI setup, main entry)
- Adaptateurs infrastructure triviaux (wrappers directs sans logique)

Pour chaque feature, couvre systématiquement :

**Happy path**
- Le cas nominal complet, de bout en bout
- Toutes les variantes valides d'inputs

**Edge cases**
- Inputs vides / null / undefined
- Valeurs limites (0, -1, max, min)
- Collections vides ou à un seul élément
- Concurrence si applicable
- Erreurs attendues (rejets métier, validations)

**Failure paths**
- Erreurs des dépendances externes (timeout, erreur réseau, réponse invalide)
- États incohérents ou transitions invalides

---

## Bonnes pratiques de test

```typescript
// GOOD: teste le comportement observable
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});

// BAD: teste l'implémentation interne
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

```typescript
// BAD: bypasse l'interface pour vérifier
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: vérifie via l'interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

---

## Quand mocker

**Mocker UNIQUEMENT aux frontières système :**
- APIs externes (paiement, email, SMS...)
- Bases de données (préférer une vraie DB de test si possible)
- Temps / aléatoire (`Date.now`, `Math.random`)
- Système de fichiers (parfois)

**Ne jamais mocker :**
- Tes propres classes/modules
- Des collaborateurs internes
- Tout ce que tu contrôles

**Conception pour la mockabilité (dependency injection) :**

```typescript
// GOOD: facile à mocker
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// BAD: impossible à mocker sans monkey-patching
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**Préfère des interfaces SDK-style :**

```typescript
// GOOD: chaque fonction est mockable indépendamment
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: mock nécessite une logique conditionnelle interne
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

---

## Checklist par cycle

```
[ ] Le test décrit un comportement, pas une implémentation
[ ] Le test utilise uniquement l'interface publique
[ ] Le test survivrait à un refactor interne
[ ] Le code est minimal pour ce test
[ ] Aucune feature spéculative ajoutée
[ ] Happy path couvert
[ ] Edge cases identifiés et testés
[ ] Failure paths couverts si applicable
```
