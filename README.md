# Claude Code Configuration

Configuration personnelle de Claude Code avec agents spécialisés, slash commands, skills et standards architecturaux.

## Structure

```
claude-config/
├── claude/
│   ├── CLAUDE.md              # Instructions principales (lues à chaque session)
│   ├── AGENT_STANDARDS.md     # Standards partagés entre agents
│   ├── agents/                # Agents spécialisés (contexte isolé 200K)
│   │   ├── planner.md
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
│   ├── settings.json          # Permissions et hooks
│   └── settings.local.json
└── README.md
```

## Agents

5 agents, chacun dans un contexte frais isolé (200K tokens).

| Agent | Rôle | Quand |
|---|---|---|
| `@planner` | Analyse, pose des questions, produit un plan validé | Entry point obligatoire pour toute tâche non-triviale |
| `@architect` | Décisions techniques, validation archi, droit de veto stack | Changements de stack, nouvelles libs, refactoring |
| `@fullstack-dev` | Implémentation TDD (backend + frontend) | Après plan validé |
| `@reviewer` | Code review en contexte frais, sans biais | Avant merge |
| `@debugger` | Root cause analysis, reproduction minimale | Bugs non-triviaux, tests en échec |

**Règle** : `@planner` en premier. N'implémente pas sans plan validé.

## Slash Commands

| Commande | Rôle |
|---|---|
| `/commit` | Génère un commit conventionnel depuis git diff |
| `/create-pr` | Crée une branche, commit, ouvre une PR |
| `/review` | Code review niveau staff engineer |
| `/security-review` | Audit OWASP Top 10 sur les changements |
| `/tdd` | Cycle red → green → refactor strict |
| `/debug` | Débogage systématique en 5 étapes |
| `/prime` | Re-prime le contexte après /clear |

## Skills

Chargées on-demand (pas à chaque session).

| Skill | Usage |
|---|---|
| `brainstorming` | Design et spec avant d'implémenter |
| `code-review` | Revue approfondie niveau staff |
| `code-quality` | Dette technique, patterns, refactor |
| `commit-messages` | Conventions de messages git |

## Workflow

```
Tâche non-triviale
      │
      ▼
  @planner ──→ plan validé
      │
      ▼
@fullstack-dev (TDD)
      │
      ▼
  @reviewer ──→ merge
```

Pour les décisions techniques en cours de route : `@architect` (droit de veto).
Pour les bugs bloquants : `@debugger`.

## Standards

Définis dans `CLAUDE.md` et appliqués par défaut :

- **TypeScript strict** — zéro `any`
- **Fonctions ≤ 50 lignes**, complexité ≤ 10
- **SOLID + DDD** — Entity, Value Object, Aggregate, Repository, Bounded Context
- **Layering** — Presentation → Application → Domain → Infrastructure
- **Commits conventionnels** — `feat(scope):`, `fix:`, `refactor:`, etc.
- **Sécurité** — jamais de secrets lus ou commités, OWASP Top 10

## Installation

```bash
git clone <repo>
cd claude-config

# Copier la config dans votre projet ou globalement
cp -r claude/ /path/to/your/project/.claude/
# ou pour une config globale
cp -r claude/ ~/.claude/
```

Claude Code détecte automatiquement les fichiers dans `.claude/`.

## Licence

MIT
