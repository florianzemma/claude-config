# Claude Code Configuration

Configuration personnelle de Claude Code : agents spécialisés, slash commands, skills, hooks de sécurité et standards enforced. Alignée sur les best practices officielles 2026 : CLAUDE.md court et prunable, main loop qui orchestre (pas d'agent zoo), hooks déterministes pour tout ce qui doit arriver à 100%, alias de modèles (jamais de snapshots datés).

## Installation

```bash
git clone <repo>
cd claude-config
./install.sh
```

`install.sh` symlinke `claude/` vers `~/.claude/` — le repo devient la source de vérité, un `git pull` met à jour la config globale instantanément. **Exception : `settings.json` n'est jamais symlinké ni écrasé** (le fichier global peut contenir des secrets locaux — tokens, env) ; le script affiche un diff pour merger à la main.

## Structure

```
claude-config/
├── claude/
│   ├── CLAUDE.md              # Instructions globales (~100 lignes, pruning test à chaque revue)
│   ├── AGENT_STANDARDS.md     # Standards partagés entre agents
│   ├── agents/                # Subagents (contexte frais isolé)
│   │   ├── architect.md       #   validation archi, veto, read-only
│   │   ├── fullstack-dev.md   #   implémentation TDD, isolé en worktree
│   │   ├── reviewer.md        #   review avant merge, read-only
│   │   └── debugger.md        #   root cause analysis
│   ├── commands/              # Slash commands
│   ├── skills/                # Skills chargées on-demand
│   ├── templates/             # ADR, PLAN, SCRATCHPAD
│   ├── statusline-command.sh
│   └── settings.json          # Permissions + hooks (versionné, sans secret)
├── check.sh                   # Lint de la config (hooks, modèles, références) — tourne en CI
├── install.sh
└── README.md
```

## Qualité de la config

`./check.sh` (exécuté en GitHub Action sur chaque push/PR) valide : JSON des settings, syntaxe bash de chaque hook, alias de modèles uniquement (jamais de snapshots datés), champs frontmatter valides, absence de marqueurs de conflit git, et que chaque agent/command/skill référencé dans CLAUDE.md existe réellement. Chaque catégorie de bug déjà rencontrée dans cette config a son check.

## Philosophie d'orchestration

**Le main loop orchestre.** Pas d'agent planner ni orchestrator : la planification passe par le plan mode natif (shift+tab), et c'est la session principale qui dispatche les subagents. Un subagent custom n'existe que pour l'une de ces trois raisons : isoler du contexte verbeux, restreindre les outils, vraie spécialisation.

```
Plan mode ──→ PLAN.md validé
    │
    ▼  (main loop dispatche)
@architect (décision/veto) → @fullstack-dev (implémentation, worktree) → @reviewer (fresh context) → merge
                                    │
                                @debugger (si bug bloquant)
```

Règle de répartition : une **skill** enseigne le comment, un **hook** applique la règle, un **subagent** isole le travail.

## Agents

| Agent | Modèle | Rôle | Quand |
|---|---|---|---|
| `@architect` | opus | Décisions techniques, veto stack, classification Level 1/2/3 — read-only | Changement de stack, nouvelle lib, validation archi |
| `@fullstack-dev` | sonnet | Implémentation TDD, isolé en worktree | Tâche bien scopée avec critères de succès |
| `@reviewer` | opus | Review en contexte frais, sans biais — read-only | Après chaque bloc, avant merge |
| `@debugger` | opus | Root cause analysis, fix minimal, lit les runbooks | Bug non-trivial, test en échec |

Pour la recherche/lecture massive : subagent built-in `Explore`.

## Slash Commands

| Commande | Rôle |
|---|---|
| `/commit` | Commit conventionnel depuis git diff (haiku) |
| `/create-pr` | Branche + commit + PR via gh CLI |
| `/plan` | Plan structuré dans PLAN.md avant d'implémenter |
| `/review` | Review staff-engineer — délègue à la skill code-review |
| `/security-review` | Audit OWASP Top 10 sur les changements (opus) |
| `/tdd` | Cycle red → green → refactor strict |
| `/debug` | Débogage systématique en 5 étapes |
| `/fix-ci` | Diagnostique le dernier run CI en échec, fix ciblé |
| `/fix-issue` | Résout une issue GitHub de bout en bout |
| `/runbook <module>` | Runbook de troubleshooting condensé (opus) |
| `/prime` | Re-prime le contexte après /clear |
| `/worklog-jira` | Worklogs Jira du jour depuis les commits (invocation manuelle uniquement) |

Les commands à effets de bord externes (`/commit`, `/create-pr`, `/fix-issue`, `/worklog-jira`, skill `refinement`) sont marquées `disable-model-invocation: true` : seul l'utilisateur peut les déclencher, jamais le modèle de sa propre initiative.

## Skills

| Skill | Modèle | Usage |
|---|---|---|
| `verify` | — | **Auto-invoquée** avant de déclarer une tâche terminée : tests + typecheck + exercer le comportement réel, verdict avec preuves |
| `retro` | — | **Auto-invoquée** en fin de tâche avec corrections : transforme chaque friction en règle CLAUDE.md ou hook (compounding engineering) |
| `brainstorming` | opus | Design et spec avant d'implémenter |
| `code-review` | opus | Revue staff-engineer + contexte Jira + commentaires inline GitLab |
| `code-quality` | sonnet | Dette technique, patterns, seuils de complexité |
| `db-migration` | — | **Auto-invoquée** dès qu'un schema.prisma ou une migration est touché : expand/migrate/contract, zéro perte de données |
| `commit-messages` | haiku | Conventions de messages git |
| `pr-desc` | — | Description de PR depuis le diff de branche |
| `release-notes` | haiku | Changelog depuis les commits conventionnels entre deux tags |
| `refinement` | — | Refinement technique Jira (board PI Planning) — invocation manuelle uniquement |

## Hooks

Définis dans `settings.json`, exécutés par le harness — déterministes, contrairement aux instructions CLAUDE.md qui sont advisory.

| Hook | Effet |
|---|---|
| `PreToolUse(Bash)` | Bloque `rm -rf`, `DROP TABLE`, `curl \| bash`, `git reset --hard`, force-push sans `--force-with-lease`, push direct vers main/master, lecture de secrets via shell |
| `PreToolUse(Read)` | Bloque la lecture de `.env*`, `*.pem`, `*.key`, `id_rsa`, `secrets.*`, `.npmrc`, `.netrc` (`.env.example` toléré) |
| `PreToolUse(Write\|Edit)` | Bloque l'écriture sur `.env*`, lockfiles, `.git/`, `node_modules/` |
| `PostToolUse(Write\|Edit)` | Prettier auto si présent dans le projet |
| `PostToolBatch` | `tsc --noEmit` bloquant si projet TypeScript |
| `PreCompact` | Backup git status + PLAN.md dans `~/.claude/backups/` |
| `SessionStart` | Injecte git status + PLAN.md en cours |
| `Notification` | notify-send / notification macOS |

## Modèles

Aucun modèle pinné dans `settings.json` — le modèle principal se choisit via `/model` et n'est pas versionné. Agents, commands et skills utilisent des **alias** (`opus`, `sonnet`, `haiku`) qui suivent automatiquement les dernières versions.

## Standards enforced

Définis dans `CLAUDE.md`, appliqués à chaque session : TypeScript strict zéro `any` · fonctions ≤ 50 lignes, complexité ≤ 10 · SOLID + DDD (Level 2+) · layering avec dépendances vers l'intérieur · commits conventionnels sans attribution AI · jamais de lecture/écriture de secrets (doublé par hooks + permissions deny).

## Licence

MIT
