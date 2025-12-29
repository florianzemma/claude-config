# Instructions pour Claude Code

## Système Multi-Agent

Ce projet utilise un système de sub-agents spécialisés coordonnés par un orchestrateur central.

### Agents Disponibles

| Agent | Rôle | Commande | MCP Tools |
|-------|------|----------|-----------|
| ORCHESTRATOR | Coordination générale, décomposition des tâches | `@orchestrator` | filesystem, git |
| ARCHITECT | Standards, architecture, validation technique | `@architect` | filesystem, git |
| DESIGNER | UI/UX, design system, accessibilité | `@designer` | filesystem |
| FULLSTACK_DEV | Implémentation complète (frontend + backend) | `@dev` | filesystem, git, postgres |
| TESTER | Tests unitaires, intégration, E2E, QA | `@tester` | filesystem |
| REVIEWER | Code review, qualité, sécurité | `@reviewer` | filesystem, git |
| DEVOPS | CI/CD, déploiement, infrastructure | `@devops` | filesystem, git |

### Workflow Standard

**Toute demande suit ce pipeline :**

1. **ORCHESTRATOR** reçoit la demande et crée un plan d'exécution
2. **ARCHITECT** valide l'approche technique et les standards
3. **En parallèle :**
   - **DESIGNER** conçoit les interfaces (si nécessaire)
   - **TESTER** écrit les tests (TDD)
4. **FULLSTACK_DEV** implémente le code
5. **TESTER** exécute les tests
6. **REVIEWER** valide le code produit
7. **DEVOPS** déploie (si demandé)

### Standards Obligatoires

**⚠️ TOUT le code doit respecter les standards définis dans `.claude/standards/`**

### ⚠️ RÈGLE ANTI-OVER-ENGINEERING

**IMPORTANT : Les standards doivent être ADAPTÉS à la taille et complexité du projet.**

L'ARCHITECT doit classifier chaque nouveau projet selon 3 niveaux :

| Niveau | Type de Projet | Stack | Monitoring | Qualité |
|--------|---------------|-------|------------|---------|
| **1 - SIMPLE** | Site vitrine, landing page, blog | Minimaliste (Vercel/Netlify) | Logs plateforme | ESLint + Prettier |
| **2 - MOYEN** | SaaS simple, app interne, e-commerce PME | Standard (Railway/Render) | Sentry + Winston | SonarCloud + Tests 70% |
| **3 - COMPLEXE** | SaaS multi-tenant, fintech, healthtech | Complète (AWS/GCP/K8s) | Sentry + ELK + APM | SonarQube + Tests 80% + E2E |

**L'ARCHITECT DOIT créer un ADR-000 "Classification du projet" au démarrage de TOUT projet.**

**Exemples :**
- ❌ **BLOQUER** : SonarQube + Kubernetes pour un site vitrine (over-engineering)
- ✅ **APPROUVER** : ESLint + Vercel logs pour un site vitrine (adapté)
- ✅ **APPROUVER** : Stack complète pour un SaaS fintech (justifié)

**Pour les critères détaillés de classification, consulter :**
`.claude/agents/architect.md` → Section "Garant Contre l'Over-Engineering"

#### Nomenclature

**Fichiers :**
- Composants : `PascalCase.tsx`
- Hooks : `use-kebab-case.ts`
- Utils : `kebab-case.ts`
- Constants : `SCREAMING_SNAKE_CASE.ts`
- Types : `kebab-case.types.ts`

**Variables :**
- Constants : `SCREAMING_SNAKE_CASE`
- Functions : `camelCase`
- Classes : `PascalCase`
- Interfaces : `IPascalCase` ou `PascalCase`
- Types : `TPascalCase` ou `PascalCase`

#### Structure Frontend

```
src/
├── components/
│   ├── ui/           # Composants atomiques
│   ├── features/     # Composants métier
│   └── layouts/      # Layouts
├── hooks/
├── services/
├── stores/
├── utils/
├── types/
├── constants/
└── config/
```

#### Structure Backend

```
src/
├── modules/          # Feature modules (DDD)
│   └── [module]/
│       ├── controllers/
│       ├── services/
│       ├── repositories/
│       ├── dto/
│       └── entities/
├── common/
│   ├── decorators/
│   ├── filters/
│   ├── guards/
│   └── pipes/
└── config/
```

#### Principes de Code

- ✅ Single Responsibility Principle
- ✅ DRY (Don't Repeat Yourself)
- ✅ KISS (Keep It Simple)
- ✅ Pure functions quand possible
- ✅ Immutability par défaut
- ✅ Max 30 lignes par fonction
- ✅ Max 300 lignes par fichier
- ✅ TypeScript strict (pas de `any`)

### Formatage Automatique et Qualité du Code

**⚠️ RÈGLE OBLIGATOIRE : Tout projet DOIT utiliser un formatage automatique avec les meilleures règles de l'industrie**

#### Outils Requis par Écosystème

**JavaScript/TypeScript :**
- ESLint + Prettier + lint-staged + husky

**Python :**
- Black + Ruff/Flake8 + isort + pre-commit

**Autres :**
- Rust: rustfmt + clippy
- Go: gofmt + golangci-lint
- Java: google-java-format + checkstyle

#### Setup Automatique (Obligatoire)

**Pour TOUT nouveau projet, FULLSTACK_DEV DOIT :**

1. Installer les outils de formatage et linting
2. Configurer avec les best practices de l'industrie
3. Setup pre-commit hooks (husky ou équivalent)
4. Ajouter scripts npm: `lint`, `lint:fix`, `format`
5. Intégrer dans la CI/CD

#### Pre-commit Hooks (Non Négociable)

**Tout commit DOIT automatiquement :**
- ✅ Exécuter le linter avec fix automatique
- ✅ Formater le code avec Prettier/Black/etc
- ✅ Bloquer le commit si erreurs critiques

**Configuration via husky + lint-staged (JS/TS) ou pre-commit (Python)**

#### Responsabilités

**ARCHITECT :**
- Vérifier présence des outils dans TOUT nouveau projet
- Bloquer approbation si non configuré
- Valider que les règles sont strictes

**FULLSTACK_DEV :**
- Installer et configurer automatiquement au démarrage
- Ne jamais désactiver règles sans justification
- Exécuter `lint:fix` avant chaque commit

**DEVOPS :**
- Configurer hooks Git
- Intégrer vérification dans CI/CD
- Fail la build si linting échoue

**REVIEWER :**
- Rejeter code non formaté
- Vérifier qu'aucune règle n'est désactivée sans raison

#### Checklist Nouveau Projet

```
□ Linter installé (ESLint/Ruff/etc) ?
□ Formatter installé (Prettier/Black/etc) ?
□ Pre-commit hooks configurés ?
□ Scripts npm/make créés ?
□ Règles strictes activées (no-any, etc) ?
□ .gitignore configuré ?
□ CI/CD vérifie le linting ?
□ README documente les commandes ?
```

#### Configuration Détaillée

**Pour les configurations complètes (ESLint, Prettier, etc), consulter :**
`.claude/standards/linting_formatting.md`

**Exemple minimal (JavaScript/TypeScript) :**

```json
{
  "devDependencies": {
    "eslint": "latest",
    "prettier": "latest",
    "lint-staged": "latest",
    "husky": "latest"
  },
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "prepare": "husky install"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"]
  }
}
```

#### Pourquoi Cette Règle ?

1. **Cohérence** : Code uniforme dans toute l'équipe
2. **Qualité** : Détection automatique d'erreurs
3. **Productivité** : Pas de débats sur le style
4. **Automatisation** : Formatage garanti sans effort
5. **Standards** : Best practices de l'industrie respectées

**⚠️ Aucun projet ne peut être livré sans ces outils configurés.**

### Logging et Monitoring

**⚠️ RÈGLE : Standards de logging/monitoring ADAPTÉS selon le niveau du projet**

**Application selon le niveau :**
- **NIVEAU 1 (Simple)** : Logs plateforme (Vercel/Netlify) + Analytics basiques → Sentry/Winston NON REQUIS
- **NIVEAU 2 (Moyen)** : Sentry (gratuit) + Winston → OBLIGATOIRE
- **NIVEAU 3 (Complexe)** : Sentry + Winston + Logs centralisés (ELK) + APM → OBLIGATOIRE

#### Outils Requis

**JavaScript/TypeScript :**
- Sentry (error tracking & performance monitoring)
- Winston ou Pino (logging structuré)

**Python :**
- Sentry
- Structlog

**Autres :**
- Rust: Sentry + tracing
- Go: Sentry + Zap/Logrus
- Java: Sentry + SLF4J/Logback

#### Setup Automatique (Obligatoire)

**Pour TOUT nouveau projet, FULLSTACK_DEV DOIT :**

1. Installer et configurer Sentry (error tracking)
2. Installer logger structuré (Winston/Pino/Structlog)
3. Configurer les niveaux de log appropriés
4. Setup context enrichment (user, request ID, etc)
5. Configurer les alertes critiques
6. Intégrer dans la CI/CD (release tracking)

#### Responsabilités

**ARCHITECT :**
- Vérifier présence de Sentry dans TOUT nouveau projet
- Bloquer approbation si monitoring non configuré
- Valider la stratégie de logging

**FULLSTACK_DEV :**
- Installer et configurer automatiquement au démarrage
- Implémenter le logging structuré partout
- Capturer les erreurs avec contexte riche

**DEVOPS :**
- Configurer variables d'environnement Sentry
- Setup release tracking dans CI/CD
- Configurer les alertes et webhooks

**REVIEWER :**
- Vérifier que les erreurs sont capturées avec Sentry
- Valider le niveau de détail des logs
- S'assurer qu'aucune donnée sensible n'est loggée

#### Checklist Nouveau Projet

```
□ Sentry installé et configuré ?
□ DSN Sentry en variable d'environnement ?
□ Logger structuré (Winston/Pino) installé ?
□ Context enrichment implémenté ?
□ Performance monitoring activé ?
□ Alertes configurées ?
□ Données sensibles filtrées ?
```

#### Configuration Détaillée

**Pour la configuration complète Sentry/Winston, consulter :**
`.claude/standards/logging_monitoring.md`

**⚠️ Les projets de NIVEAU 2 et 3 ne peuvent être déployés en production sans monitoring Sentry configuré.**

### Standards de Qualité du Code (OBLIGATOIRE TOUS PROJETS)

**⚠️ RÈGLE ABSOLUE : Les STANDARDS de qualité sont OBLIGATOIRES pour TOUS les projets. L'OUTIL de vérification varie selon le niveau.**

**STANDARDS OBLIGATOIRES (Tous Niveaux) :**

```yaml
Complexité:
  - Complexité cyclomatique ≤ 10 par fonction
  - Complexité cognitive ≤ 15 par fonction
  - Profondeur imbrication ≤ 4 niveaux

Taille:
  - Fonctions ≤ 50 lignes
  - Fichiers ≤ 500 lignes
  - Paramètres ≤ 4 par fonction

Qualité:
  - Duplication ≤ 3% du code
  - Pas de bugs patterns
  - Pas de code mort
  - Early returns privilégiés

TypeScript:
  - Pas de 'any'
  - Types explicites
  - Strict mode

Sécurité:
  - Pas de credentials hardcodés
  - Pas de SQL injection
  - Validation inputs
```

**OUTILS de vérification (selon niveau) :**

- **NIVEAU 1 (Simple)** : ESLint + plugins (sonarjs, security) + review manuelle → SonarQube NON REQUIS
- **NIVEAU 2 (Moyen)** : ESLint + SonarCloud (automatise vérification) + Coverage ≥ 70% → OBLIGATOIRE
- **NIVEAU 3 (Complexe)** : ESLint + SonarQube + Coverage ≥ 80% + Tests E2E + Security scans → OBLIGATOIRE

**Objectif** : Si vous installez SonarQube demain sur n'importe quel projet → note A garantie

#### Configuration ESLint Obligatoire (Tous Niveaux)

**TOUS les projets DOIVENT avoir cette configuration minimale :**

```json
{
  "plugins": ["@typescript-eslint", "sonarjs", "security"],
  "rules": {
    "complexity": ["error", 10],
    "max-lines-per-function": ["error", { "max": 50 }],
    "@typescript-eslint/no-explicit-any": "error",
    "sonarjs/cognitive-complexity": ["error", 15],
    "sonarjs/no-duplicate-string": ["error", 3],
    "sonarjs/no-identical-functions": "error"
  }
}
```

**Packages requis :**
```bash
npm install --save-dev eslint-plugin-sonarjs eslint-plugin-security
```

#### Seuils de Qualité Minimums (Tous Projets)

**AUCUN code ne doit être mergé si ces seuils ne sont pas respectés (vérifiés par ESLint ou SonarQube selon niveau) :**

```yaml
Code Quality (TOUS NIVEAUX):
□ Complexité cyclomatique ≤ 10 par fonction
□ Complexité cognitive ≤ 15 par fonction
□ Fonctions ≤ 50 lignes
□ Profondeur ≤ 4 niveaux
□ Duplication ≤ 3%
□ Pas de code mort
□ Pas de 'any' en TypeScript
□ Pas de bugs patterns

NIVEAU 2 et 3 (avec SonarQube):
□ Coverage nouveau code : ≥ 70% (N2) ou ≥ 80% (N3)
□ Maintainability Rating : A
□ Security Rating : A
□ Reliability Rating : A
□ Technical Debt Ratio : ≤ 5%
□ Nouveaux bugs : 0
□ Nouvelles vulnérabilités : 0
```

#### Setup Automatique

**TOUS LES NIVEAUX (OBLIGATOIRE) :**

```bash
# 1. Configuration ESLint avec plugins qualité
npm install --save-dev \
  eslint \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  eslint-plugin-sonarjs \
  eslint-plugin-security \
  prettier \
  lint-staged \
  husky

# 2. Configuration des règles (voir configuration ci-dessus)

# 3. Pre-commit hooks
npx husky install
```

**NIVEAU 2 et 3 UNIQUEMENT (OBLIGATOIRE) :**

1. Configurer SonarCloud (N2) ou SonarQube self-hosted (N3)
2. Créer sonar-project.properties
3. Intégrer dans CI/CD (GitHub Actions/GitLab CI)
4. Configurer Quality Gates
5. Activer PR decoration (commentaires automatiques)
6. Générer coverage reports dans les tests

#### Responsabilités

**ARCHITECT (TOUS NIVEAUX) :**
- ✅ Vérifier configuration ESLint complète (plugins sonarjs + security)
- ✅ Bloquer si standards de qualité non respectés (complexité, duplication, etc.)
- ✅ Review manuel si NIVEAU 1 (pas de SonarQube)
- ✅ Vérifier SonarQube configuré pour NIVEAU 2 et 3
- ✅ Bloquer si Quality Gate échoue (N2/N3)

**FULLSTACK_DEV (TOUS NIVEAUX) :**
- ✅ Respecter les standards : fonctions < 50 lignes, complexité < 10, etc.
- ✅ Exécuter `npm run lint` avant commit (0 erreurs requis)
- ✅ Pas de 'any' en TypeScript
- ✅ Pas de duplication de code
- ✅ NIVEAU 2/3 : Corriger issues SonarQube Blocker/Critical
- ✅ NIVEAU 2/3 : Maintenir coverage ≥ 70% (N2) ou ≥ 80% (N3)

**DEVOPS (SELON NIVEAU) :**
- ✅ TOUS : Configurer hooks Git (husky)
- ✅ TOUS : Intégrer ESLint dans CI/CD
- ✅ NIVEAU 2/3 : Configurer SonarQube dans CI/CD
- ✅ NIVEAU 2/3 : Setup tokens et secrets
- ✅ NIVEAU 2/3 : Monitorer Technical Debt global

**REVIEWER (TOUS NIVEAUX) :**
- ✅ Vérifier que ESLint passe (0 erreurs)
- ✅ NIVEAU 1 : Review manuel approfondi (complexité, duplication, longueur)
- ✅ NIVEAU 2/3 : Vérifier SonarQube report dans la PR
- ✅ NIVEAU 2/3 : Bloquer si Quality Gate échoue
- ✅ Rejeter code ne respectant pas les standards (peu importe l'outil)

#### Checklist Nouveau Projet

**TOUS LES NIVEAUX (OBLIGATOIRE) :**
```
□ Configuration ESLint complète (plugins sonarjs + security) ?
□ Prettier configuré ?
□ Pre-commit hooks (husky) configurés ?
□ tsconfig.json en strict mode ?
□ Scripts npm (lint, lint:fix, format) créés ?
□ .gitignore configuré ?
□ CI/CD vérifie ESLint (fail si erreurs) ?
□ README documente les commandes ?
```

**NIVEAU 2 et 3 UNIQUEMENT (OBLIGATOIRE) :**
```
□ SonarCloud (N2) ou SonarQube (N3) configuré ?
□ Token Sonar en secret CI/CD ?
□ sonar-project.properties créé ?
□ Quality Gates configurés (coverage, bugs, vulnérabilités) ?
□ Intégration CI/CD active (scan automatique) ?
□ Coverage reports générés par les tests ?
□ PR decoration activée (commentaires auto) ?
□ Règles Security/OWASP activées ?
```

#### Configuration Détaillée

**Pour les standards de qualité complets (règles, exemples, ESLint config), consulter :**
`.claude/standards/code-quality-rules.md`

**Pour la configuration SonarQube (NIVEAU 2 et 3), consulter :**
`.claude/standards/quality_sonarqube.md`

**⚠️ Tous les projets doivent respecter les standards de qualité. SonarQube (NIVEAU 2/3) automatise simplement la vérification.**

#### Git Conventions

```
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore, perf
```

**Exemples :**
```
feat(auth): add OAuth2 Google provider
fix(cart): resolve quantity update race condition
refactor(api): extract validation middleware
```

### Gestion des Versions de Packages

**⚠️ RÈGLE IMPORTANTE : Toujours utiliser les versions les plus récentes disponibles**

#### Nouveaux Projets (From Scratch)

Pour tout nouveau projet, les agents **DOIVENT** :

1. **Vérifier les versions** avant toute installation :
   ```bash
   npm view <package> version        # Dernière version stable
   npm view <package> versions       # Toutes les versions disponibles
   npm info <package>                # Info complète
   ```

2. **Utiliser les versions les plus récentes stables** :
   ```bash
   # ❌ MAUVAIS : Version obsolète
   npm install react@17.0.0

   # ✅ BON : Dernière version
   npm install react@latest
   npm install react@^19.0.0  # ou version spécifique récente
   ```

3. **Documenter les versions choisies** dans PROJECT_SPECS.md ou README

#### Projets Existants

Pour un projet existant, **être prudent** :

1. **Analyser d'abord** le package.json existant
2. **Consulter ARCHITECT** avant de faire des upgrades majeurs
3. **Tester** après chaque upgrade significative
4. **Upgrader progressivement** (une dépendance à la fois pour les breaking changes)

#### Processus de Vérification

**Avant toute installation, suivre ce workflow :**

```bash
# 1. Vérifier la dernière version
npm view <package> version

# 2. Vérifier la compatibilité (lire CHANGELOG)
npm view <package> homepage  # Lien vers docs

# 3. Installer avec la version explicite
npm install <package>@^X.Y.Z

# 4. Documenter dans le commit
git commit -m "chore(deps): add <package>@X.Y.Z (latest)"
```

#### Exemples Concrets

```bash
# ✅ BON : Nouveau projet React
npm install react@^19.0.0 react-dom@^19.0.0
npm install next@^15.1.0
npm install typescript@^5.3.3

# ❌ MAUVAIS : Versions obsolètes
npm install react@^17.0.0      # Version de 2020
npm install next@^12.0.0       # Plusieurs versions en retard
npm install typescript@^4.0.0  # Version obsolète
```

#### Cas Particuliers

**Dépendances avec breaking changes fréquents :**
- Utiliser `^` pour les mises à jour mineures automatiques
- Exemple : `"react": "^19.0.0"` accepte 19.0.x et 19.x.x

**Projets en production :**
- Utiliser des versions exactes si stabilité critique
- Exemple : `"react": "19.0.2"` (sans `^`)

**Dépendances beta/alpha :**
- Éviter sauf si explicitement demandé
- Préférer `@latest` (stable) à `@next` (beta)

#### Outils Recommandés

```bash
# Vérifier les packages obsolètes
npm outdated

# Mettre à jour interactivement
npm update

# Auditer la sécurité
npm audit
npm audit fix
```

#### Checklist pour FULLSTACK_DEV et DEVOPS

Avant d'installer une dépendance :

```
□ Ai-je vérifié la dernière version avec npm view ?
□ Ai-je lu le CHANGELOG pour les breaking changes ?
□ Est-ce un nouveau projet ? → Utiliser @latest
□ Est-ce un projet existant ? → Consulter ARCHITECT
□ Ai-je documenté la version dans le commit ?
□ Ai-je testé après l'installation ?
```

#### Responsabilités

- **FULLSTACK_DEV** : Vérifier et installer les versions récentes
- **ARCHITECT** : Valider les choix de versions (surtout breaking changes)
- **DEVOPS** : Monitorer les vulnérabilités (npm audit)
- **REVIEWER** : Vérifier que les versions sont à jour dans le code review

#### Pourquoi cette règle ?

1. **Sécurité** : Les nouvelles versions corrigent des vulnérabilités
2. **Performance** : Optimisations et améliorations
3. **Fonctionnalités** : Accès aux dernières features
4. **Maintenabilité** : Moins de dette technique dès le départ
5. **Support** : Les vieilles versions ne sont plus maintenues

**⚠️ Exception :** Si l'utilisateur spécifie explicitement une version, respecter son choix.

### MCP Servers Configurés

Les agents ont accès à ces outils via MCP :

- **filesystem** : Lecture/écriture de fichiers
- **git** : Opérations Git (commit, branch, etc.)
- **postgres** : Base de données (si configuré)

### Communication entre Agents

Les agents communiquent via un format JSON structuré :

```json
{
  "task_id": "unique_id",
  "type": "request|response|status|error",
  "from": "agent_source",
  "to": "agent_destination",
  "priority": "critical|high|medium|low",
  "payload": {},
  "dependencies": [],
  "deadline": "ISO8601"
}
```

### Utilisation

#### Demande complète (via ORCHESTRATOR)

```bash
claude-code @orchestrator "Créer un module de gestion d'utilisateurs avec:
- API REST (NestJS)
- Interface admin (React)
- Tests complets
- Documentation"
```

#### Demande directe à un agent

```bash
# Validation architecture
claude-code @architect "Review l'architecture du module payment"

# Création de composants
claude-code @designer "Créer un composant Card réutilisable avec variants"

# Tests
claude-code @tester "Créer les tests E2E pour le flow d'inscription"

# DevOps
claude-code @devops "Setup pipeline CI/CD GitHub Actions"
```

### Points Clés

1. **L'ORCHESTRATOR est le point d'entrée unique** pour les tâches complexes
2. **L'ARCHITECT a un droit de veto** - Aucun code ne passe sans validation
3. **Travail parallèle maximisé** - DESIGNER et TESTER travaillent en simultané
4. **Standards non négociables** - Définis dans `.claude/standards/`
5. **Validation systématique** - Tout passe par REVIEWER avant livraison

### Résolution de Conflits

En cas de désaccord entre agents :
1. ORCHESTRATOR collecte les avis
2. ARCHITECT tranche sur les aspects techniques
3. DESIGNER tranche sur les aspects UI/UX
4. La décision est documentée (ADR)

### Monitoring

- Chaque agent log ses actions
- Les erreurs sont remontées à ORCHESTRATOR
- Les blocages sont signalés immédiatement

---

**Pour plus de détails, consulter :**
- `.claude/agents/` : Configuration détaillée de chaque agent
- `.claude/standards/` : Standards complets
- `docs/architecture.md` : Architecture globale du système
