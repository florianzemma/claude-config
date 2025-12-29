# Standards de Qualité - SonarQube

**⚠️ RÈGLE OBLIGATOIRE : Tout projet DOIT respecter les standards de qualité SonarQube pour garantir un code maintenable et sans dette technique**

## Pourquoi SonarQube ?

1. **Qualité** : Détection automatique de bugs, code smells et vulnérabilités
2. **Dette technique** : Mesure et suivi de la dette technique
3. **Sécurité** : Identification des failles de sécurité (OWASP Top 10)
4. **Maintenabilité** : Assure un code facile à maintenir
5. **Standards** : Respect des best practices de l'industrie
6. **CI/CD** : Intégration dans le pipeline de déploiement

## SonarQube vs Alternatives

- **SonarQube** : Solution complète (recommandé)
- **SonarCloud** : Version cloud (gratuit pour projets open-source)
- **CodeClimate** : Alternative cloud
- **DeepSource** : Alternative moderne
- **ESLint + Extensions** : Minimum requis si SonarQube impossible

## Installation et Configuration

### Option 1 : SonarCloud (Recommandé pour démarrer)

**Gratuit pour projets open-source, abordable pour privés**

```bash
# 1. Créer compte sur sonarcloud.io
# 2. Connecter votre repo GitHub/GitLab/Bitbucket
# 3. Installer le scanner
npm install --save-dev sonarqube-scanner
```

### Option 2 : SonarQube Self-Hosted

```yaml
# docker-compose.yml
version: '3'

services:
  sonarqube:
    image: sonarqube:latest-community
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: ${SONAR_DB_PASSWORD}
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: ${SONAR_DB_PASSWORD}
      POSTGRES_DB: sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:
  postgresql:
  postgresql_data:
```

## Configuration par Projet

### JavaScript/TypeScript

```javascript
// sonar-project.js
const sonarqubeScanner = require('sonarqube-scanner');

sonarqubeScanner(
  {
    serverUrl: process.env.SONAR_HOST_URL || 'http://localhost:9000',
    token: process.env.SONAR_TOKEN,
    options: {
      'sonar.projectKey': 'my-project',
      'sonar.projectName': 'My Project',
      'sonar.projectVersion': '1.0.0',
      'sonar.sources': 'src',
      'sonar.tests': 'src',
      'sonar.test.inclusions': '**/*.test.ts,**/*.test.tsx,**/*.spec.ts',
      'sonar.exclusions': '**/node_modules/**,**/dist/**,**/coverage/**,**/*.test.ts,**/*.spec.ts',
      'sonar.typescript.lcov.reportPaths': 'coverage/lcov.info',
      'sonar.javascript.lcov.reportPaths': 'coverage/lcov.info',
      'sonar.testExecutionReportPaths': 'test-report.xml',

      // Quality gates
      'sonar.qualitygate.wait': true,
    },
  },
  () => process.exit()
);
```

```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:coverage": "jest --coverage",
    "sonar": "node sonar-project.js",
    "sonar:check": "npm run test:coverage && npm run sonar"
  },
  "devDependencies": {
    "sonarqube-scanner": "^3.3.0"
  }
}
```

### Configuration File (sonar-project.properties)

```properties
# Project identification
sonar.projectKey=my-project
sonar.projectName=My Project
sonar.projectVersion=1.0.0

# Source code
sonar.sources=src
sonar.tests=src
sonar.test.inclusions=**/*.test.ts,**/*.test.tsx,**/*.spec.ts
sonar.exclusions=**/node_modules/**,**/dist/**,**/coverage/**,**/*.test.ts,**/*.spec.ts

# Coverage
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.typescript.lcov.reportPaths=coverage/lcov.info

# Encoding
sonar.sourceEncoding=UTF-8

# Language
sonar.language=ts
```

## Quality Gates - Standards Minimums

**⚠️ AUCUN code ne doit être mergé si ces seuils ne sont pas respectés :**

### Seuils Obligatoires

```yaml
Quality Gate Conditions:
  # Bugs
  - metric: "new_bugs"
    operator: "GT"
    value: 0
    status: "ERROR"  # Aucun nouveau bug accepté

  # Vulnerabilities
  - metric: "new_vulnerabilities"
    operator: "GT"
    value: 0
    status: "ERROR"  # Aucune nouvelle vulnérabilité

  # Code Smells
  - metric: "new_code_smells"
    operator: "GT"
    value: 5
    status: "WARNING"

  # Coverage
  - metric: "new_coverage"
    operator: "LT"
    value: 80
    status: "ERROR"  # Minimum 80% coverage

  # Duplication
  - metric: "new_duplicated_lines_density"
    operator: "GT"
    value: 3
    status: "ERROR"  # Max 3% duplication

  # Maintainability Rating
  - metric: "new_maintainability_rating"
    operator: "GT"
    value: 1  # A rating
    status: "ERROR"

  # Security Rating
  - metric: "new_security_rating"
    operator: "GT"
    value: 1  # A rating
    status: "ERROR"

  # Reliability Rating
  - metric: "new_reliability_rating"
    operator: "GT"
    value: 1  # A rating
    status: "ERROR"
```

### Ratings Expliquées

**A = Excellent | B = Bon | C = Moyen | D = Mauvais | E = Très mauvais**

- **Maintainability (A)** : Peu de code smells, facile à maintenir
- **Reliability (A)** : Pas de bugs
- **Security (A)** : Pas de vulnérabilités

## Intégration CI/CD

### GitHub Actions

```yaml
# .github/workflows/quality.yml
name: Code Quality

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for better analysis

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run tests with coverage
        run: npm run test:coverage

      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          args: >
            -Dsonar.projectKey=my-project
            -Dsonar.organization=my-org
            -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info

      - name: Quality Gate Check
        uses: SonarSource/sonarqube-quality-gate-action@master
        timeout-minutes: 5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          scanMetadataReportFile: .scannerwork/report-task.txt
```

### GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - test
  - quality

test:
  stage: test
  script:
    - npm ci
    - npm run test:coverage
  artifacts:
    paths:
      - coverage/

sonarqube:
  stage: quality
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_NAME}
      -Dsonar.sources=src
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.login=${SONAR_TOKEN}
  only:
    - main
    - develop
    - merge_requests
```

## Règles Importantes à Activer

### Security Hotspots (OWASP)

```yaml
Security Rules (Always Active):
  - SQL Injection prevention
  - XSS prevention
  - CSRF token validation
  - Hardcoded credentials detection
  - Weak cryptography detection
  - Path traversal prevention
  - Command injection prevention
  - Insecure randomness
  - Cookie security (HttpOnly, Secure flags)
  - Sensitive data exposure
```

### Code Smells Critiques

```yaml
Critical Code Smells:
  - Cognitive Complexity > 15
  - Function length > 50 lines
  - File length > 500 lines
  - Too many parameters (> 4)
  - Nested depth > 4
  - Duplicated code blocks
  - Unused variables/imports
  - Magic numbers
  - Empty catch blocks
  - console.log in production code
```

### TypeScript Specific

```yaml
TypeScript Rules:
  - No 'any' type (use 'unknown' instead)
  - Strict null checks
  - No implicit any
  - No unused locals
  - No unused parameters
  - Prefer const over let
  - No var keyword
  - Explicit return types on public functions
```

## Résolution des Issues

### Classification des Issues

**Blocker** : DOIT être corrigé avant merge
```typescript
// ❌ BLOCKER : Hardcoded password
const password = "admin123";

// ✅ FIXED
const password = process.env.DB_PASSWORD;
```

**Critical** : DOIT être corrigé rapidement
```typescript
// ❌ CRITICAL : SQL Injection vulnerability
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ FIXED
const query = `SELECT * FROM users WHERE id = $1`;
const result = await db.query(query, [userId]);
```

**Major** : Doit être corrigé avant release
```typescript
// ❌ MAJOR : Function too complex (complexity 25)
function processOrder(order, user, payment, shipping) {
  if (order.status === 'pending') {
    if (user.isVerified) {
      if (payment.isValid) {
        // ... 50 more lines
      }
    }
  }
}

// ✅ FIXED : Split into smaller functions
function processOrder(order, user, payment, shipping) {
  validateOrderStatus(order);
  validateUser(user);
  validatePayment(payment);
  return executeOrder(order, shipping);
}
```

**Minor** : Amélioration recommandée
```typescript
// ❌ MINOR : Console.log left in code
console.log('Debug:', data);

// ✅ FIXED : Use proper logger
logger.debug('Processing data', { data });
```

## Dashboard et Métriques

### Métriques Clés à Suivre

```yaml
Key Metrics:
  # Qualité du nouveau code
  - New Code Coverage: ≥ 80%
  - New Duplicated Lines: ≤ 3%
  - New Code Smells: 0-5

  # Qualité globale
  - Overall Coverage: ≥ 70%
  - Overall Duplicated Lines: ≤ 5%
  - Technical Debt Ratio: ≤ 5%

  # Sécurité
  - Vulnerabilities: 0
  - Security Hotspots: 0 (reviewed)
  - Security Rating: A

  # Fiabilité
  - Bugs: 0 (in new code)
  - Reliability Rating: A
```

### Technical Debt

```
Technical Debt = Effort to fix all issues

Ratings:
  ≤ 5%  : A (Excellent)
  6-10% : B (Good)
  11-20%: C (Average)
  21-50%: D (Bad)
  > 50% : E (Very bad)

⚠️ Ne JAMAIS accepter un Technical Debt > 10%
```

## Pull Request Comments

SonarQube peut commenter automatiquement les PR :

```yaml
# Configuration SonarCloud
sonar.pullrequest.github.repository=org/repo
sonar.pullrequest.provider=github

# Les commentaires incluent :
# - Nouvelles issues détectées
# - Quality Gate status
# - Couverture de code modifiée
# - Duplication détectée
```

## Exemples de Corrections

### Complexité Cognitive Élevée

```typescript
// ❌ AVANT : Cognitive Complexity = 18
function calculateDiscount(user, cart, promo) {
  if (user.isPremium) {
    if (cart.total > 100) {
      if (promo && promo.isValid) {
        if (promo.type === 'percentage') {
          return cart.total * (1 - promo.value / 100);
        } else if (promo.type === 'fixed') {
          return cart.total - promo.value;
        }
      } else {
        return cart.total * 0.9;
      }
    } else {
      return cart.total;
    }
  } else {
    if (cart.total > 200) {
      return cart.total * 0.95;
    } else {
      return cart.total;
    }
  }
}

// ✅ APRÈS : Cognitive Complexity = 4
function calculateDiscount(user: User, cart: Cart, promo?: Promo): number {
  if (!user.isPremium) {
    return calculateStandardDiscount(cart);
  }

  if (cart.total <= 100) {
    return cart.total;
  }

  return calculatePremiumDiscount(cart, promo);
}

function calculateStandardDiscount(cart: Cart): number {
  return cart.total > 200 ? cart.total * 0.95 : cart.total;
}

function calculatePremiumDiscount(cart: Cart, promo?: Promo): number {
  if (!promo?.isValid) {
    return cart.total * 0.9;
  }

  return promo.type === 'percentage'
    ? cart.total * (1 - promo.value / 100)
    : cart.total - promo.value;
}
```

### Code Dupliqué

```typescript
// ❌ AVANT : Duplication
function fetchUsers() {
  const token = localStorage.getItem('token');
  return axios.get('/users', {
    headers: { Authorization: `Bearer ${token}` }
  });
}

function fetchOrders() {
  const token = localStorage.getItem('token');
  return axios.get('/orders', {
    headers: { Authorization: `Bearer ${token}` }
  });
}

// ✅ APRÈS : DRY
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
```

## Checklist Nouveau Projet

```
□ SonarQube/SonarCloud configuré ?
□ Token Sonar ajouté aux secrets CI/CD ?
□ sonar-project.properties créé ?
□ Quality Gates configurés (80% coverage, 0 bugs, etc) ?
□ Intégration CI/CD active ?
□ Coverage reports générés par les tests ?
□ Pull Request decoration activée ?
□ Équipe a accès au dashboard SonarQube ?
□ Règles TypeScript strictes activées ?
□ Security hotspots configurés (OWASP) ?
□ Alertes configurées pour Quality Gate failures ?
□ Documentation sur comment corriger les issues ?
```

## Responsabilités

**ARCHITECT :**
- Vérifier présence de SonarQube dans TOUT nouveau projet
- Définir les Quality Gates adaptés au projet
- Bloquer l'approbation si Quality Gate échoue
- Former l'équipe aux standards SonarQube

**FULLSTACK_DEV :**
- Corriger toutes les issues Blocker/Critical avant PR
- Maintenir 80%+ de coverage sur nouveau code
- Exécuter `npm run sonar` localement avant push
- Ne pas désactiver de règles sans justification

**DEVOPS :**
- Configurer SonarQube dans CI/CD
- Setup tokens et secrets
- Configurer les webhooks et notifications
- Monitorer le Technical Debt global

**REVIEWER :**
- Vérifier le SonarQube report dans la PR
- Bloquer le merge si Quality Gate échoue
- S'assurer que les issues sont corrigées (pas ignorées)
- Valider les justifications de règles désactivées

## Coûts

**SonarCloud** :
- Gratuit : Projets open-source
- 10€/mois : 100k lignes de code privé
- Scale selon la taille du code

**SonarQube Community (Self-hosted)** :
- Gratuit : Toutes les features essentielles
- Requiert serveur (Docker)

**Alternatives gratuites** :
- ESLint + extensions strictes
- CodeClimate (gratuit open-source)
- DeepSource (gratuit open-source)

## Pourquoi C'est Obligatoire

1. **Qualité** : Code review automatisé 24/7
2. **Sécurité** : Détection automatique de vulnérabilités (OWASP)
3. **Dette technique** : Suivi et prévention
4. **Standards** : Application automatique des best practices
5. **Onboarding** : Nouveaux devs apprennent les bonnes pratiques
6. **Confiance** : Garantie d'un code de qualité production

**⚠️ Un projet sans SonarQube (ou équivalent) est un projet qui accumule de la dette technique sans visibilité.**

## Exceptions

**Si SonarQube/SonarCloud est impossible** (ex: projet interne sensible) :

Configuration ESLint/TypeScript ultra-stricte OBLIGATOIRE :

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:security/recommended",
    "plugin:sonarjs/recommended"
  ],
  "plugins": ["security", "sonarjs"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "error",
    "complexity": ["error", 10],
    "max-lines-per-function": ["error", 50],
    "max-depth": ["error", 4],
    "no-console": "error",
    "sonarjs/cognitive-complexity": ["error", 15]
  }
}
```

**⚠️ Même avec ESLint strict, SonarQube reste recommandé pour la vision globale de la qualité.**
