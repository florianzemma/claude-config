---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(npm test*), Bash(pnpm test*), Bash(npx vitest*), Bash(npx jest*)
description: Quick bug fix sans pipeline — reproduce, root cause, fix minimal, test
---
Fix ce bug directement, sans pipeline agents :

$ARGUMENTS

Process :
1. Reproduis le problème (écris un test qui échoue si possible)
2. Isole la cause racine
3. Corrige avec le changement minimal nécessaire
4. Vérifie que le test passe
5. Vérifie qu'aucun autre test ne casse
6. Commit avec format : fix(scope): description
