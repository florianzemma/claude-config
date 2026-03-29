---
allowed-tools: Bash(git diff*), Bash(git add*), Bash(git commit*), Bash(git status*)
description: Génère un message de commit conventionnel depuis git diff et commit
model: claude-haiku-4-5
---
Génère et effectue un commit conventionnel pour les changements en cours.

$ARGUMENTS

Process :
1. `git status` — voir ce qui est modifié
2. `git diff --staged` — si rien de staged, `git diff HEAD` pour voir tous les changements
3. Analyser le diff et générer le message de commit optimal :
   - Format : `type(scope): description courte` (max 72 chars)
   - Types : feat, fix, refactor, test, docs, chore, perf, style
   - Description : temps présent, impératif, en anglais
   - Body optionnel si changement complexe (après une ligne vide)
4. Si rien n'est staged : proposer `git add -A` ou lister les fichiers pour choisir
5. `git commit -m "message généré"`

Règles absolues :
- Jamais d'attribution Claude/AI
- Commits atomiques — un seul sujet par commit
- Si trop de changements mélangés, proposer de les splitter
