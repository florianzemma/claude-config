---
allowed-tools: Read, Glob, Grep, Bash(git diff*), Bash(git log*), Bash(git status*), Bash(git rev-parse*), Bash(git merge-base*), Bash(git symbolic-ref*), Skill
description: Code review niveau staff engineer — délègue au skill code-review
---
Invoque le skill `code-review` et applique-le aux changements en cours.

$ARGUMENTS

## 1. Fixe le point de comparaison

Dans cet ordre :

- **Une ref passée en argument** (SHA, branche, tag, `main`, `HEAD~5`) → `git diff <ref>...HEAD`. **Trois points obligatoires** : compare au merge-base, pas à la pointe de la ref — sinon le diff inclut les commits arrivés sur la ref depuis le départ de branche et la review porte sur du code que personne n'a écrit ici.
- **Sinon, working tree modifié** (`git status --porcelain` non vide) → `git diff HEAD`, staged + unstaged.
- **Sinon, branche déjà commitée** → merge-base avec la branche par défaut : `git diff $(git symbolic-ref --quiet --short refs/remotes/origin/HEAD || echo origin/main)...HEAD`.

## 2. Valide avant de reviewer

`git rev-parse --verify <ref>` doit sortir en 0 (`--verify` obligatoire : `git rev-parse` nu ré-affiche la ref sur stdout même quand elle n'existe pas, ce qui se lit comme un succès), et le diff doit être non vide. **Un diff vide s'arrête ici** — dis-le et demande le bon point de comparaison. Ne lance jamais le skill sur un diff vide : il produirait une review d'apparence normale sur rien.

Récupère aussi la liste des commits couverts : `git log <point>..HEAD --oneline` (deux points ici).

## 3. Review

Exécute le skill `code-review` sur ce diff, en lui passant la plage retenue et la liste des commits.
