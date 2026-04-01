---
allowed-tools: Bash(git*), Bash(gh*)
description: Crée une branche, commit les changements, et ouvre une PR via gh CLI
---
Crée une pull request pour les changements en cours :

$ARGUMENTS

Process :
1. Vérifie qu'on est pas sur main/master — si oui, crée une branche `feat/` ou `fix/` selon le type
2. `git status` — liste les fichiers modifiés
3. `git diff --staged` — si rien de staged, faire `git add -p` pour choisir les changements pertinents
4. Génère un message de commit conventionnel basé sur le diff
5. `git commit`
6. `git push -u origin <branche>`
7. `gh pr create` avec :
   - Titre : le message de commit (sans le type/scope)
   - Body : liste des changements, contexte, et checklist de review
   - Base : main (ou la branche cible si précisée dans $ARGUMENTS)

Si la branche existe déjà sur origin, proposer un `git push --force-with-lease` avec confirmation.
