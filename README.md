# Claude Multi-Agent Configuration

Configuration professionnelle de Claude Code avec système multi-agents spécialisés, standards architecturaux et principes de design moderne.

## Table des Matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Agents Disponibles](#agents-disponibles)
- [Standards et Principes](#standards-et-principes)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Workflow Standard](#workflow-standard)
- [Structure du Projet](#structure-du-projet)
- [Classification des Projets](#classification-des-projets)
- [Outils Configurés](#outils-configurés)
- [Documentation](#documentation)
- [Sécurité](#sécurité)
- [Tests](#tests)
- [Design System](#design-system)
- [Contribution](#contribution)
- [Exemples d'Usage](#exemples-dusage)

## Vue d'ensemble

Ce projet fournit une configuration complète pour Claude Code avec :

- **13 agents spécialisés** incluant un PLANNER prioritaire
- **Workflow en 4 étapes** (Planning → Specification → Design → Implementation)
- **Standards architecturaux** (SOLID, DDD, TDD, Clean Code)
- **Principes de design frontend** anti "AI slop"
- **Classification de projets** (Simple/Moyen/Complexe)
- **Documentation stricte** (README, .env.example, guides)

**🧠 Nouveauté : PLANNER** - Point d'entrée obligatoire qui analyse, pose des questions, et produit un plan validé AVANT toute exécution.

## Architecture

```
                    ┌─────────────────────┐
                    │      PLANNER        │
                    │  (Think First)      │
                    │  Plan validated     │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   ORCHESTRATOR      │
                    │  (Coordination)     │
                    └──────────┬──────────┘
                               │
         ┌─────────────────────┼────────────────────┐
         │                     │                    │
         ▼                     ▼                    ▼
    ┌────────┐            ┌────────┐          ┌──────────┐
    │ARCHITECT│──────────→│DESIGNER│─────────→│FULLSTACK │
    │ (Veto) │            │        │          │   DEV    │
    └────────┘            └────────┘          └──────────┘
         │                     │                    │
         ▼                     ▼                    ▼
    ┌────────┐            ┌────────┐          ┌──────────┐
    │REVIEWER│            │SECURITY│          │ DEBUGGER │
    │        │            │        │          │          │
    └────────┘            └────────┘          └──────────┘
```

**Principes clés** :
- **PLANNER** : Point d'entrée OBLIGATOIRE pour tâches non-triviales. Planifie avant d'agir.
- **ARCHITECT** : Droit de **veto** - aucun code ne passe sans validation.

## Agents Disponibles

### Agents de Développement

| Agent             | Rôle                                            | Commande        | Proactif                |
| ----------------- | ----------------------------------------------- | --------------- | ----------------------- |
| **PLANNER** 🧠    | **Point d'entrée pour tâches non-triviales. Analyse, planifie, valide AVANT exécution** | `@planner` | ✅ **OBLIGATOIRE avant code** |
| **ORCHESTRATOR**  | Coordination générale, décomposition des tâches | `@orchestrator` | ✅ Après plan validé    |
| **ARCHITECT**     | Standards, architecture, validation technique   | `@architect`    | ✅ Décisions techniques |
| **DESIGNER**      | UI/UX, design system, accessibilité             | `@designer`     | ✅ Features UI/UX       |
| **FULLSTACK_DEV** | Implémentation complète (frontend + backend)    | `@dev`          | -                       |
| **TESTER**        | Tests unitaires, intégration, E2E, QA           | `@tester`       | -                       |
| **REVIEWER**      | Code review, qualité, sécurité                  | `@reviewer`     | ✅ Après implémentation |
| **DEVOPS**        | CI/CD, déploiement, infrastructure              | `@devops`       | -                       |

### Agents Spécialisés

| Agent                    | Rôle                                      | Commande             | Proactif               |
| ------------------------ | ----------------------------------------- | -------------------- | ---------------------- |
| **SECURITY_ENGINEER**    | Sécurité OWASP, audit, threat modeling    | `@security`          | ✅ Auth/Payment/PII    |
| **ERROR_COORDINATOR**    | Gestion des erreurs, recovery, resilience | `@error-coordinator` | ✅ Appels API externes |
| **CONTEXT_MANAGER**      | Optimisation du contexte, summarization   | `@context-manager`   | ✅ Auto (background)   |
| **DEBUGGER**             | Débogage avancé, root cause analysis      | `@debugger`          | ✅ Bugs/Tests failing  |
| **PERFORMANCE_ENGINEER** | Optimisation performances, profiling      | `@performance`       | ✅ Avant production    |
| **DOCUMENTALIST**        | Documentation technique, README, guides   | `@documentalist`     | ✅ Après changements   |

## Standards et Principes

### Principes Architecturaux

Le code doit respecter les principes définis dans `.claude/standards/architectural-principles.md` :

- **SOLID** : Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- **Domain-Driven Design** : Ubiquitous Language, Entities, Value Objects, Aggregates, Domain Events, Repositories, Bounded Contexts
- **Test-Driven Development** : Red-Green-Refactor, tests first, FIRST principles
- **Clean Code** : Fonctions courtes (<50 lignes), un niveau d'abstraction, Command-Query Separation, fail fast
- **Design Patterns** : Factory, Builder, Adapter, Decorator, Strategy, Observer
- **Architectural Patterns** : Layered Architecture, Hexagonal Architecture (Ports & Adapters), CQRS

### Principes de Design Frontend

Le design doit éviter l'esthétique générique "AI slop" selon `.claude/standards/frontend-design-principles.md` :

**Typography** :

- ❌ Fonts interdites : Inter, Roboto, Arial, Space Grotesk
- ✅ Fonts distinctives : Clash Display, DM Sans, Fraunces, Cabinet Grotesk

**Couleurs** :

- ❌ Purple gradients génériques
- ✅ Stratégie 70% dominant + 30% accents
- ✅ Inspiration : IDE themes (Tokyo Night, Catppuccin, Dracula)

**Animations** :

- ❌ Micro-interactions partout
- ✅ Animations orchestrées (staggered page load)
- ✅ CSS-only priorité, Framer Motion pour complexité

**Backgrounds** :

- ❌ Solides plats
- ✅ Layered gradients, geometric patterns, noise textures
- ✅ Profondeur et atmosphère

### Règles de Documentation

**Code auto-documenté** (DOCUMENTALIST) :

- ❌ **PAS de commentaires dans le code** (sauf exceptions : logique métier complexe, workarounds temporaires)
- ✅ Noms de fonctions/variables explicites
- ✅ Abstractions claires
- ✅ Types TypeScript stricts

**Documentation externe** :

- ✅ README.md **toujours à jour** après chaque changement
- ✅ .env.example **synchronisé** avec les variables utilisées
- ✅ Guide d'onboarding < 30 minutes
- ✅ CHANGELOG.md (format Keep a Changelog)
- ✅ Documentation API (OpenAPI/Swagger)

## Installation

### Prérequis

- Claude Code CLI installé
- Node.js 18+ (ou version requise par votre projet)
- Git

### Configuration

1. **Cloner le repository**

```bash
git clone https://github.com/votre-repo/claude-config.git
cd claude-config
```

2. **Copier la configuration Claude**

```bash
# La configuration est déjà dans le dossier ./claude
# Claude Code la détectera automatiquement
```

3. **Vérifier la configuration**

```bash
# Tester l'orchestrateur
claude-code @orchestrator "Analyser la structure du projet"

# Tester l'architecte
claude-code @architect "Vérifier les standards du projet"
```

## Utilisation

### Workflow complet (via ORCHESTRATOR)

Pour une tâche complète avec validation automatique :

```bash
claude-code @orchestrator "Créer un module de gestion d'utilisateurs avec:
- API REST (NestJS)
- Interface admin (React)
- Tests complets
- Documentation"
```

L'ORCHESTRATOR va automatiquement :

1. Décomposer la tâche
2. Invoquer ARCHITECT pour validation
3. Coordonner DESIGNER, TESTER, FULLSTACK_DEV
4. Lancer REVIEWER pour validation finale

### Utilisation du PLANNER (Recommandé)

Pour toute tâche non-triviale, **commencez par le PLANNER** :

```bash
# Le PLANNER va analyser, poser des questions, explorer le code,
# proposer des approches, et produire un plan validé
claude-code @planner "Créer un système de notifications en temps réel"

# Le PLANNER va:
# 1. Comprendre vos besoins (poser des questions si nécessaire)
# 2. Explorer le contexte technique existant
# 3. Proposer 2-3 approches (WebSocket vs SSE vs Polling)
# 4. Créer un plan détaillé avec sous-tâches
# 5. Passer la main à @orchestrator une fois validé
```

**Quand utiliser PLANNER ?**
- ✅ Nouvelles features (> 30min de travail)
- ✅ Refactoring architectural
- ✅ Plusieurs approches possibles
- ✅ Impacts multi-fichiers
- ❌ Corrections triviales (typos, one-liners)

---

### Invocation directe d'agents

Pour des tâches spécifiques ou après planification :

```bash
# Architecture et standards
claude-code @architect "Review l'architecture du module payment"

# Design UI/UX
claude-code @designer "Créer un composant Card réutilisable avec variants"

# Implémentation
claude-code @dev "Implémenter l'API REST pour les utilisateurs"

# Tests
claude-code @tester "Créer les tests E2E pour le flow d'inscription"

# Code review
claude-code @reviewer "Review le code du module auth"

# Sécurité
claude-code @security "Audit de sécurité du module authentication"

# Gestion des erreurs
claude-code @error-coordinator "Review la stratégie de gestion d'erreurs de l'API"

# Débogage
claude-code @debugger "Analyser pourquoi les tests de paiement échouent"

# Performance
claude-code @performance "Profiler l'application et identifier les bottlenecks"

# Documentation
claude-code @documentalist "Mettre à jour le README et synchroniser le .env.example"

# DevOps
claude-code @devops "Setup pipeline CI/CD GitHub Actions"
```

## Workflow Standard

### 4-Stage Pipeline

#### Stage 0 : Planning (PLANNER)

**Point d'entrée OBLIGATOIRE pour tâches non-triviales**

1. **UNDERSTAND** : Reformule la demande, pose des questions critiques
2. **EXPLORE** : Scanne le contexte technique existant (patterns, tests, configs)
3. **ARCHITECT** : Propose 2-3 approches avec avantages/inconvénients
4. **PLAN** : Produit un plan détaillé avec sous-tâches, estimations, risques

**Critères de passage** : Utilisateur valide le plan → Handoff à ORCHESTRATOR

**Output** : Plan validé (fichier `plan.md` ou structuré dans la conversation)

**Complexité** :
- **TRIVIAL** : Skip PLANNER, direct ORCHESTRATOR
- **SIMPLE** : Phase UNDERSTAND + PLAN rapide
- **MEDIUM** : Toutes les phases
- **COMPLEX** : Toutes les phases + fichier plan.md

---

#### Stage 1 : Specification & Design

**Validation ARCHITECT obligatoire (BLOQUANT)**

1. ORCHESTRATOR analyse la demande
2. CONTEXT_MANAGER optimise le contexte (automatique)
3. **ARCHITECT valide la faisabilité** ⚠️ Droit de veto
4. SECURITY_ENGINEER identifie les risques (si auth/payment/PII)
5. **Output** : ADR créé avec décisions architecturales

**Critères de passage** : ARCHITECT approuve → Stage 2

---

#### Stage 2 : Design & Test Preparation

**Exécution en parallèle**

- DESIGNER conçoit les interfaces (si UI nécessaire)
- TESTER écrit les tests (TDD - tests échouent pour l'instant)
- ERROR_COORDINATOR définit la stratégie de gestion d'erreurs
- PERFORMANCE_ENGINEER définit les budgets de performance (si applicable)

**Output** : Designs prêts, tests écrits (red state), stratégies définies

**Critères de passage** : Tous les outputs validés → Stage 3

---

#### Stage 3 : Implementation, Review & Deployment

**Exécution séquentielle**

1. FULLSTACK_DEV implémente le code
2. TESTER exécute les tests (doivent passer au vert ✅)
3. DEBUGGER intervient si bugs détectés 🐛
4. REVIEWER valide le code produit
5. SECURITY_ENGINEER security review (si code critique)
6. PERFORMANCE_ENGINEER vérifie budgets respectés (si applicable)
7. DOCUMENTALIST met à jour README et .env.example
8. DEVOPS déploie en production

**Output** : Code production-ready, déployé, documenté

**Critères de complétion** : Tous les tests passent, reviews approuvées, déployé sans erreurs, documentation à jour

## Structure du Projet

```
claude-config/
├── claude/
│   ├── CLAUDE.md              # Instructions principales pour Claude
│   ├── agents/                # Configuration des agents
│   │   ├── orchestrator.md
│   │   ├── architect.md
│   │   ├── designer.md
│   │   ├── fullstack-dev.md
│   │   ├── tester.md
│   │   ├── reviewer.md
│   │   ├── devops.md
│   │   ├── security-engineer.md
│   │   ├── error-coordinator.md
│   │   ├── context-manager.md
│   │   ├── debugger.md
│   │   ├── performance-engineer.md
│   │   └── documentalist.md
│   └── standards/             # Standards de code et design
│       ├── architectural-principles.md
│       ├── frontend-design-principles.md
│       ├── linting_formatting.md
│       ├── logging_monitoring.md
│       └── code-quality-rules.md
├── README.md                  # Ce fichier
└── LICENSE                    # MIT License
```

## Classification des Projets

L'ARCHITECT classifie chaque projet selon 3 niveaux pour **éviter l'over-engineering** :

### Niveau 1 - SIMPLE

**Type** : Site vitrine, landing page, blog

**Stack** :

- Frontend : Vercel / Netlify
- Monitoring : Logs plateforme
- Qualité : ESLint + Prettier

**Exemple** :

```bash
✅ ESLint + Vercel logs pour un site vitrine (adapté)
❌ SonarQube + Kubernetes pour un site vitrine (over-engineering)
```

### Niveau 2 - MOYEN

**Type** : SaaS simple, app interne, e-commerce PME

**Stack** :

- Backend : Railway / Render
- Monitoring : Sentry + Winston
- Qualité : SonarCloud + Tests 70%

**Exemple** :

```bash
✅ Sentry + Railway + SonarCloud pour un SaaS simple (adapté)
```

### Niveau 3 - COMPLEXE

**Type** : SaaS multi-tenant, fintech, healthtech

**Stack** :

- Infrastructure : AWS / GCP / Kubernetes
- Monitoring : Sentry + ELK + APM
- Qualité : SonarQube + Tests 80% + E2E

**Exemple** :

```bash
✅ Stack complète pour un SaaS fintech (justifié)
```

**⚠️ L'ARCHITECT DOIT créer un ADR-000 "Classification du projet" au démarrage.**

## Outils Configurés

### Formatage et Linting (OBLIGATOIRE tous niveaux)

**JavaScript/TypeScript** :

- ESLint + Prettier
- eslint-plugin-sonarjs + eslint-plugin-security
- husky + lint-staged (pre-commit hooks)

**Python** :

- Black + Ruff/Flake8 + isort
- pre-commit

**Configuration minimale requise** :

```json
{
  "devDependencies": {
    "eslint": "latest",
    "prettier": "latest",
    "lint-staged": "latest",
    "husky": "latest",
    "eslint-plugin-sonarjs": "latest",
    "eslint-plugin-security": "latest"
  },
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "prepare": "husky install"
  }
}
```

### Monitoring (Niveau 2 et 3)

**Obligatoire** :

- Sentry (error tracking & performance monitoring)
- Winston / Pino (logging structuré)

**Niveau 3 uniquement** :

- ELK Stack (logs centralisés)
- APM (Application Performance Monitoring)

### Qualité du Code

**Tous niveaux** :

- Complexité cyclomatique ≤ 10
- Fonctions ≤ 50 lignes
- Pas de `any` en TypeScript
- Pas de duplication > 3%

**Niveau 2 et 3** :

- SonarCloud (N2) ou SonarQube (N3)
- Coverage ≥ 70% (N2) ou ≥ 80% (N3)
- Quality Gates configurés

## Documentation

### Architecture Decision Records (ADR)

Toute décision architecturale significative doit être documentée :

```markdown
# ADR-001 : Choix de NestJS pour le Backend

**Date** : 2026-01-09
**Statut** : Accepté
**Contexte** : Besoin d'un framework backend TypeScript robuste
**Décision** : Utilisation de NestJS avec architecture modulaire
**Conséquences** :

- ✅ TypeScript strict
- ✅ Dependency Injection native
- ❌ Courbe d'apprentissage
```

### README.md

**Sections obligatoires** :

- Installation (< 5 min)
- Configuration (.env.example)
- Démarrage rapide
- Scripts disponibles
- Architecture (C4 diagrams si applicable)
- Contribution

**DOCUMENTALIST vérifie** que le README est à jour après chaque changement.

### .env.example

**Synchronisation obligatoire** avec le code :

```bash
# =============================================================================
# DATABASE
# =============================================================================

# PostgreSQL connection string
# Format: postgresql://user:password@host:port/database
# SECURITY: Generate with `openssl rand -base64 32`
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# JWT secret key
JWT_SECRET=your_jwt_secret_here
```

**DOCUMENTALIST valide** avec un script de vérification automatique.

### Guide d'Onboarding

**Objectif** : Nouveau développeur opérationnel en < 30 min

**Checklist** :

1. Installation (10 min)
2. Vérification (5 min)
3. Premier code (15 min)

## Sécurité

### SECURITY_ENGINEER

S'active automatiquement sur :

- Code d'authentification
- Traitement de paiements
- Données personnelles (PII)

### Checklist Sécurité

```
□ Pas de credentials hardcodés
□ Validation des inputs (injection prevention)
□ HTTPS obligatoire en production
□ CORS configuré correctement
□ Rate limiting sur les API
□ Headers de sécurité (CSP, HSTS, etc.)
□ Secrets en variables d'environnement
□ Dépendances auditées (npm audit)
```

### OWASP Top 10

Le code doit être protégé contre :

- Injection (SQL, XSS, etc.)
- Broken Authentication
- Sensitive Data Exposure
- XML External Entities (XXE)
- Broken Access Control
- Security Misconfiguration
- Cross-Site Scripting (XSS)
- Insecure Deserialization
- Using Components with Known Vulnerabilities
- Insufficient Logging & Monitoring

## Tests

### Stratégie TDD

**Red-Green-Refactor** :

1. Écrire un test qui échoue (RED)
2. Écrire le code minimum pour passer (GREEN)
3. Refactorer en gardant les tests verts (REFACTOR)

### Couverture Requise

- **Niveau 1** : Tests de base
- **Niveau 2** : Coverage ≥ 70%
- **Niveau 3** : Coverage ≥ 80% + E2E

### Types de Tests

```typescript
// Tests unitaires
describe("Money", () => {
  it("should add two money amounts with same currency", () => {
    const fiveEuros = new Money(5, Currency.EUR);
    const tenEuros = new Money(10, Currency.EUR);

    const result = fiveEuros.add(tenEuros);

    expect(result.amount).toBe(15);
  });
});

// Tests d'intégration
describe("UserService", () => {
  it("should create user and send welcome email", async () => {
    const user = await userService.create({ email: "test@example.com" });
    expect(emailService.send).toHaveBeenCalledWith(user.email);
  });
});

// Tests E2E
describe("Authentication Flow", () => {
  it("should login user and redirect to dashboard", async () => {
    await page.goto("/login");
    await page.fill("[name=email]", "user@example.com");
    await page.fill("[name=password]", "password");
    await page.click("button[type=submit]");
    await expect(page).toHaveURL("/dashboard");
  });
});
```

## Design System

### Composants UI

Structure recommandée :

```
src/components/
├── ui/              # Composants atomiques
│   ├── Button.tsx
│   ├── Input.tsx
│   └── Card.tsx
├── features/        # Composants métier
│   ├── UserProfile.tsx
│   └── ProductCard.tsx
└── layouts/         # Layouts
    ├── MainLayout.tsx
    └── DashboardLayout.tsx
```

### Accessibilité (A11y)

**Checklist** :

- Contraste WCAG AA minimum (4.5:1)
- Navigation clavier complète
- ARIA labels sur éléments interactifs
- Support lecteurs d'écran
- Focus visible
- prefers-reduced-motion respecté

## Contribution

### Workflow Git

```bash
# 1. Créer une branche
git checkout -b feat/nouvelle-fonctionnalite

# 2. Développer avec commits conventionnels
git commit -m "feat(auth): add OAuth2 Google provider"

# 3. Pousser et créer une PR
git push origin feat/nouvelle-fonctionnalite
```

### Convention de Commits

```
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore, perf
```

**Exemples** :

```
feat(auth): add OAuth2 Google provider
fix(cart): resolve quantity update race condition
refactor(api): extract validation middleware
docs(readme): update installation steps
test(user): add integration tests for registration
```

## Exemples d'Usage

### Exemple 1 : Nouvelle Feature Complète (avec PLANNER)

```bash
# Étape 1 : PLANNER analyse et planifie
claude-code @planner "Implémenter un système de notifications en temps réel"
```

**Ce qui se passe :**

**[PLANNER] - [UNDERSTAND]**
```
Je comprends que vous voulez un système de notifications temps réel.
Avant de planifier, j'ai besoin de clarifier:

1. Type de notifications ? (Push, in-app, email, SMS)
2. Volume attendu ? (100 users, 10K, 1M+)
3. Persistance requise ? (historique notifications)
4. Contraintes techniques ? (stack existante à respecter)
5. Délai acceptable ? (< 1s, < 5s, < 30s)
```

**Après vos réponses :**

**[PLANNER] - [EXPLORE]**
```
J'ai scanné votre codebase:
- Backend NestJS existant
- Frontend React avec Zustand
- PostgreSQL database
- Pattern event-driven déjà en place
```

**[PLANNER] - [ARCHITECT]**
```
Voici 3 approches:

### Option A: WebSocket (Socket.io)
✅ Temps réel < 100ms
✅ Bi-directionnel
❌ Complexité infrastructure
❌ Coût scaling

### Option B: Server-Sent Events (SSE) ← Recommandé
✅ Simple à implémenter
✅ Reconnexion auto
✅ Suffisant pour notifications unidirectionnelles
❌ Pas bi-directionnel

### Option C: Polling
✅ Très simple
❌ Latence 5-30s
❌ Charge serveur

**Recommandation: Option B (SSE)**
Pourquoi ? Votre besoin est unidirectionnel, volume modéré (10K users),
SSE est parfait et évite la complexité de WebSocket.

**Tu valides cette approche ?**
```

**Après validation :**

**[PLANNER] - [PLAN]**
```markdown
# Plan: Système de notifications temps réel (SSE)

## 📋 Résumé
Implémenter notifications temps réel via Server-Sent Events

## ✅ Validations Obtenues
- [x] Compréhension validée
- [x] Architecture SSE approuvée
- [x] Contraintes identifiées

## 🎯 Scope
**Inclus:**
- Endpoint SSE /api/notifications/stream
- Composant NotificationCenter React
- Table notifications PostgreSQL
- Tests E2E du flow

**Hors scope:**
- Push notifications mobile (Phase 2)
- Email notifications (existe déjà)

## 🏗️ Architecture
Server-Sent Events avec:
- NestJS endpoint SSE
- Event emitter pour broadcast
- Zustand store pour état client
- PostgreSQL pour historique

## 📝 Sous-tâches

### 1. Backend - Endpoint SSE
- Estimation: 1h
- Agent: @fullstack_dev
- Fichiers: src/notifications/notifications.controller.ts
- Critères:
  - [ ] Endpoint /api/notifications/stream
  - [ ] Event emitter configuré
  - [ ] Tests unitaires

### 2. Backend - Service notifications
- Estimation: 45min
- Agent: @fullstack_dev
- Dépendances: Tâche 1
- Fichiers: src/notifications/notifications.service.ts

### 3. Database - Migration
- Estimation: 30min
- Agent: @fullstack_dev
- Fichiers: migrations/xxx-notifications-table.ts

### 4. Frontend - Composant NotificationCenter
- Estimation: 1h30
- Agent: @designer + @fullstack_dev
- Fichiers: components/NotificationCenter.tsx

### 5. Tests E2E
- Estimation: 1h
- Agent: @tester
- Dépendances: Toutes les précédentes

## ⚠️ Risques
| Risque | Impact | Mitigation |
|--------|--------|------------|
| Connexions SSE qui dropent | MEDIUM | Reconnexion auto + heartbeat |
| Scaling > 10K users | LOW | Migration WebSocket si besoin |

## 🚀 Prêt pour ORCHESTRATOR
@orchestrator peut prendre le relais pour exécution.
```

**[PLANNER] - [HANDOFF]**
```
✅ Plan validé et prêt pour exécution.

@orchestrator Voici le plan à exécuter:
- 5 sous-tâches identifiées
- Estimation totale: 4h45
- Priorité: MEDIUM

Je reste disponible pour clarifications.
```

---

**Puis l'ORCHESTRATOR prend le relais :**

1. ARCHITECT valide la faisabilité technique
2. DESIGNER crée le composant NotificationCenter
3. TESTER écrit les tests (TDD)
4. FULLSTACK_DEV implémente backend + frontend
5. REVIEWER valide le code
6. SECURITY_ENGINEER vérifie la sécurité SSE
7. DOCUMENTALIST met à jour le README
8. DEVOPS configure le déploiement

### Exemple 2 : Bug Fix

```bash
claude-code @debugger "Les utilisateurs ne peuvent pas se déconnecter après 30 minutes de session"
```

**Résultat** :

1. DEBUGGER analyse les logs et reproduit le bug
2. Identifie le problème (token expiration mal gérée)
3. FULLSTACK_DEV corrige le code
4. TESTER vérifie la correction
5. REVIEWER valide

### Exemple 3 : Optimisation Performance

```bash
claude-code @performance "L'application est lente au chargement initial"
```

**Résultat** :

1. PERFORMANCE_ENGINEER profile l'application
2. Identifie les bottlenecks (bundle trop gros, images non optimisées)
3. FULLSTACK_DEV implémente code splitting et lazy loading
4. PERFORMANCE_ENGINEER vérifie les budgets respectés
5. DOCUMENTALIST met à jour la documentation des optimisations

## Licence

MIT License - voir [LICENSE](./LICENSE)

---

**Configuration maintenue par** : Votre équipe
**Dernière mise à jour** : 2026-01-09
