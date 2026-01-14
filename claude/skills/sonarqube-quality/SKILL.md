---
name: sonarqube-quality
description: Configure SonarQube/SonarCloud for code quality analysis. Use when setting up quality gates, CI/CD integration, or fixing code smells. For Level 2+ projects only.
---

# SonarQube Quality Setup

## Why?
Automated code review 24/7. Catches bugs, security vulnerabilities, and code smells before production. Tracks technical debt.

## Project Level Requirements

- **Level 1**: ESLint + manual review - SonarQube NOT required
- **Level 2**: SonarCloud (free for open-source) - REQUIRED
- **Level 3**: SonarQube self-hosted - REQUIRED

## Quick Setup (SonarCloud)

```bash
# 1. Create account on sonarcloud.io
# 2. Connect your repo
# 3. Install scanner
npm install --save-dev sonarqube-scanner
```

## Project Configuration

### sonar-project.properties

```properties
sonar.projectKey=my-project
sonar.projectName=My Project
sonar.projectVersion=1.0.0
sonar.sources=src
sonar.tests=src
sonar.test.inclusions=**/*.test.ts,**/*.test.tsx,**/*.spec.ts
sonar.exclusions=**/node_modules/**,**/dist/**,**/coverage/**
sonar.typescript.lcov.reportPaths=coverage/lcov.info
sonar.sourceEncoding=UTF-8
```

### package.json

```json
{
  "scripts": {
    "test:coverage": "jest --coverage",
    "sonar": "sonar-scanner",
    "sonar:check": "npm run test:coverage && npm run sonar"
  },
  "devDependencies": {
    "sonarqube-scanner": "^3.3.0"
  }
}
```

## Quality Gates (Non-Negotiable)

```yaml
Quality Gate Conditions:
  - new_bugs: 0              # No new bugs accepted
  - new_vulnerabilities: 0   # No new security issues
  - new_coverage: >= 80%     # Minimum coverage
  - new_duplicated_lines: <= 3%
  - new_maintainability_rating: A
  - new_security_rating: A
  - new_reliability_rating: A
```

## CI/CD Integration

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
          fetch-depth: 0
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run test:coverage
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
```

## Critical Rules

### Security (Always Active)

- SQL Injection prevention
- XSS prevention
- Hardcoded credentials detection
- Weak cryptography detection
- Path traversal prevention
- Command injection prevention

### Code Smells

- Cognitive Complexity > 15
- Function length > 50 lines
- File length > 500 lines
- Too many parameters (> 4)
- Nested depth > 4
- Duplicated code blocks

## Issue Resolution

### Blocker - Fix before merge

```typescript
// Bad: Hardcoded password
const password = "admin123";

// Good
const password = process.env.DB_PASSWORD;
```

### Critical - Fix quickly

```typescript
// Bad: SQL Injection
const query = `SELECT * FROM users WHERE id = ${userId}`;

// Good
const query = `SELECT * FROM users WHERE id = $1`;
const result = await db.query(query, [userId]);
```

### Major - Fix before release

```typescript
// Bad: Cognitive complexity 25
function processOrder(order, user, payment, shipping) {
  if (order.status === 'pending') {
    if (user.isVerified) {
      if (payment.isValid) {
        // ... 50 more lines
      }
    }
  }
}

// Good: Split into smaller functions
function processOrder(order, user, payment, shipping) {
  validateOrderStatus(order);
  validateUser(user);
  validatePayment(payment);
  return executeOrder(order, shipping);
}
```

## Metrics to Track

```yaml
New Code:
  - Coverage: >= 80%
  - Duplicated Lines: <= 3%
  - Code Smells: 0-5

Overall:
  - Coverage: >= 70%
  - Duplicated Lines: <= 5%
  - Technical Debt Ratio: <= 5%

Security:
  - Vulnerabilities: 0
  - Security Hotspots: 0 (reviewed)
  - Security Rating: A
```

## ESLint Alternative (Level 1 Projects)

If SonarQube not possible, use strict ESLint:

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:security/recommended",
    "plugin:sonarjs/recommended"
  ],
  "plugins": ["security", "sonarjs"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "complexity": ["error", 10],
    "max-lines-per-function": ["error", 50],
    "max-depth": ["error", 4],
    "sonarjs/cognitive-complexity": ["error", 15]
  }
}
```

## Checklist

```
[] SonarCloud/SonarQube configured?
[] Token in CI/CD secrets?
[] sonar-project.properties created?
[] Quality Gates configured (80% coverage, 0 bugs)?
[] CI/CD integration active?
[] Coverage reports generated?
[] PR decoration enabled?
[] Security hotspots configured?
```
