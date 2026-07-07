# Claude Code Instructions

Chaque règle ici doit empêcher une erreur réelle. Pruning test à chaque revue de config : si retirer une ligne ne provoquerait aucune erreur, la retirer.

## Workflow

- **Plan mode** (shift+tab) quand l'approche est incertaine ou que la tâche touche 3+ fichiers. Si le diff se décrit en une phrase, implémente directement. Écris le plan dans PLAN.md.
- **Décompose** : phases de 5-10 min max, chacune testable indépendamment. Format : `1. [étape] → verify: [check]`.
- **Subagents pour la recherche** : investigation ou lecture massive → subagent (Explore) ; le contexte principal reste propre pour l'implémentation.
- **Session A / Session B** : implémente dans une session, review dans une session fraîche (`@reviewer` ou `/review`). Le reviewer n'a aucun biais.
- **Toujours un moyen de vérifier** : chaque tâche se termine par un check exécutable (test, build, diff). Avant de déclarer une tâche non-triviale terminée : skill `verify` — preuve exécutée, pas juste "les tests passent". Transforme la demande en critère vérifiable avant de coder :
  - "fix the bug" → "écris un test qui reproduit le bug, puis fais-le passer"
  - "add validation" → "écris les tests pour les inputs invalides, puis fais-les passer"
  - "refactor X" → "les tests passent avant et après, comportement identique"

## Avant de coder

- Si la tâche est ambiguë, pose la question — ne choisis pas une interprétation silencieusement.
- Si plusieurs lectures sont possibles, présente-les toutes. Attends la validation.
- Énonce tes hypothèses explicitement. Si tu en fais une grosse, signale-la.
- Si une approche plus simple existe, dis-le. Pousse en arrière si c'est justifié.
- Si tu bloques ou es confus, nomme le blocage — ne hallucine pas une solution.

## Gestion du contexte

- /compact manuellement à ~50% du contexte, jamais après.
- Lors du compact : TOUJOURS préserver la liste des fichiers modifiés, le statut des tests, et le plan en cours.
- /clear entre deux tâches distinctes. Une conversation = une feature.
- Après 2 corrections ratées sur le même point : /rewind vers le checkpoint et reformule — corriger dans un contexte pollué marche rarement.
- Écris les plans et l'état dans PLAN.md ou SCRATCHPAD.md pour survivre aux compactions.

## Édits chirurgicaux

- Chaque ligne modifiée doit être traçable directement à la demande. Rien de plus.
- Pas d'"améliorations" sur le code adjacent — pas de style fix, pas de refactor hors scope.
- Respecte le style existant, même si tu ferais autrement.
- Si tu vois du dead code non lié, **mentionne-le** — ne le supprime pas.
- Supprime uniquement les imports/variables rendus orphelins par **tes** propres changements.

## Code

- TypeScript strict, zéro `any`.
- Fonctions ≤ 50 lignes, complexité ≤ 10. Early returns. Un fichier = une responsabilité.
- Pas de code mort. Pas de TODO sans issue.
- Pas de commentaires sauf : business logic complexe, JSDoc pour API publiques, workarounds temporaires. Avant d'écrire un commentaire : "je peux rendre le code plus clair à la place ?" Si oui → pas de commentaire.
- Pas de features non demandées. Pas d'abstractions pour du code à usage unique.
- Pas de gestion d'erreurs pour des scénarios impossibles. Ne valide qu'aux frontières du système (input utilisateur, APIs externes).
- Si tu as écrit 200 lignes là où 50 suffisaient, réécris.

## Architecture _(enforced — appliqué par défaut)_

- SOLID et Clean Code s'appliquent partout — tu connais les définitions, pas besoin de les rappeler ici.
- DDD pour les projets Level 2+ : Entity vs Value Object, Aggregate Root = invariants + frontière transactionnelle, Repository, bounded contexts.
- Layering : Presentation → Application → Domain → Infrastructure. Dépendance vers l'intérieur uniquement. Le Domain n'a aucune dépendance.
- Patterns seulement quand la complexité le justifie. Start simple, refactor vers un pattern quand le besoin est prouvé.
- Anti-patterns à REJETER : god object, modèle anémique, couplage fort, dépendances circulaires, optimisation prématurée (mesurer d'abord), golden hammer.

## Naming

- Fichiers : PascalCase.tsx (composants), use-kebab-case.ts (hooks), kebab-case.ts (utils)
- Variables : SCREAMING_SNAKE (constantes), camelCase (fonctions), PascalCase (classes/types)

## Git

- Commits conventionnels : feat(scope): description, fix, docs, refactor, test, chore, perf
- JAMAIS d'attribution Claude/AI dans les commits (pas de Co-Authored-By, pas de "Generated with")
- Commits atomiques. Jamais de force push sur main (bloqué aussi par hook).
- **Config globale versionnée** : `~/.claude/` est un symlink vers le repo `~/claude-config` (`claude/`). Dès que je modifie la config Claude globale (CLAUDE.md, settings.json, agents, commands, skills), commit + push dans `~/claude-config` pour que la config reste toujours à jour.

## Sécurité _(enforced — non négociable)_

- **NE JAMAIS lire de fichier de secrets** : `.env`, `.env.*`, `*.pem`, `*.key`, `id_rsa`, `*.p12`, `credentials`, `secrets.*`, `.npmrc`/`.netrc`. Ni `cat`, ni `grep`, ni outil de lecture — risque de fuite de credentials dans le contexte/les logs.
- Si la tâche exige de connaître **quelles** variables existent, lire `.env.example` (jamais `.env`). Si une valeur de secret est nécessaire, demander à l'utilisateur de l'injecter.
- Jamais de secret hardcodé, jamais de secret écrit dans un commit, un log, ou une sortie. Bloqué aussi côté harness (`settings.json` : deny + hooks).

## Design UI _(projets frontend uniquement — ignorer sinon)_

- Fonts interdites : Inter, Roboto, Arial, Space Grotesk (generic)
- Utiliser : Outfit, DM Sans, Plus Jakarta Sans, Fraunces, JetBrains Mono
- Couleurs : 70% dominant + 20% accent + 10% secondary. Pas de gradient violet sur blanc.
- Rejeter tout design qui ressemble à un template Tailwind UI générique.

## Agents

4 agents custom dans `.claude/agents/`, chacun en contexte frais isolé. Le **main loop orchestre** : plan validé (plan mode), puis dispatch — pas d'agent planner/orchestrator intermédiaire.

| Agent | Quand | Modèle |
|---|---|---|
| @architect | Décision technique, validation archi, veto stack, classification Level 1/2/3 | opus |
| @fullstack-dev | Implémentation TDD isolée (worktree) — features parallélisables | sonnet |
| @reviewer | Review avant merge — fresh context, sans biais, read-only | opus |
| @debugger | Root cause analysis sur bug non-trivial | opus |

Pour la recherche/lecture massive : built-in `Explore`. Pour la planification : plan mode natif.

## Skills & commands

Chargées on-demand. Skills : `verify` (preuve avant "terminé"), `retro` (corrections → règles, en fin de tâche), `brainstorming` (design avant d'implémenter), `code-review`, `code-quality`, `db-migration` (schéma DB sans casse), `commit-messages`, `pr-desc`, `release-notes`, `refinement` (Jira).
Commands : `/commit`, `/create-pr`, `/debug`, `/fix-ci`, `/fix-issue`, `/plan`, `/prime`, `/review`, `/runbook`, `/security-review`, `/tdd`, `/worklog-jira`.

Règle de répartition : une **skill** enseigne le comment, un **hook** applique la règle (déterministe), un **subagent** isole le travail. Si je viole une règle de ce fichier de façon répétée → skill `retro` pour la convertir en règle ou en hook.

- **Review = skill obligatoire** : toute demande de review (MR, PR, diff, "fais les commentaires", `/review`) → invoquer le skill `code-review` **avant** de reviewer. Jamais de review à la main sans le skill.

## Communication

- Français pour les échanges, anglais pour le code.
- Concis. Si bloqué après 3 tentatives, dis-le.
