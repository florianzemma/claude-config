# Claude Code Instructions

## Ce fichier est lu à chaque session. Chaque règle doit empêcher une erreur réelle.

## Workflow

- **Plan first** : shift+tab (plan mode) pour toute tâche touchant 2+ fichiers. Écris le plan dans PLAN.md.
- **Décompose** : phases de 5-10 min max, chacune testable indépendamment.
- **Subagents pour la recherche** : "utilise un subagent pour investiguer X" — garde le contexte principal clean pour l'implémentation.
- **Session A / Session B** : implémente dans une session, review dans une session fraîche. Le reviewer n'a aucun biais.

## Avant de coder

- Si la tâche est ambiguë, pose la question — ne choisis pas une interprétation silencieusement.
- Si plusieurs lectures sont possibles, présente-les toutes. Attends la validation.
- Énonce tes hypothèses explicitement. Si tu en fais une grosse, signale-la.
- Si une approche plus simple existe, dis-le. Pousse en arrière si c'est justifié.
- Si tu bloques ou es confus, nomme le blocage — ne hallucine pas une solution.
- Définis le succès avant de coder : "fix the bug" → "écris un test qui échoue, puis fais-le passer". Pour les tâches multi-étapes : `[étape] → verify: [comment vérifier]`.

## Gestion du contexte

- /compact manuellement à ~50% du contexte, jamais après.
- Lors du compact : TOUJOURS préserver la liste des fichiers modifiés, le statut des tests, et le plan en cours.
- /clear entre deux tâches distinctes. Une conversation = une feature.
- Écris les plans et l'état dans PLAN.md ou SCRATCHPAD.md pour survivre aux compactions.

## Édits chirurgicaux

- Chaque ligne modifiée doit être traçable directement à la demande. Rien de plus.
- Pas d'"améliorations" sur le code adjacent — pas de style fix, pas de refactor hors scope.
- Respecte le style existant, même si tu ferais autrement.
- Si tu vois du dead code non lié, **mentionne-le** — ne le supprime pas.
- Supprime uniquement les imports/variables rendus orphelins par **tes** propres changements.

## Code

- TypeScript strict, zéro `any`.
- Fonctions ≤ 50 lignes, complexité ≤ 10.
- Early returns. Un fichier = une responsabilité.
- Pas de code mort. Pas de TODO sans issue.
- Pas de commentaires sauf : business logic complexe, JSDoc pour API publiques, workarounds temporaires.
- Si tu écris un commentaire, demande-toi : "je peux rendre le code plus clair à la place ?" Si oui → supprime le commentaire.
- Si tu as écrit 200 lignes là où 50 suffisaient, réécris. Demande-toi : un senior engineer dirait-il que c'est trop compliqué ? Si oui → simplifie.

## Naming

- Fichiers : PascalCase.tsx (composants), use-kebab-case.ts (hooks), kebab-case.ts (utils)
- Variables : SCREAMING_SNAKE (constantes), camelCase (fonctions), PascalCase (classes/types)

## Git

- Commits conventionnels : feat(scope): description, fix, docs, refactor, test, chore, perf
- JAMAIS d'attribution Claude/AI dans les commits (pas de Co-Authored-By, pas de "Generated with")
- Commits atomiques. Jamais de force push sur main.

## Design UI _(projets frontend uniquement — ignorer sinon)_

- Fonts interdites : Inter, Roboto, Arial, Space Grotesk (generic)
- Utiliser : Outfit, DM Sans, Plus Jakarta Sans, Fraunces, JetBrains Mono
- Couleurs : 70% dominant + 20% accent + 10% secondary. Pas de gradient violet sur blanc.
- Rejeter tout design qui ressemble à un template Tailwind UI générique.

## Agents disponibles

6 agents dans `.claude/agents/`. Chacun tourne dans un contexte frais isolé (200K).

| Agent | Quand |
|---|---|
| @planner | Entry point obligatoire pour toute tâche non-triviale |
| @architect | Décisions techniques, validation archi, veto stack |
| @fullstack-dev | Implémentation (TDD intégré) |
| @reviewer | Review avant merge — fresh context, sans biais |
| @debugger | Root cause analysis sur bug non-trivial |
| @orchestrator | Coordination multi-agents pour features larges |

**Règle** : @planner en premier. N'orchestre pas plusieurs agents sans plan validé.

**Besoins spécialisés** (sécu, docs, perf, déploiement) → slash command dédiée (`/security-review`, `/docs`, `/fix-ci`...) ou skill on-demand. Pas d'agent dédié.

## Skills

Chargées on-demand, pas à chaque session. Disponibles dans `.claude/skills/` :

| Skill | Usage |
|---|---|
| `brainstorming` | Design et spec avant d'implémenter |
| `code-review` | Revue approfondie niveau staff |
| `code-quality` | Dette technique, patterns, refactor |
| `commit-messages` | Conventions de messages git |
| `architectural-patterns` | Patterns archi courants |
| `linting-setup` | Config ESLint/Prettier/Biome |
| `logging-monitoring` | Observabilité, structured logging |
| `sonarqube-quality` | Analyse statique SonarQube |

## Communication

- Français pour les échanges, anglais pour le code.
- Concis. Si bloqué après 3 tentatives, dis-le.
