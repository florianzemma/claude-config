---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(npm test*), Bash(pnpm test*), Bash(npx vitest*), Bash(npx jest*), Bash(npx playwright*)
description: Test-Driven Development strict — red → green → refactor, jamais de code sans test échouant
---
Implémente la feature suivante en TDD strict :

$ARGUMENTS

Cycle obligatoire — ne jamais sauter une étape :

**🔴 RED** — Écris d'abord un test qui échoue
- Test unitaire pour la logique métier
- Test d'intégration si la feature touche plusieurs couches
- Lance les tests : ils DOIVENT échouer (si ça passe déjà, le test est mal écrit)

**🟢 GREEN** — Implémente le minimum pour faire passer le test
- Code le plus simple possible
- Pas d'optimisation, pas d'abstractions prématurées
- Un seul objectif : faire passer le test rouge

**🔵 REFACTOR** — Améliore sans casser
- Supprimer la duplication
- Améliorer les noms
- Simplifier la logique
- Les tests doivent toujours passer après chaque changement

Répète le cycle pour chaque comportement à ajouter.
Ne jamais écrire de code de production sans test rouge qui l'appelle.
