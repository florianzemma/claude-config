# Configuration Claude Code Optimisée - Février 2026

Configuration Claude Code suivant les **best practices officielles Anthropic 2026**.

> **⚠️ Migration effectuée le 14 février 2026** - Configuration optimisée selon best practices Anthropic

## 🎯 Philosophie

**95% des tâches en single session** - Subagents uniquement pour cas spéciaux.

Basé sur le workflow de **Boris Cherny** (créateur de Claude Code) :
1. **Explore** (Plan Mode) - Comprendre sans modifier
2. **Plan** - Designer l'approche (Ctrl+G pour éditer)
3. **Implement** (Normal Mode) - Coder avec auto-accept
4. **Verify** - Tests, commit

## 📊 Avant → Après Migration

| Aspect | Avant | Après | Amélioration |
|--------|-------|-------|--------------|
| **CLAUDE.md** | 217 lignes | 139 lignes | -36% |
| **Agents** | 14 agents + orchestrator | 5 subagents | -67% |
| **Workflow** | Pipeline obligatoire | Single session par défaut | 95% cas simplifiés |
| **Token usage** | Très élevé | Optimisé | Économies substantielles |
| **Complexité** | Haute (décisions multiples) | Simple (defaults clairs) | Temps décision réduit |

## 📁 Structure

```
.claude/ (152K)
├── CLAUDE.md                  # Instructions projet (139 lignes)
├── AGENT_STANDARDS.md         # Patterns partagés agents
├── SUPERPOWERS.md             # Guide plugin Obra brainstorming
├── settings.json              # Plugins, permissions optimisées
│
├── agents/                    # 5 subagents spécialisés
│   ├── planner.md             # 250 lignes - Planning + superpowers
│   ├── investigator.md        # 119 lignes - Recherche codebase
│   ├── reviewer.md            # 243 lignes - Review + plan alignment
│   ├── security-engineer.md   # 1088 lignes - Audit OWASP/NIST
│   └── architect.md           # 221 lignes - Architecture decisions
│
├── skills/                    # 8 workflows répétables
│   ├── commit/                # /commit - Conventional commits
│   ├── pr/                    # /pr - Pull requests
│   ├── review/                # /review - Code reviews
│   ├── code-quality/          # Standards qualité code
│   ├── architectural-patterns/ # SOLID, DDD, Clean Code
│   ├── linting-setup/         # ESLint, Prettier, hooks
│   ├── logging-monitoring/    # Sentry, Winston logging
│   └── sonarqube-quality/     # Quality gates CI/CD
│
└── templates/                 # Templates externes
    ├── SCRATCHPAD.md          # External memory planning
    └── ADR_TEMPLATE.md        # Architecture Decision Records
```

## 🚀 Quick Start

### Installation

```bash
# Installation native (recommandée - auto-update)
curl -fsSL https://claude.ai/install.sh | bash

# Ou via Homebrew
brew install --cask claude-code

# Vérifier installation
claude --version
```

### Utilisation

**1. Feature Simple (90% des cas)** :
```bash
cd votre-projet
claude

> "Ajoute validation email sur le formulaire signup"
```
Claude explore, code, teste en single session.

**2. Feature Moyenne (avec Plan Mode)** :
```bash
claude

> /plan
> "Explore notre système auth, je veux ajouter OAuth2 Google"

# Claude explore (READ-ONLY)
# Propose plan
# Ctrl+G pour éditer si besoin
# Valider

> Esc (sortir Plan Mode)
> "Implémente le plan OAuth2. Auto-accept edits."
```

**3. Investigation Approfondie** :
```bash
claude

> "Use @investigator to understand how payment processing works.
> Focus on security and validation patterns."

# Investigator explore dans son propre contexte
# Rapport détaillé retourné
# Main context reste clean
```

**4. Code Review** :
```bash
claude

> /review 142

# Spawne @reviewer automatiquement
# Review OWASP + qualité + architecture
# Feedback catégorisé (CRITICAL > HIGH > MEDIUM > LOW)
```

## 🤖 Les 5 Subagents

### @planner - Planning + Brainstorming (avec Superpowers)
**Quand :** Features complexes, design thinking, multiple approches à évaluer

```bash
"Use @planner to design real-time notification system.
Start with brainstorming different approaches."
```

**Output :** Plan structuré dans SCRATCHPAD.md avec options évaluées

**Utilise Superpowers plugin** pour brainstorming créatif automatiquement.

---

### @investigator - Recherche Codebase
**Quand :** Investigation volumineuse, comprendre architecture existante

```bash
"Use @investigator to research API authentication flow.
Focus on token validation and session management."
```

**Output :** Rapport structuré avec architecture, patterns, fichiers clés

---

### @reviewer - Code Review + Sécurité
**Quand :** Review PR, audit sécurité, validation qualité

```bash
"Use @reviewer to audit the payment module for security issues.
Check OWASP Top 10:2025 vulnerabilities."
```

**Output :** Review catégorisé (CRITICAL/HIGH/MEDIUM/LOW) + verdict

---

### @security - Audit Sécurité
**Quand :** Audit sécurité, code auth/payment/PII, conformité OWASP/NIST

```bash
"Use @security to audit authentication module.
Check for OWASP Top 10:2025 and NIST CSF 2.0 compliance."
```

**Output :** Rapport sécurité avec vulnérabilités + recommandations NIST/OWASP

---

### @architect - Décisions Architecture
**Quand :** Décisions techniques, choix stack, éviter over-engineering

```bash
"Use @architect to evaluate if we should migrate to GraphQL.
Current REST API has 45 endpoints."
```

**Output :** Évaluation + recommandation APPROVED/REJECTED + alternative

---

## ⚡ Skills Disponibles

### /commit - Conventional Commits
```bash
# Faire vos changements
claude

> /commit

# Claude va:
# 1. git status + git diff
# 2. Générer message conventional
# 3. Stage files explicitement (jamais git add .)
# 4. Créer commit sans AI attribution
```

### /pr - Pull Request
```bash
claude

> /pr

# Claude va:
# 1. Analyser tous les commits depuis divergence
# 2. Générer titre + description structurée
# 3. Créer PR via gh CLI
# 4. Retourner URL
```

### /review - Code Review
```bash
claude

> /review 142

# Claude va:
# 1. Fetcher PR #142
# 2. Spawner @reviewer subagent
# 3. Analyser sécurité + qualité + architecture
# 4. Poster review sur GitHub
```

## 📖 Documentation Complète

**Organisation :**
- **Fichiers racine** → Configuration globale et guides
- **Agents** → Subagents spécialisés (5 total)
- **Skills** → Workflows répétables (8 total)
- **Templates** → Mémoire externe et ADR

### Fichiers Principaux
- **[CLAUDE.md](.claude/CLAUDE.md)** - Instructions projet (139 lignes, < 150 ✅)
- **[AGENT_STANDARDS.md](.claude/AGENT_STANDARDS.md)** - Patterns partagés agents
- **[SUPERPOWERS.md](.claude/SUPERPOWERS.md)** - Guide plugin Obra brainstorming
- **[settings.json](.claude/settings.json)** - Plugins, allowedCommands, permissions

### Agents (5 spécialisés)
- **[planner.md](.claude/agents/planner.md)** - Planning + superpowers (250 lignes)
- **[investigator.md](.claude/agents/investigator.md)** - Recherche codebase (119 lignes)
- **[reviewer.md](.claude/agents/reviewer.md)** - Review + plan alignment (243 lignes)
- **[security-engineer.md](.claude/agents/security-engineer.md)** - OWASP/NIST (1088 lignes)
- **[architect.md](.claude/agents/architect.md)** - Architecture (221 lignes)

### Skills (8 workflows)
- **[commit/](.claude/skills/commit/)** - Conventional commits
- **[pr/](.claude/skills/pr/)** - Pull requests
- **[review/](.claude/skills/review/)** - Code reviews
- **[code-quality/](.claude/skills/code-quality/)** - Standards qualité
- **[architectural-patterns/](.claude/skills/architectural-patterns/)** - SOLID, DDD
- **[linting-setup/](.claude/skills/linting-setup/)** - ESLint, Prettier
- **[logging-monitoring/](.claude/skills/logging-monitoring/)** - Sentry, Winston
- **[sonarqube-quality/](.claude/skills/sonarqube-quality/)** - Quality gates

## 🧪 Tester la Configuration

### Test 1 : Single Session (5 min)
```bash
claude
> "Add console.log('Hello World') in src/index.ts and test"

# Vérifier :
- ✅ Claude explore, code, teste
- ✅ Pas d'agent spawné
- ✅ Context minimal
```

### Test 2 : Investigation Subagent (10 min)
```bash
claude
> "Use @investigator to understand our database schema.
> Focus on relationships and migrations."

# Vérifier :
- ✅ @investigator spawned
- ✅ Investigation isolée (pas dans main context)
- ✅ Rapport concis retourné
```

### Test 3 : Workflow /commit (5 min)
```bash
# Faire un changement
claude
> /commit

# Vérifier :
- ✅ Files staged explicitement
- ✅ Conventional commit format
- ✅ No AI attribution
```

### Test 4 : Plan Mode (15 min)
```bash
claude
> /plan
> "Explore src/api/ and explain API structure"

# Vérifier :
- ✅ Plan Mode read-only
- ✅ Pas de modifications

> Esc
> "Add new endpoint following existing patterns"

# Vérifier :
- ✅ Normal mode implémente
- ✅ Pattern existant suivi
```

## 🎯 Quand Utiliser Quoi

| Tâche | Approche | Agents | Durée |
|-------|----------|--------|-------|
| Fix typo README | Single session | 0 | < 5 min |
| Add button UI | Single session | 0 | 5-10 min |
| Debug failing test | Single session | 0 | 10-20 min |
| Refactor module (3-5 files) | Plan Mode + Single | 0 | 30-60 min |
| Understand new codebase | @investigator | 1 | 20-30 min |
| Add feature (multi-layer) | Plan Mode + Single | 0-1 | 1-2h |
| Security audit | @reviewer | 1 | 30-60 min |
| Architecture decision | @architect | 1 | 20-40 min |
| Code review PR | /review (@reviewer) | 1 | 10-20 min |
| Complex feature (10+ files) | Plan + @investigator | 1-2 | 2-4h |

## 🔧 Configuration Personnalisée

### Ajouter Commandes Autorisées

Éditez `.claude/settings.json` :
```json
{
  "allowedCommands": [
    "votre-commande *",
    "autre-commande"
  ]
}
```

### Self-Correction Loop

Quand Claude fait **2× la même erreur**, ajoutez à `CLAUDE.md` :
```markdown
## Continuous Improvement

- NEVER [erreur à éviter]
- ALWAYS [bonne pratique]
```

La règle devient permanente pour toutes futures sessions.

## ⚠️ Troubleshooting

### Claude ignore mes instructions
**Cause :** CLAUDE.md trop long (>150 lignes)
**Fix :** Vérifier `wc -l .claude/CLAUDE.md`, pruner si >150

### Context se remplit trop vite
**Cause :** Investigation en main session
**Fix :** Utiliser @investigator subagent

### Trop de prompts permission
**Cause :** Commandes non autorisées
**Fix :** Ajouter à `allowedCommands` dans settings.json

### Je sais pas quel agent utiliser
**Cause :** Overthinking
**Fix :** 95% = single session. Agents seulement si vraiment nécessaire.

### Claude propose solutions déjà rejetées
**Cause :** Context pollué avec tentatives ratées
**Fix :** `/clear` et reformuler avec meilleur prompt

## 🆘 Rollback (Si Besoin)

Si problèmes avec nouvelle config :

```bash
# Restaurer backup complet
rm -rf .claude
cp -r .claude.backup-20260214-163751 .claude

# Ou fichier spécifique
cp .claude.backup-20260214-163751/CLAUDE.md .claude/CLAUDE.md
```

Backup créé automatiquement le 14 février 2026 à 16:37.

## 📈 Métriques de Succès

Après optimisation, vous devriez observer :

- ✅ **-40-60% tokens utilisés** (single session vs multi-agent)
- ✅ **Réponses plus cohérentes** (CLAUDE.md < 150 lignes)
- ✅ **Workflow plus rapide** (moins overhead décisionnel)
- ✅ **Context plus clean** (investigations isolées)
- ✅ **Coûts réduits** (moins d'agents = moins de tokens)

## 🔗 Ressources Officielles

### Documentation Anthropic
- [Best Practices Claude Code](https://code.claude.com/docs/en/best-practices) ⭐
- [Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [Agent Teams (Experimental)](https://code.claude.com/docs/en/agent-teams)

### Workflow Créateur
- [Boris Cherny Workflow (InfoQ)](https://www.infoq.com/news/2026/01/claude-code-creator-workflow/)

### Communauté
- [CLAUDE.md Best Practices (Arize)](https://arize.com/blog/claude-md-best-practices-learned-from-optimizing-claude-code-with-prompt-learning/)
- [High Performance CLAUDE.md](https://github.com/ruvnet/claude-flow/wiki/CLAUDE-MD-High-Performance)

## 📝 Changelog Configuration

### v2.0.0 - 2026-02-14 (Migration Majeure)

**Breaking Changes:**
- CLAUDE.md réduit de 217 → 139 lignes
- 14 agents → 5 subagents (planner, investigator, reviewer, security, architect)
- Pipeline obligatoire → Single session par défaut
- Orchestrator supprimé

**Added:**
- @planner agent avec intégration superpowers plugin
- @security agent (OWASP Top 10:2025 + NIST CSF 2.0)
- @reviewer enhanced (plan alignment + MCP tools + level-based)
- Skills: /commit, /pr, /review (+ 5 autres skills)
- SUPERPOWERS.md - Guide plugin Obra brainstorming
- AGENT_STANDARDS.md - Patterns partagés agents
- settings.json - allowedCommands optimisées

**Improved:**
- Token usage optimisé (-40-60%)
- Context management amélioré
- Self-correction loop documenté
- Conformité best practices 2026

### v1.0.0 - 2025

Configuration initiale avec 14 agents et pipeline multi-étapes.

---

## 📄 Licence

MIT License

---

**Configuration optimisée : Février 2026**

**Principes clés :**
- Single session par défaut (95% cas)
- 5 subagents spécialisés (planner, investigator, reviewer, security, architect)
- CLAUDE.md < 150 lignes
- Context management agressif
- Self-correction loop
- Superpowers pour brainstorming créatif

**✅ Conforme best practices Anthropic 2026**
