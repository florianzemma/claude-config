---
allowed-tools: Read, Glob, Grep, Write, Bash(git status*), Bash(git log*), Bash(find*)
description: Crée un plan structuré dans PLAN.md avant d'implémenter quoi que ce soit
---
Analyse la tâche suivante et crée un plan structuré dans PLAN.md :

$ARGUMENTS

Le plan doit contenir :
1. Objectif — une phrase claire
2. Fichiers impactés — liste exhaustive avec chemin
3. Phases — étapes séquentielles, chacune testable indépendamment (5-10 min max chacune)
4. Critères de succès — comment vérifier que c'est fait
5. Risques — ce qui peut mal tourner et comment mitiger

Utilise un subagent pour explorer la codebase si nécessaire.

N'implémente RIEN. Juste le plan. Attends ma validation avant de coder.
