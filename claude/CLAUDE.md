# Claude Code Instructions

Budget instructions : ce fichier est lu à chaque session. Rester court — max ~80 lignes actionnables. Les règles détaillées sont dans les agents/ et skills/.

## Anti-erreurs (non-négociable)

- Zéro `any` TypeScript — utilise `unknown` ou un type précis
- Zéro commentaire sauf JSDoc sur API publique ou logique métier complexe
- Zéro attribution Claude dans les commits
- Fonctions ≤ 50 lignes, nesting ≤ 4, params ≤ 4
- Conventional commits : `feat|fix|refactor|test|chore|docs|perf(scope): description`
- Linting obligatoire : ESLint + Prettier + husky pre-commit

## Quand utiliser les agents

| Tâche | Approche |
|-------|----------|
| Fichier unique, < 50 lignes | Directement |
| Feature multi-fichiers | `@planner` → valider → `@orchestrator` |
| Review avant merge | `@reviewer` |
| Auth / paiement / PII | `@security` |
| UI/composant complet | `@designer` |
| Tests exhaustifs | `@tester` |
| Debug root cause | `@debugger` |

Agents disponibles : planner, orchestrator, architect, fullstack-dev, reviewer, security-engineer, tester, designer, debugger, devops, documentalist, error-coordinator, performance-engineer, context-manager

Chaque réponse d'agent commence par : `[AGENT_NAME] - [STATUS]`

## Naming

```
Fichiers : PascalCase.tsx (composants), kebab-case.ts (utils/hooks)
Variables : SCREAMING_SNAKE (constantes), camelCase (fonctions), PascalCase (classes/types)
```

## UI

Éviter : Inter, gradients purple, glassmorphism, templates Tailwind génériques
Préférer : DM Sans, Outfit, JetBrains Mono — 70% dominant + 20% accent + 10% secondaire

## Détails

Configs complètes → `.claude/agents/` et `.claude/skills/`
