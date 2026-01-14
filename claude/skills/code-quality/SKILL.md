---
name: code-quality
description: Apply code quality standards when writing or reviewing code. Use when implementing features, refactoring, or reviewing PRs. Enforces complexity limits, duplication rules, and TypeScript strictness.
---

# Code Quality Standards

## Why These Rules?

These aren't arbitrary—each prevents specific production issues we've encountered.

## Complexity Limits

- **Cyclomatic complexity ≤ 10** — More paths = more bugs, harder testing
- **Cognitive complexity ≤ 15** — If it's hard to read, it's hard to maintain
- **Nesting depth ≤ 4** — Deep nesting hides bugs and makes debugging painful
- **Functions ≤ 50 lines** — Long functions do too many things
- **Files ≤ 500 lines** — Big files = unclear responsibilities
- **Parameters ≤ 4** — More params usually means the function needs refactoring

## TypeScript Strictness

- **No `any`** — Implicit any caused production type errors that weren't caught at compile time
- **Explicit types** — Return types and parameter types must be explicit
- **Strict mode** — tsconfig.json must have `"strict": true`

## Duplication

- **≤ 3% duplication** — Copy-paste bugs are the worst—fix in one place, miss another
- **No identical functions** — Extract to shared utility

## Code Patterns

- **Early returns** — Reduces nesting, clearer flow
- **Pure functions when possible** — Easier to test, no hidden side effects
- **Immutability by default** — Prevents mutation bugs in complex state

## ESLint Configuration

Required plugins for all projects:

```json
{
  "plugins": ["@typescript-eslint", "sonarjs", "security"],
  "rules": {
    "complexity": ["error", 10],
    "max-lines-per-function": ["error", { "max": 50 }],
    "max-depth": ["error", 4],
    "@typescript-eslint/no-explicit-any": "error",
    "sonarjs/cognitive-complexity": ["error", 15],
    "sonarjs/no-duplicate-string": ["error", 3],
    "sonarjs/no-identical-functions": "error"
  }
}
```

## Pre-commit Hooks (Non-Negotiable)

```bash
npm install --save-dev eslint prettier lint-staged husky
npx husky install
```

Every commit must auto-run linter and formatter. No manual formatting debates.

## Quality by Project Level

| Level | Coverage | Tools |
|-------|----------|-------|
| 1 (Simple) | ESLint only | Manual review |
| 2 (Medium) | ≥70% | SonarCloud |
| 3 (Complex) | ≥80% | SonarQube + E2E |

Match tooling to project complexity. Don't over-engineer simple projects.
