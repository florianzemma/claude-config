# Claude Multi-Agent Configuration

Configuration professionnelle pour Claude Code utilisant un système multi-agents spécialisés avec standards de qualité stricts.

## 📋 Table des Matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Agents Disponibles](#agents-disponibles)
- [Standards et Principes](#standards-et-principes)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Workflow Standard](#workflow-standard)
- [Structure du Projet](#structure-du-projet)
- [Classification des Projets](#classification-des-projets)
- [Contribution](#contribution)

---

## 🎯 Vue d'ensemble

Ce repository contient une configuration avancée pour Claude Code permettant :

- **Système multi-agents** : 11 agents spécialisés travaillant en orchestration
- **Standards de qualité élevés** : SOLID, DDD, TDD, Clean Code, design patterns
- **Anti over-engineering** : Classification des projets (Simple, Moyen, Complexe) avec stacks adaptées
- **Design distinctif** : Principes anti "AI slop" pour des frontends mémorables
- **Workflow 3-stage** : Specification → Design → Implementation

### Principes Fondamentaux

1. **Qualité non négociable** : Standards de code stricts pour tous les projets
2. **Stack adaptée** : Pas de sur-engineering, chaque outil doit être justifié
3. **Collaboration agents** : Orchestration claire entre agents spécialisés
4. **Documentation systématique** : ADR (Architecture Decision Records) pour chaque décision
5. **Tests first** : TDD encouragé, coverage minimum requis

---

## 🏗️ Architecture

### Système Multi-Agents

```
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                           │
│           (Coordination & Décomposition des tâches)         │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   ┌─────────┐     ┌──────────┐     ┌─────────┐
   │ARCHITECT│────▶│ DESIGNER │────▶│FULLSTACK│
   │  (Veto) │     │          │     │   DEV   │
   └─────────┘     └──────────┘     └─────┬───┘
        │                                  │
        │           ┌──────────┐          │
        └──────────▶│  TESTER  │◀─────────┘
                    └─────┬────┘
                          │
                    ┌─────▼────┐
                    │ REVIEWER │
                    └─────┬────┘
                          │
                    ┌─────▼────┐
                    │  DEVOPS  │
                    └──────────┘
```

### Agents Spécialisés Additionnels

- **SECURITY_ENGINEER** : Sécurité OWASP, audit, threat modeling
- **ERROR_COORDINATOR** : Gestion des erreurs, recovery, resilience
- **CONTEXT_MANAGER** : Optimisation du contexte (background)
- **DEBUGGER** : Débogage avancé, root cause analysis
- **PERFORMANCE_ENGINEER** : Optimisation performances, profiling

---

## 🤖 Agents Disponibles

### Agents de Développement

| Agent | Rôle | Proactif | Droit de Veto |
|-------|------|----------|---------------|
| **ORCHESTRATOR** | Coordination générale, décomposition des tâches | ✅ Always | ❌ |
| **ARCHITECT** | Standards, architecture, validation technique | ✅ Décisions techniques | ✅ Oui |
| **DESIGNER** | UI/UX, design system, accessibilité | ✅ Features UI/UX | ❌ |
| **FULLSTACK_DEV** | Implémentation complète (frontend + backend) | ❌ | ❌ |
| **TESTER** | Tests unitaires, intégration, E2E, QA | ❌ | ❌ |
| **REVIEWER** | Code review, qualité, sécurité | ✅ Après implémentation | ❌ |
| **DEVOPS** | CI/CD, déploiement, infrastructure | ❌ | ❌ |

### Agents Spécialisés

| Agent | Rôle | Proactif |
|-------|------|----------|
| **SECURITY_ENGINEER** | Audit sécurité, OWASP, threat modeling | ✅ Auth/Payment/PII |
| **ERROR_COORDINATOR** | Stratégie gestion d'erreurs, resilience | ✅ API externes |
| **CONTEXT_MANAGER** | Optimisation contexte, summarization | ✅ Auto (background) |
| **DEBUGGER** | Débogage avancé, root cause analysis | ✅ Bugs/Tests failing |
| **PERFORMANCE_ENGINEER** | Optimisation, profiling, budgets perf | ✅ Avant production |

---

## 📚 Standards et Principes

### Principes Architecturaux

Tous définis dans [`claude/standards/architectural-principles.md`](claude/standards/architectural-principles.md) :

#### SOLID
- **S**ingle Responsibility Principle
- **O**pen/Closed Principle
- **L**iskov Substitution Principle
- **I**nterface Segregation Principle
- **D**ependency Inversion Principle

#### Domain-Driven Design (DDD)
- Ubiquitous Language
- Entities vs Value Objects
- Aggregates & Aggregate Roots
- Domain Events
- Repositories
- Bounded Contexts & Anti-Corruption Layer

#### Test-Driven Development (TDD)
- Red-Green-Refactor cycle
- Tests FIRST (Fast, Independent, Repeatable, Self-Validating, Timely)
- Test Doubles (Stub, Mock, Fake)

#### Clean Code
- Fonctions font UNE chose
- Niveau d'abstraction unique
- ≤ 3 paramètres par fonction
- Command Query Separation
- Code auto-documenté

#### Design Patterns
- **Creational** : Factory, Builder
- **Structural** : Adapter, Decorator
- **Behavioral** : Strategy, Observer

#### Patterns Architecturaux
- Layered Architecture
- Hexagonal Architecture (Ports & Adapters)
- CQRS (Command Query Responsibility Segregation)

### Frontend Design Principles

Définis dans [`claude/standards/frontend-design-principles.md`](claude/standards/frontend-design-principles.md) :

#### Anti "AI Slop" Aesthetic
- ❌ **Fonts interdites** : Inter, Roboto, Arial, Space Grotesk
- ✅ **Fonts distinctives** : Adaptées au contexte projet
- ❌ **Éviter** : Purple gradients génériques, palettes équi-distribuées
- ✅ **Stratégie** : Couleur dominante 70% + accents tranchants 30%
- ✅ **Animations** : Orchestrées (staggered page load), pas partout
- ✅ **Backgrounds** : Profondeur et atmosphère (pas fonds unis)

### Standards de Qualité

Tous définis dans [`claude/standards/code-quality-rules.md`](claude/standards/code-quality-rules.md) :

```yaml
Complexité:
  - Complexité cyclomatique ≤ 10 par fonction
  - Complexité cognitive ≤ 15 par fonction
  - Profondeur imbrication ≤ 4 niveaux

Taille:
  - Fonctions ≤ 50 lignes (idéal ≤ 30)
  - Fichiers ≤ 500 lignes (idéal ≤ 300)
  - Paramètres ≤ 4 par fonction

Qualité:
  - Duplication ≤ 3% du code
  - Pas de bugs patterns
  - Pas de code mort
  - Early returns privilégiés

TypeScript:
  - Strict mode activé
  - Pas de 'any'
  - Types explicites sur fonctions publiques
```

---

## 🚀 Installation

### Prérequis

- [Claude Code CLI](https://claude.ai/claude-code) installé
- Git configuré
- Node.js (pour projets JavaScript/TypeScript)

### Setup

1. **Cloner ce repository** :
   ```bash
   git clone <repository-url> claude-config
   cd claude-config
   ```

2. **Configurer Claude Code** :

   Copier le dossier `claude/` vers votre configuration Claude :

   ```bash
   # macOS/Linux
   cp -r claude ~/.config/claude/

   # Ou lien symbolique (recommandé pour dev)
   ln -s $(pwd)/claude ~/.config/claude/
   ```

3. **Vérifier la configuration** :
   ```bash
   claude-code --version
   # Vérifier que les agents sont chargés
   ```

---

## 💻 Utilisation

### Commandes de Base

#### Appeler l'Orchestrator (Point d'entrée recommandé)

```bash
claude-code @orchestrator "Créer un module de gestion d'utilisateurs avec:
- API REST (NestJS)
- Interface admin (React)
- Tests complets
- Documentation"
```

#### Appeler un Agent Spécifique

```bash
# Validation architecture
claude-code @architect "Review l'architecture du module payment"

# Création de composants UI
claude-code @designer "Créer un composant Card réutilisable avec variants"

# Tests
claude-code @tester "Créer les tests E2E pour le flow d'inscription"

# Sécurité
claude-code @security "Audit de sécurité du module authentication"

# Débogage
claude-code @debugger "Analyser pourquoi les tests de paiement échouent"

# Performance
claude-code @performance "Profiler l'application et identifier les bottlenecks"

# DevOps
claude-code @devops "Setup pipeline CI/CD GitHub Actions"
```

---

## 🔄 Workflow Standard (3-Stage Pipeline)

### Stage 1 : Specification & Design ⚠️ BLOQUANT

```
1. ORCHESTRATOR analyse la demande
2. CONTEXT_MANAGER optimise le contexte (auto)
3. ARCHITECT valide faisabilité et approche technique
4. SECURITY_ENGINEER identifie les risques (si auth/payment/PII)
5. Output : ADR créé avec décisions architecturales

✅ Critère de passage : ARCHITECT approuve
```

### Stage 2 : Design & Test Preparation (Parallèle)

```
En parallèle :
- DESIGNER conçoit les interfaces (si UI)
- TESTER écrit les tests (TDD - red state)
- ERROR_COORDINATOR définit stratégie erreurs
- PERFORMANCE_ENGINEER définit budgets perf

✅ Critère de passage : Tous les outputs validés
```

### Stage 3 : Implementation, Review & Deployment (Séquentiel)

```
Séquentiel :
1. FULLSTACK_DEV implémente le code
2. TESTER exécute les tests (doivent passer ✅)
3. DEBUGGER intervient si bugs 🐛
4. REVIEWER valide le code
5. SECURITY_ENGINEER security review (si code critique)
6. PERFORMANCE_ENGINEER vérifie budgets
7. DEVOPS déploie en production

✅ Critère de complétion : Tests passent, reviews OK, déployé
```

---

## 📁 Structure du Projet

```
claude-config/
├── README.md                           # Ce fichier
├── claude/
│   ├── CLAUDE.md                       # Documentation système multi-agents
│   ├── config.yaml                     # Configuration Claude
│   ├── settings.local.json             # Settings locaux
│   │
│   ├── agents/                         # Agents spécialisés
│   │   ├── orchestrator.md             # Coordination générale
│   │   ├── architect.md                # ⚠️ Garant qualité (VETO)
│   │   ├── designer.md                 # UI/UX & Design system
│   │   ├── fullstack-dev.md            # Développement full stack
│   │   ├── tester.md                   # Tests & QA
│   │   ├── reviewer.md                 # Code review
│   │   ├── devops.md                   # CI/CD & Infrastructure
│   │   ├── security-engineer.md        # Sécurité OWASP
│   │   ├── error-coordinator.md        # Gestion erreurs
│   │   ├── context-manager.md          # Optimisation contexte
│   │   ├── debugger.md                 # Débogage avancé
│   │   └── performance-engineer.md     # Optimisation performances
│   │
│   └── standards/                      # Standards de qualité
│       ├── architectural-principles.md  # SOLID, DDD, TDD, Clean Code
│       ├── frontend-design-principles.md # Anti "AI slop" aesthetic
│       ├── code-quality-rules.md        # Standards qualité code
│       ├── linting_formatting.md        # ESLint, Prettier config
│       ├── logging_monitoring.md        # Sentry, Winston setup
│       └── quality_sonarqube.md         # SonarQube configuration
│
└── .git/                               # Git repository
```

---

## 🎯 Classification des Projets

L'ARCHITECT classifie chaque nouveau projet selon 3 niveaux pour adapter la stack technique.

### Niveau 1 : SIMPLE (Stack Minimaliste)

**Exemples** : Site vitrine, landing page, blog, portfolio

**Caractéristiques** :
- < 1000 visiteurs/jour
- Contenu majoritairement statique
- Pas de données sensibles
- Durée de vie : 3-12 mois

**Stack** :
- Frontend : Next.js (SSG) ou Astro
- Déploiement : Vercel / Netlify (gratuit)
- Qualité : ESLint + Prettier + TypeScript strict
- Monitoring : Logs plateforme (Vercel logs)

**Non requis** : ❌ SonarQube, Sentry, Docker, K8s

### Niveau 2 : MOYEN (Stack Standard)

**Exemples** : SaaS simple (< 10k users), app interne, e-commerce PME

**Caractéristiques** :
- 1k - 50k utilisateurs
- Données utilisateurs (auth, profils)
- Features modérées (5-15 modules)
- Durée de vie : > 1 an

**Stack** :
- Frontend : Next.js + Tailwind + shadcn/ui
- Backend : NestJS + PostgreSQL (Supabase/Railway)
- Qualité : ESLint + SonarCloud + Tests (coverage ≥ 70%)
- Monitoring : Sentry + Winston

**Non requis** : ❌ K8s, Prometheus/Grafana, tests de charge

### Niveau 3 : COMPLEXE (Stack Complète)

**Exemples** : SaaS multi-tenant (> 50k users), fintech, healthtech

**Caractéristiques** :
- > 50k utilisateurs actifs
- Données sensibles (finance, santé)
- Features complexes (> 20 modules)
- SLA critiques (99.9%+ uptime)

**Stack** :
- Frontend : Next.js + Redux + Design System custom
- Backend : NestJS + PostgreSQL (AWS RDS) + Redis + Queue
- Qualité : ESLint + SonarQube + Tests (coverage ≥ 80%) + E2E
- Monitoring : Sentry + ELK + APM + Datadog
- Sécurité : WAF, DDoS protection, penetration testing

**Obligatoire** : ✅ Tout

---

## 🔧 Outils Configurés

### Formatage et Linting (Tous Niveaux)

**Obligatoire pour TOUS les projets** :
- **ESLint** : Avec plugins sonarjs + security
- **Prettier** : Formatage automatique
- **Husky** : Pre-commit hooks
- **lint-staged** : Lint seulement fichiers modifiés

### Monitoring (Niveau 2 et 3)

**Obligatoire pour projets moyens et complexes** :
- **Sentry** : Error tracking + performance monitoring
- **Winston/Pino** : Logger structuré
- **Context enrichment** : User, requestId dans logs

### Qualité du Code (Niveau 2 et 3)

**Obligatoire pour projets moyens et complexes** :
- **SonarCloud** (Niveau 2) : Scan qualité automatique
- **SonarQube** (Niveau 3) : Self-hosted ou Enterprise
- **Quality Gates** : 0 bugs, coverage minimum, 0 vulnérabilités

---

## 📖 Documentation

### ADR (Architecture Decision Records)

Chaque décision technique importante doit être documentée dans un ADR :

**Format** :
```markdown
# ADR-001: Choix du state management

## Status
Accepted

## Context
[Pourquoi cette décision est nécessaire]

## Decision
[Quelle décision a été prise]

## Consequences
### Positive
- [Avantage 1]
### Negative
- [Inconvénient 1]

## Alternatives Considered
- [Alternative 1]
- [Alternative 2]
```

**ADR Obligatoires** :
- **ADR-000** : Classification du projet (Niveau 1/2/3) + justification stack

### Diagrammes C4

Maintenir des diagrammes C4 pour visualiser l'architecture :
1. **Context** : Vue d'ensemble du système
2. **Container** : Applications et bases de données
3. **Component** : Composants principaux
4. **Code** : Classes importantes (optionnel)

---

## 🛡️ Sécurité

### Checklist Sécurité (SECURITY_ENGINEER)

```
□ Pas de secrets en dur (credentials, API keys)
□ Validation des inputs (backend ET frontend)
□ Protection SQL injection (requêtes paramétrées)
□ Protection XSS (échappement outputs)
□ Protection CSRF (tokens)
□ Authentification robuste (bcrypt, JWT)
□ HTTPS obligatoire en production
□ Headers sécurisés (Helmet.js)
□ Rate limiting (prévention brute force)
□ Audit dépendances (npm audit, Snyk)
```

---

## 🧪 Tests

### Stratégie de Tests

**TDD (Test-Driven Development) encouragé** :
1. **RED** : Écrire test qui échoue
2. **GREEN** : Écrire minimum pour passer
3. **REFACTOR** : Améliorer le code

### Coverage Minimum

- **Niveau 1** : Tests basiques (pas de coverage minimum strict)
- **Niveau 2** : Coverage ≥ 70% du nouveau code
- **Niveau 3** : Coverage ≥ 80% + Tests E2E critiques

### Types de Tests

```yaml
Tests Unitaires:
  - Responsabilité: TESTER
  - Framework: Jest / Vitest
  - Coverage: Fonctions, classes, services

Tests Intégration:
  - Responsabilité: TESTER
  - Scope: API endpoints, DB queries

Tests E2E:
  - Responsabilité: TESTER
  - Framework: Playwright / Cypress
  - Scope: Flows utilisateur critiques (Niveau 2/3)
```

---

## 🎨 Design System

### Principes (DESIGNER)

**Éviter l'esthétique "AI slop"** :
- ❌ Pas de fonts génériques (Inter, Roboto, Arial, Space Grotesk)
- ✅ Fonts distinctives adaptées au contexte
- ❌ Pas de purple gradients sur blanc
- ✅ Palette avec dominance 70% + accents 30%
- ✅ Animations orchestrées (staggered page load)
- ✅ Backgrounds avec profondeur (layered gradients, patterns)

### Stack Recommandée

```yaml
Frontend:
  - Framework: React / Next.js
  - Styling: Tailwind CSS
  - Components: shadcn/ui
  - Animation: Framer Motion (complexe) ou CSS (simple)
  - Icons: Lucide React

Design Tokens:
  - CSS Variables pour couleurs
  - Système spacing 4px
  - Typography scale modulaire
```

---

## 🤝 Contribution

### Ajouter un Nouvel Agent

1. Créer `claude/agents/nouvel-agent.md`
2. Suivre le template des agents existants
3. Définir : Mission, Responsabilités, Tools Available, Format de livrable
4. Ajouter dans `claude/CLAUDE.md` table des agents
5. Documenter dans ce README

### Modifier les Standards

1. Éditer le fichier approprié dans `claude/standards/`
2. Ajouter exemples ✅ BON / ❌ MAUVAIS
3. Mettre à jour checklist de validation
4. Documenter le changement dans un commit clair

### Proposer des Améliorations

1. Créer une issue décrivant le problème/amélioration
2. Soumettre une PR avec :
   - Changements dans configuration
   - Exemples concrets
   - Documentation mise à jour
3. Vérifier que tous les agents restent cohérents

---

## 📝 Exemples d'Usage

### Exemple 1 : Créer un Nouveau Feature

```bash
# Utiliser l'orchestrator pour workflow complet
claude-code @orchestrator "Ajouter système de notifications en temps réel:
- Backend: WebSocket avec Socket.io
- Frontend: Composant NotificationCenter
- Persistance des notifications
- Tests complets"

# Le workflow 3-stage s'exécute automatiquement:
# Stage 1: ARCHITECT valide approche
# Stage 2: DESIGNER + TESTER travaillent en parallèle
# Stage 3: FULLSTACK_DEV implémente, REVIEWER valide
```

### Exemple 2 : Review de Code Existant

```bash
# Appeler reviewer directement
claude-code @reviewer "Review le code dans src/services/payment.service.ts"

# Résultat: Rapport avec scores + issues blocker/critical/major/minor
```

### Exemple 3 : Debugging

```bash
# Appeler debugger pour analyse approfondie
claude-code @debugger "Les tests d'intégration du module order échouent avec erreur 'Transaction timeout'"

# Résultat: Root cause analysis + suggestions fixes
```

### Exemple 4 : Classification Nouveau Projet

```bash
# Appeler architect au démarrage projet
claude-code @architect "Classifier ce projet:
- SaaS de gestion de tâches
- 5000 utilisateurs prévus à 6 mois
- Pas de données financières
- Budget limité
- Équipe de 2 devs"

# Résultat: ADR-000 avec classification NIVEAU 2 + stack recommandée
```

---

## 🔗 Ressources

### Documentation Officielle
- [Claude Code](https://claude.ai/claude-code)
- [Next.js](https://nextjs.org/docs)
- [NestJS](https://docs.nestjs.com/)
- [Tailwind CSS](https://tailwindcss.com/docs)

### Standards et Bonnes Pratiques
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Test-Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html)
- [Clean Code Principles](https://www.oreilly.com/library/view/clean-code-a/9780136083238/)

### Outils
- [SonarQube](https://www.sonarqube.org/)
- [Sentry](https://sentry.io/)
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👥 Auteurs

Configuration créée et maintenue par l'équipe de développement.

---

## 🙏 Remerciements

Cette configuration s'inspire des meilleures pratiques de l'industrie, notamment :
- Principes SOLID et Clean Code
- Domain-Driven Design (DDD)
- Test-Driven Development (TDD)
- Extreme Programming (XP)
- Patterns de conception éprouvés

---

**Pour toute question, consulter [`claude/CLAUDE.md`](claude/CLAUDE.md) ou créer une issue.**
