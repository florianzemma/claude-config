# Claude Code Configuration

Configuration personnelle de Claude Code avec agents spécialisés, slash commands, skills, hooks de sécurité et standards architecturaux enforced.

Tous les fichiers dans `claude/` sont liés symboliquement vers `~/.claude/` — modifier ce repo modifie la config globale instantanément.

## Structure

```
claude-config/
├── claude/
│   ├── CLAUDE.md              # Instructions principales (lues à chaque session)
│   ├── AGENT_STANDARDS.md     # Standards partagés entre agents
│   ├── agents/                # Agents spécialisés (contexte isolé 200K)
│   │   ├── planner.md
│   │   ├── orchestrator.md
│   │   ├── architect.md
│   │   ├── fullstack-dev.md
│   │   ├── reviewer.md
│   │   └── debugger.md
│   ├── commands/              # Slash commands
│   │   ├── commit.md
│   │   ├── create-pr.md
│   │   ├── debug.md
│   │   ├── prime.md
│   │   ├── review.md
│   │   ├── runbook.md
│   │   ├── security-review.md
│   │   └── tdd.md
│   ├── skills/                # Skills chargées on-demand
│   │   ├── brainstorming/
│   │   ├── code-quality/
│   │   ├── code-review/
│   │   └── commit-messages/
│   ├── templates/             # Templates réutilisables
│   │   ├── ADR_TEMPLATE.md
│   │   ├── PLAN_TEMPLATE.md
│   │   └── SCRATCHPAD.md
│   ├── settings.json          # Modèle, permissions, hooks
│   └── settings.local.json
└── README.md
```

## Agents

6 agents, chacun dans un contexte frais isolé (200K tokens). Chaque agent a un modèle et un `max_turns` configuré dans son frontmatter.

| Agent | Modèle | max_turns | Rôle | Quand |
|---|---|---|---|---|
| `@planner` | opusplan | 25 | Analyse, pose des questions, produit un plan validé | Entry point obligatoire pour toute tâche non-triviale |
| `@orchestrator` | claude-sonnet-4-6 | 30 | Coordonne l'exécution d'un plan validé, dispatche les agents | Après plan validé, pour features larges multi-agents |
| `@architect` | claude-opus-4-8 | 20 | Décisions techniques, validation archi, droit de veto stack | Changements de stack, nouvelles libs, refactoring |
| `@fullstack-dev` | claude-sonnet-4-6 | 40 | Implémentation TDD (backend + frontend), isolé en worktree | Après plan validé |
| `@reviewer` | claude-opus-4-8 | 20 | Code review en contexte frais, sans biais | Avant merge — dernière porte avant production |
| `@debugger` | claude-opus-4-8 | 15 | Root cause analysis, reproduction minimale, lit les runbooks | Bugs non-triviaux, tests en échec |

**Règle** : `@planner` en premier. N'implémente pas sans plan validé. `@orchestrator` prend le relais pour les features larges.

## Workflow

```
Tâche non-triviale
      │
      ▼
  @planner ──→ PLAN.md validé
      │
      ▼
@orchestrator
   │       │
   │       ├──→ @architect (décision technique / veto)
   │       │
   ▼       ▼
@fullstack-dev   @debugger (bug bloquant)
      │
      ▼
  @reviewer ──→ merge
```

Pour une tâche simple (1 fichier, < 30 min) : `@planner` → `@fullstack-dev` → `@reviewer`, sans passer par `@orchestrator`.

## Slash Commands

| Commande | Modèle | Rôle |
|---|---|---|
| `/commit` | claude-haiku-4-5 | Génère un commit conventionnel depuis git diff |
| `/create-pr` | — | Crée une branche, commit, ouvre une PR via gh CLI |
| `/review` | claude-opus-4-8 | Code review niveau staff engineer sur les changements en cours |
| `/security-review` | — | Audit OWASP Top 10 sur les changements |
| `/tdd` | — | Cycle red → green → refactor strict |
| `/debug` | — | Débogage systématique en 5 étapes |
| `/runbook <module>` | claude-opus-4-8 | Génère un runbook de troubleshooting condensé pour un module |
| `/prime` | — | Re-prime le contexte après /clear |

## Skills

Chargées on-demand via le `Skill` tool — pas à chaque session.

| Skill | Modèle | Usage |
|---|---|---|
| `brainstorming` | claude-opus-4-8 | Design et spec avant d'implémenter — dialogue naturel pour explorer l'intention |
| `code-review` | claude-opus-4-8 | Revue approfondie niveau staff engineer |
| `code-quality` | claude-sonnet-4-6 | Dette technique, patterns, refactor |
| `commit-messages` | claude-haiku-4-5 | Conventions de messages git |

## Hooks

Définis dans `settings.json`, exécutés automatiquement par le harness (pas par Claude).

| Hook | Déclencheur | Effet |
|---|---|---|
| `PreToolUse(Bash)` | Avant chaque commande shell | Bloque `rm -rf`, `DROP TABLE`, `curl \| bash`, lecture de secrets via shell |
| `PreToolUse(Read)` | Avant chaque lecture de fichier | Bloque les fichiers `.env`, `*.pem`, `*.key`, `id_rsa`, `secrets.*` |
| `PreToolUse(Write\|Edit)` | Avant écriture | Bloque `.env*`, `.git/`, `package-lock.json`, `node_modules/` |
| `PostToolUse(Write\|Edit)` | Après écriture | Prettier auto sur `.ts`, `.tsx`, `.js`, `.jsx`, `.json`, `.css`, `.md` (si disponible) |
| `UserPromptSubmit` | À chaque prompt utilisateur | Bloque les opérations mentionnant `prod`, `main`, `master`, `force-push` |
| `PostToolBatch` | Après chaque batch d'outils | TypeScript check (`tsc --noEmit`) si `tsconfig.json` + `node_modules` présents |
| `PreCompact` | Avant compaction du contexte | Sauvegarde git status + PLAN.md dans `~/.claude/backups/` |
| `SessionStart` | Début de session | Affiche git status + PLAN.md en cours |
| `Notification` | Quand Claude attend l'input | Notification macOS / notify-send |

## Modèles

- **Modèle principal** : `opusplan` (Claude Opus en mode plan)
- **Fallback** : `claude-sonnet-4-6`
- Les agents et commandes peuvent surcharger le modèle dans leur frontmatter

## Standards enforced

Définis dans `CLAUDE.md` et appliqués par défaut à chaque session :

- **TypeScript strict** — zéro `any`
- **Fonctions ≤ 50 lignes**, complexité ≤ 10
- **SOLID + DDD** — Entity, Value Object, Aggregate Root, Repository, Bounded Context
- **Layering** — Presentation → Application → Domain → Infrastructure (dépendances vers l'intérieur uniquement)
- **Commits conventionnels** — `feat(scope):`, `fix:`, `refactor:`, etc. Sans attribution AI
- **Sécurité** — jamais de secrets lus ou commités, OWASP Top 10

## Installation

```bash
git clone <repo>
cd claude-config

# Option 1 — Symlinks (recommandé) : le repo devient la source de vérité
ln -sf "$(pwd)/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$(pwd)/claude/AGENT_STANDARDS.md" ~/.claude/AGENT_STANDARDS.md
ln -sf "$(pwd)/claude/agents" ~/.claude/agents
ln -sf "$(pwd)/claude/commands" ~/.claude/commands
ln -sf "$(pwd)/claude/settings.json" ~/.claude/settings.json

# Option 2 — Copie simple
cp -r claude/ ~/.claude/
```

Claude Code détecte automatiquement les fichiers dans `.claude/`.

## Licence

MIT
