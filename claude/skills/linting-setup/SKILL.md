---
name: linting-setup
description: Configure linting and formatting for projects. Use when setting up new projects, configuring ESLint/Prettier, or adding pre-commit hooks. Covers JS/TS, Python, Go, and Rust.
---

# Linting & Formatting Setup

## Why?
Automated formatting eliminates style debates and catches errors early. Pre-commit hooks guarantee every commit is formatted.

## JavaScript/TypeScript

### Quick Setup

```bash
npm install -D eslint@^8.56.0 prettier@^3.1.0 @typescript-eslint/eslint-plugin@^6.17.0 @typescript-eslint/parser@^6.17.0 eslint-config-prettier@^9.1.0 eslint-plugin-prettier@^5.1.0 lint-staged@^15.2.0 husky@^8.0.3

npx husky install
npm pkg set scripts.prepare="husky install"
npx husky add .husky/pre-commit "npx lint-staged"
```

### .eslintrc.json

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
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": ["warn", {
      "allowExpressions": true,
      "allowTypedFunctionExpressions": true
    }],
    "@typescript-eslint/no-unused-vars": ["error", {
      "argsIgnorePattern": "^_",
      "varsIgnorePattern": "^_"
    }],
    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/await-thenable": "error",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "no-var": "error",
    "prefer-const": "error",
    "eqeqeq": ["error", "always"]
  }
}
```

### .prettierrc

```json
{
  "semi": false,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

### package.json scripts

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx --max-warnings 0",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,js,jsx,json,md,css,scss}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,js,jsx,json,md,css,scss}\"",
    "prepare": "husky install"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md,css,scss,yml,yaml}": ["prettier --write"]
  }
}
```

### React/Next.js Extensions

```json
{
  "extends": [
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "plugins": ["react", "react-hooks"],
  "settings": { "react": { "version": "detect" } },
  "rules": {
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn"
  }
}
```

## Python

### Setup

```bash
pip install black ruff isort pre-commit
```

### pyproject.toml

```toml
[tool.black]
line-length = 100
target-version = ['py311']

[tool.ruff]
line-length = 100
target-version = "py311"
select = ["E", "W", "F", "I", "C", "B", "UP"]

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
```

## Go

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

linters-settings:
  gofmt:
    simplify: true
  goimports:
    local-prefixes: github.com/yourorg/yourrepo
```

## Rust

### rustfmt.toml

```toml
max_width = 100
hard_tabs = false
tab_spaces = 4
newline_style = "Unix"
edition = "2021"
```

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
  lint:
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
```

## VSCode Settings

### .vscode/settings.json

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "prettier.requireConfig": true
}
```

## Troubleshooting

**ESLint + Prettier conflicts:**
```bash
npm install -D eslint-config-prettier
# "prettier" must be LAST in extends array
```

**Husky not working:**
```bash
rm -rf .husky
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
chmod +x .husky/pre-commit
```
