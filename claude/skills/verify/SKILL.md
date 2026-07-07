---
name: verify
description: Verify that a completed change actually works by exercising it end-to-end — full test suite, typecheck, then drive the real behavior (app, endpoint, CLI, UI) and compare observed behavior against the success criteria. Use PROACTIVELY before declaring any non-trivial implementation done, before committing, and before creating a PR. Never claim "done" without executed evidence.
---

# Verify — prouver que ça marche

But : prouver que le changement **marche**, pas seulement qu'il compile. "Les tests passent" ne suffit pas si le comportement réel n'a pas été exercé.

## Étapes

1. **Critère de succès** — retrouve-le (PLAN.md, demande d'origine). S'il n'existe pas, formule-le en une phrase vérifiable avant de continuer.

2. **Checks statiques** — suite de tests complète (pas juste les nouveaux tests) + typecheck + linter du projet. Un échec = stop, corrige avant de passer à l'étape 3.

3. **Exercer le changement réel** — choisis selon la surface touchée :
   - API : démarre le serveur, appelle l'endpoint (`curl`), vérifie la réponse nominale ET un cas d'erreur
   - UI : lance l'app, navigue le flux touché, screenshot si possible
   - CLI/script : exécute avec un input réaliste
   - Lib pure : un test d'intégration qui traverse le chemin complet, pas que des unités mockées

4. **Compare** l'observé au critère de l'étape 1, point par point.

## Format de sortie

```
VERIFY: PASS | FAIL | PARTIEL
Critère : [une phrase]
Preuves :
- [commande exécutée] → [résultat observé]
Non vérifié : [ce qui n'a pas pu être exercé et pourquoi — ou "rien"]
```

## Règles

- Jamais "terminé" sans preuve exécutée dans la sortie.
- Environnement insuffisant pour exercer le changement → verdict PARTIEL explicite. Un PARTIEL honnête vaut mieux qu'un PASS menteur.
- Ne modifie pas le code pendant la vérification. Si ça échoue : rapporte d'abord, corrige ensuite, puis re-vérifie.
