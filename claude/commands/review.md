---
allowed-tools: Read, Glob, Grep, Bash(git diff*), Bash(git log*), Bash(git status*)
description: Code review niveau staff engineer sur les changements en cours
model: claude-opus-4-5
---
Fais une review de code comme un staff engineer senior. Analyse les changements en cours.

$ARGUMENTS

Commence par git diff (staged et unstaged). Évalue :

1. Correctness — le code fait-il ce qu'il prétend faire ?
2. Edge cases — quels cas limites ne sont pas gérés ?
3. Simplicité — peut-on simplifier sans perdre en fonctionnalité ?
4. Conventions — respecte-t-on les patterns existants du projet ?
5. Tests — la couverture est-elle suffisante pour les changements ?

Sois critique et constructif. Ne valide pas par complaisance.
Format : liste numérotée des problèmes par sévérité (bloquant → suggestion).
