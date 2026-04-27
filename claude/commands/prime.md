---
allowed-tools: Read, Glob, Bash(git status*), Bash(git log*), Bash(find*)
description: Re-prime le contexte Claude après /clear — arbo, README, CLAUDE.md, PLAN.md, git status
---
Charge le contexte essentiel de ce projet pour cette session.

Effectue ces étapes dans l'ordre :

1. **Arborescence** — affiche la structure des dossiers (profondeur 2, sans node_modules/.git)
   ```
   find . -maxdepth 2 -not -path '*/node_modules/*' -not -path '*/.git/*' | sort
   ```

2. **Fichiers clés** — lis dans l'ordre s'ils existent :
   - `README.md` ou `README` (résumé du projet)
   - `CLAUDE.md` ou `.claude/CLAUDE.md` (instructions Claude)
   - `PLAN.md` (plan en cours si présent)
   - `SCRATCHPAD.md` (état temporaire si présent)

3. **Git** — exécute :
   ```
   git status --short
   git log --oneline -10
   ```

4. **Résumé** — conclus en une seule phrase : projet, stack, état git, plan actif si trouvé.

Ne génère pas de fichier. Sortie inline uniquement.
