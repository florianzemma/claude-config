---
name: code-quality
description: Apply code quality standards when writing or reviewing code. Use when implementing features, refactoring, or reviewing PRs. Enforces complexity limits, duplication rules, and TypeScript strictness.
model: claude-sonnet-4-6
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

## Enforcing These Limits

These thresholds are tool-agnostic — enforce them with whatever linter the project already uses (ESLint `complexity`/`max-lines-per-function`/`max-depth`, Biome, Ruff, Clippy, etc.). The numbers matter, not the vendor.

Minimum lint rules to map:

- complexity ≤ 10
- max function length ≤ 50 lines
- max nesting depth ≤ 4
- no implicit `any` / explicit types on public APIs
- cognitive complexity ≤ 15
- no duplicated string literals / identical functions (extract to a shared utility)

Wire the linter + formatter into a pre-commit hook so every commit is checked automatically — no manual formatting debates.

## Quality by Project Level

| Level | Coverage | Verification |
|-------|----------|--------------|
| 1 (Simple) | Lint only | Deep manual review |
| 2 (Medium) | ≥70% | Lint + automated static analysis + review |
| 3 (Complex) | ≥80% | Lint + static analysis + E2E + review |

Match tooling to project complexity. Don't over-engineer simple projects. The choice of static-analysis vendor is a per-project decision, not a config default.
