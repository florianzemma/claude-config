# Claude Code Instructions

## Ce fichier est lu à chaque session. Budget ~100 instructions. Chaque ligne doit empêcher une erreur réelle.

## Workflow

- **Plan first** : shift+tab (plan mode) pour toute tâche touchant 2+ fichiers. Écris le plan dans PLAN.md.
- **Décompose** : phases de 5-10 min max, chacune testable indépendamment.
- **Subagents pour la recherche** : "utilise un subagent pour investiguer X" — garde le contexte principal clean pour l'implémentation.
- **Session A / Session B** : implémente dans une session, review dans une session fraîche. Le reviewer n'a aucun biais.

## Gestion du contexte

- /compact manuellement à ~50% du contexte, jamais après.
- Lors du compact : TOUJOURS préserver la liste des fichiers modifiés, le statut des tests, et le plan en cours.
- /clear entre deux tâches distinctes. Une conversation = une feature.
- Écris les plans et l'état dans PLAN.md ou SCRATCHPAD.md pour survivre aux compactions.

## Code

- TypeScript strict, zéro `any`.
- Fonctions ≤ 50 lignes, complexité ≤ 10.
- Early returns. Un fichier = une responsabilité.
- Pas de code mort. Pas de TODO sans issue.
- Pas de commentaires sauf : business logic complexe, JSDoc pour API publiques, workarounds temporaires.
- Si tu écris un commentaire, demande-toi : "je peux rendre le code plus clair à la place ?" Si oui → supprime le commentaire.

## Naming

- Fichiers : PascalCase.tsx (composants), use-kebab-case.ts (hooks), kebab-case.ts (utils)
- Variables : SCREAMING_SNAKE (constantes), camelCase (fonctions), PascalCase (classes/types)

## Git

- Commits conventionnels : feat(scope): description, fix, docs, refactor, test, chore, perf
- JAMAIS d'attribution Claude/AI dans les commits (pas de Co-Authored-By, pas de "Generated with")
- Commits atomiques. Jamais de force push sur main.

## Design UI

- Fonts interdites : Inter, Roboto, Arial, Space Grotesk (generic)
- Utiliser : Outfit, DM Sans, Plus Jakarta Sans, Fraunces, JetBrains Mono
- Couleurs : 70% dominant + 20% accent + 10% secondary. Pas de gradient violet sur blanc.
- Rejeter tout design qui ressemble à un template Tailwind UI générique.

## Agents disponibles

Subagents spécialisés dans `.claude/agents/`. Principaux :

| Agent | Quand |
|---|---|
| PLANNER | Premier pour toute tâche non-triviale |
| ARCHITECT | Décisions techniques, validation archi |
| FULLSTACK_DEV | Implémentation |
| REVIEWER | Review avant merge |
| DEBUGGER | Investigation de bugs |

Agents secondaires : @orchestrator, @security, @tester, @designer, @devops, @docs, @context, @error, @perf

**Règle** : demande d'abord "Pipeline agents ou direct ?" Ne jamais assumer.

## Skills

Skills dans `.claude/skills/` — chargées on-demand, pas à chaque session. Voir le dossier pour la liste.

## Communication

- Français pour les échanges, anglais pour le code.
- Concis. Si bloqué après 3 tentatives, dis-le.
