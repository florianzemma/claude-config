---
allowed-tools: Read, Edit, Write, Bash(git log*), Bash(git tag*)
description: Ajoute une entrée CHANGELOG.md au format Keep-a-Changelog depuis les commits depuis le dernier tag
model: claude-haiku-4-5
---
Génère et insère une entrée CHANGELOG.md pour la prochaine version.

$ARGUMENTS

Étapes :

1. **Dernier tag** — `git tag --sort=-version:refname | head -1` pour trouver le tag précédent.

2. **Commits** — `git log <tag>..HEAD --oneline --no-merges` pour lister les commits depuis ce tag.

3. **Classification** — classe chaque commit selon le format Keep-a-Changelog :
   - `Added` — nouvelle feature (commits `feat:`)
   - `Changed` — changement de comportement (commits `refactor:`, `perf:`)
   - `Fixed` — bug fix (commits `fix:`)
   - `Removed` — suppression d'API ou feature (commits `chore:` avec "remove/delete")
   - `Security` — fix de sécu (commits `fix:` + mots-clés sécu)
   - `Deprecated` — signale une API qui partira dans la prochaine version majeure

4. **Version** — si $ARGUMENTS contient un numéro de version (ex. `1.2.0`), utilise-le. Sinon, déduis la version depuis le dernier tag en incrémentant le patch.

5. **Insertion** — insère l'entrée en haut du bloc `[Unreleased]` ou crée la section `[X.Y.Z] - YYYY-MM-DD` juste après `[Unreleased]` dans CHANGELOG.md. Crée le fichier s'il n'existe pas.

Format cible :
```
## [X.Y.Z] - YYYY-MM-DD
### Added
- ...
### Fixed
- ...
```
