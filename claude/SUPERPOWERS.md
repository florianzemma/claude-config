# Superpowers Plugin - Guide Installation

**Superpowers** est un plugin MCP ultra-efficace créé par Obra pour le brainstorming et la planification créative.

## 🚀 Installation

### Option 1 : Via Claude MCP (Recommandé)

```bash
claude mcp add superpowers
```

### Option 2 : Installation Manuelle

1. **Installer le serveur MCP Superpowers**
```bash
npm install -g @obra/mcp-server-superpowers
```

2. **Configurer dans Claude Code**

Éditez `~/.claude/settings.json` :
```json
{
  "mcpServers": {
    "superpowers": {
      "command": "npx",
      "args": ["-y", "@obra/mcp-server-superpowers"]
    }
  }
}
```

3. **Redémarrer Claude Code**
```bash
# Fermer toutes sessions Claude
# Relancer
claude
```

4. **Vérifier installation**
```bash
claude
> "List available MCP tools"

# Devrait inclure superpowers
```

## 🧠 Quand Utiliser Superpowers

### ✅ Cas d'Usage Optimaux

**1. Brainstorming Approches (avec @planner)**
```bash
claude
> "Use @planner to design notification system.
> @planner should use superpowers for brainstorming."
```

**2. Exploration Créative**
```bash
claude
> "Use superpowers to explore different architectures for real-time chat.
> Consider: WebSocket, SSE, Polling, hybrid approaches."
```

**3. Décomposer Problèmes Complexes**
```bash
claude
> "Use superpowers to break down this complex feature into subtasks:
> [Description feature complexe]"
```

**4. User Stories & Requirements**
```bash
claude
> "Use superpowers to generate user stories for [feature].
> Include: personas, user flows, edge cases."
```

**5. Décisions Techniques**
```bash
claude
> "Use superpowers to evaluate tech stack options for [project type].
> Compare: performance, DX, ecosystem, learning curve."
```

### ❌ Ne PAS Utiliser Pour

- Code implementation directe
- Simple bug fixes
- Refactoring code
- Tests writing

Pour ça, utilisez agents standards (@dev, @reviewer, etc.)

## 🔄 Workflow Recommandé

### Approche 1 : @planner + Superpowers (Complexe)

Pour features complexes nécessitant design thinking :

```bash
claude

> "Use @planner to plan [complex feature].
> Start with superpowers brainstorming."
```

**Ce qui se passe :**
1. @planner spawned
2. Utilise superpowers pour brainstorming
3. Explore codebase existant
4. Propose 2-3 options
5. Crée plan structuré dans SCRATCHPAD.md
6. Handoff pour implémentation

**Durée :** 30-60 min pour planning
**Output :** Plan détaillé validé

---

### Approche 2 : Superpowers Direct (Brainstorming Only)

Pour brainstorming rapide sans planning complet :

```bash
claude

> "Use superpowers to brainstorm solutions for [problem].
> Just creative exploration, no implementation yet."
```

**Durée :** 5-10 min
**Output :** Liste d'approches + pros/cons

---

### Approche 3 : Plan Mode (Exploration Rapide)

Pour exploration codebase simple :

```bash
claude

> /plan
> "Explore how authentication works in this codebase"
```

**Durée :** 5-15 min
**Output :** Compréhension architecture

---

## 📊 Matrice de Décision

| Besoin | Outil | Durée | Output |
|--------|-------|-------|--------|
| Brainstorm créatif | Superpowers direct | 5-10 min | Idées + options |
| Plan feature complexe | @planner + superpowers | 30-60 min | Plan structuré |
| Explorer code existant | /plan (Plan Mode) | 5-15 min | Compréhension |
| Feature simple | Single session | 10-30 min | Code ready |

## 💡 Exemples Concrets

### Exemple 1 : Feature Complexe

**Contexte :** Système de paiement multi-devises

```bash
claude

> "Use @planner to design a multi-currency payment system.
> Should support: Stripe, PayPal, crypto.
> Use superpowers to explore architecture options."
```

**Résultat :**
- @planner spawned
- Superpowers explore 4-5 architectures
- Planner analyse codebase
- Propose 3 options finales
- Plan détaillé créé
- Handoff à @architect pour validation

---

### Exemple 2 : Brainstorming Rapide

**Contexte :** Améliorer performance API

```bash
claude

> "Use superpowers to brainstorm performance optimization strategies for our API.
> Current: 500ms avg response time, 1000 req/min.
> Target: <200ms, 5000 req/min."
```

**Résultat :**
- Liste de 10-15 stratégies
- Catégorisées par impact/effort
- Pros/cons pour chaque
- Recommandations top 3

Pas de planning complet, juste brainstorming.

---

### Exemple 3 : User Stories

**Contexte :** Nouvelle fonctionnalité admin dashboard

```bash
claude

> "Use superpowers to generate comprehensive user stories for admin dashboard.
> Personas: Super Admin, Team Lead, Support Agent.
> Include: flows, edge cases, permissions."
```

**Résultat :**
- User personas détaillés
- User stories par rôle
- Edge cases identifiés
- Permission matrix

---

## 🎯 Intégration avec Agents

### @planner utilise Superpowers automatiquement

Le nouvel agent @planner est configuré pour utiliser superpowers dans sa phase UNDERSTAND.

**Workflow @planner :**
1. **UNDERSTAND** → Superpowers brainstorming
2. **EXPLORE** → Read codebase
3. **ARCHITECT** → Propose options
4. **PLAN** → SCRATCHPAD.md

**Vous n'avez qu'à dire :**
```bash
> "Use @planner to plan [feature]"
```

@planner handle superpowers automatiquement.

---

### Utilisation Standalone

Si vous voulez juste superpowers sans planning complet :

```bash
> "Use superpowers to [brainstorm task]"
```

---

## 🔧 Configuration Avancée

### Personnaliser Prompts Superpowers

Dans `~/.claude/settings.json` :

```json
{
  "mcpServers": {
    "superpowers": {
      "command": "npx",
      "args": ["-y", "@obra/mcp-server-superpowers"],
      "env": {
        "SUPERPOWERS_STYLE": "creative",
        "SUPERPOWERS_DEPTH": "deep"
      }
    }
  }
}
```

**Options :**
- `SUPERPOWERS_STYLE`: `creative`, `analytical`, `balanced`
- `SUPERPOWERS_DEPTH`: `quick`, `medium`, `deep`

---

## 📚 Resources

**Plugin Officiel :**
- GitHub: https://github.com/obra/mcp-server-superpowers
- NPM: https://www.npmjs.com/package/@obra/mcp-server-superpowers

**Documentation MCP :**
- Claude Code MCP: https://code.claude.com/docs/en/mcp

**Communauté :**
- Discord Obra: [lien si disponible]

---

## ⚠️ Troubleshooting

### Superpowers ne répond pas

```bash
# Vérifier installation
npm list -g @obra/mcp-server-superpowers

# Réinstaller
npm uninstall -g @obra/mcp-server-superpowers
npm install -g @obra/mcp-server-superpowers

# Redémarrer Claude
```

### "Tool not found"

Vérifier settings.json :
```bash
cat ~/.claude/settings.json | grep superpowers
```

Devrait contenir la config MCP.

---

**✨ Superpowers + @planner = Workflow optimal pour features complexes !**
