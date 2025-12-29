# Standards de Linting et Formatage

## JavaScript / TypeScript

### Installation

```bash
npm install -D eslint@^8.56.0 prettier@^3.1.0
npm install -D @typescript-eslint/eslint-plugin@^6.17.0 @typescript-eslint/parser@^6.17.0
npm install -D eslint-config-prettier@^9.1.0 eslint-plugin-prettier@^5.1.0
npm install -D lint-staged@^15.2.0 husky@^8.0.3

# Setup husky
npx husky install
npm pkg set scripts.prepare="husky install"
npx husky add .husky/pre-commit "npx lint-staged"
```

### ESLint Configuration (.eslintrc.json)

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.json",
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": ["@typescript-eslint", "prettier"],
  "rules": {
    "prettier/prettier": "error",

    // TypeScript Strict
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": ["warn", {
      "allowExpressions": true,
      "allowTypedFunctionExpressions": true
    }],
    "@typescript-eslint/no-unused-vars": ["error", {
      "argsIgnorePattern": "^_",
      "varsIgnorePattern": "^_"
    }],
    "@typescript-eslint/strict-boolean-expressions": "warn",
    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/await-thenable": "error",
    "@typescript-eslint/no-misused-promises": "error",

    // Code Quality
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "no-debugger": "error",
    "no-var": "error",
    "prefer-const": "error",
    "prefer-arrow-callback": "error",
    "no-throw-literal": "error",
    "eqeqeq": ["error", "always"],
    "curly": ["error", "all"],
    "no-eval": "error",
    "no-implied-eval": "error",

    // Best Practices
    "prefer-template": "warn",
    "prefer-destructuring": ["warn", {
      "array": true,
      "object": true
    }],
    "no-duplicate-imports": "error",
    "no-useless-return": "error",
    "no-else-return": "warn"
  }
}
```

### Prettier Configuration (.prettierrc)

```json
{
  "semi": false,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always",
  "endOfLine": "lf",
  "bracketSpacing": true,
  "jsxBracketSameLine": false
}
```

### .eslintignore

```
node_modules/
dist/
build/
.next/
out/
coverage/
*.min.js
*.bundle.js
.env*
*.config.js
!.eslintrc.js
```

### .prettierignore

```
node_modules/
dist/
build/
.next/
out/
coverage/
package-lock.json
pnpm-lock.yaml
yarn.lock
*.min.js
*.bundle.js
```

### package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx --max-warnings 0",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,js,jsx,json,md,css,scss}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,js,jsx,json,md,css,scss}\"",
    "prepare": "husky install",
    "pre-commit": "lint-staged"
  }
}
```

### lint-staged Configuration (package.json)

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,css,scss,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

### Husky Pre-commit Hook (.husky/pre-commit)

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
```

### React/Next.js Specific (.eslintrc.json extensions)

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "prettier"
  ],
  "plugins": ["@typescript-eslint", "react", "react-hooks", "prettier"],
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "rules": {
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "react/self-closing-comp": "warn",
    "react/jsx-boolean-value": ["warn", "never"]
  }
}
```

---

## Python

### Installation

```bash
pip install black ruff isort pre-commit
```

### pyproject.toml

```toml
[tool.black]
line-length = 100
target-version = ['py311']
include = '\.pyi?$'

[tool.ruff]
line-length = 100
target-version = "py311"
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "C",   # flake8-comprehensions
    "B",   # flake8-bugbear
    "UP",  # pyupgrade
]
ignore = []

[tool.ruff.per-file-ignores]
"__init__.py" = ["F401"]

[tool.isort]
profile = "black"
line_length = 100
```

### .pre-commit-config.yaml

```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.9
    hooks:
      - id: ruff
        args: [--fix]

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

### Setup

```bash
pre-commit install
```

### Scripts (Makefile)

```makefile
.PHONY: lint format check

lint:
	ruff check .

format:
	black .
	isort .

check:
	ruff check .
	black --check .
	isort --check .
```

---

## Go

### Configuration

Go utilise les outils natifs :

```bash
# Format
go fmt ./...

# Vet (analyse statique)
go vet ./...

# golangci-lint (comprehensive linter)
golangci-lint run
```

### .golangci.yml

```yaml
linters:
  enable:
    - gofmt
    - goimports
    - govet
    - errcheck
    - staticcheck
    - unused
    - gosimple
    - structcheck
    - varcheck
    - ineffassign
    - deadcode

linters-settings:
  gofmt:
    simplify: true
  goimports:
    local-prefixes: github.com/yourorg/yourrepo

issues:
  exclude-use-default: false
```

### Pre-commit Hook

```bash
#!/bin/sh
gofmt -w .
go vet ./...
golangci-lint run
```

---

## Rust

### Configuration

Rust utilise `rustfmt` et `clippy` :

```bash
# Format
cargo fmt

# Lint
cargo clippy -- -D warnings
```

### rustfmt.toml

```toml
max_width = 100
hard_tabs = false
tab_spaces = 4
newline_style = "Unix"
use_small_heuristics = "Default"
reorder_imports = true
reorder_modules = true
remove_nested_parens = true
edition = "2021"
```

### clippy.toml

```toml
cognitive-complexity-threshold = 30
```

### Pre-commit Hook

```bash
#!/bin/sh
cargo fmt -- --check
cargo clippy -- -D warnings
```

---

## CI/CD Integration

### GitHub Actions (.github/workflows/lint.yml)

```yaml
name: Lint & Format Check

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint-js:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check

  lint-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install black ruff isort
      - run: black --check .
      - run: ruff check .
      - run: isort --check .
```

---

## VSCode Integration

### .vscode/settings.json

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "prettier.requireConfig": true,
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true
  }
}
```

### Extensions recommandées (.vscode/extensions.json)

```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-python.black-formatter",
    "charliermarsh.ruff",
    "rust-lang.rust-analyzer"
  ]
}
```

---

## Troubleshooting

### Conflits ESLint + Prettier

```bash
# Installer eslint-config-prettier pour désactiver les règles conflictuelles
npm install -D eslint-config-prettier

# Dans .eslintrc.json, "prettier" doit être en DERNIER dans extends
```

### Husky ne fonctionne pas

```bash
# Réinstaller husky
rm -rf .husky
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
chmod +x .husky/pre-commit
```

### Performance lente

```bash
# Utiliser cache ESLint
eslint --cache .

# Exclure node_modules explicitement
```

---

## Règles Personnalisées

Pour ajouter des règles spécifiques au projet :

1. Documenter la raison dans un commentaire
2. Obtenir validation de ARCHITECT
3. Ajouter dans .eslintrc.json avec justification
4. Documenter dans PROJECT_SPECS.md

**Exemple :**

```json
{
  "rules": {
    // Project requires console.log for debugging in development
    "no-console": ["warn", { "allow": ["warn", "error", "info"] }]
  }
}
```
