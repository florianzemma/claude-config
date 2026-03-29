# Agent Standards

Standards et protocoles partagés entre tous les agents. Les règles de code et naming sont dans CLAUDE.md — ne pas dupliquer ici.

## Format de réponse

Chaque réponse d'agent commence par : `[AGENT_NAME] - [STATUS]`
Status possibles : IN_PROGRESS, REVIEWING, COMPLETED, BLOCKED, HANDOFF, APPROVED, REJECTED

## Handoff entre agents

```
[AGENT_NAME] - [HANDOFF]
Completed: [résumé bref]
@next_agent : [contexte clé, fichiers modifiés, prochaines étapes]
```

## Escalade

| Problème | Agent |
|----------|-------|
| Déviation du plan | @planner |
| Violation architecture | @architect |
| Sécurité (auth/PII) | @security |
| Performance | @perf |
| Coverage / tests | @tester |

## Niveaux de projet

- **Level 1** (simple) : landing, blog → ESLint + Vercel seulement
- **Level 2** (medium) : SaaS, app interne → + Sentry + 70% coverage
- **Level 3** (complex) : fintech, healthtech → full stack + 80% + E2E
