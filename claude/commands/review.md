---
allowed-tools: Read, Glob, Grep, Bash(git diff*), Bash(git log*), Bash(git status*), Skill
description: Code review niveau staff engineer — délègue au skill code-review
---
Invoque le skill `code-review` et applique-le aux changements en cours.

$ARGUMENTS

Commence par récupérer le diff complet (staged + unstaged) via `git diff HEAD`, puis exécute le skill `code-review` sur ce diff.
