---
name: release-notes
description: Generate release notes or a changelog from conventional commits between two git tags or refs. Use when the user asks for release notes, a changelog, "what changed since" a version, or prepares a release.
model: haiku
---

# Release Notes

1. **Range** : par défaut `$(git describe --tags --abbrev=0)..HEAD` ; sinon les refs passées en argument.
2. **Collecte** : `git log <from>..<to> --pretty=format:'%h %s'` — ignore les commits de merge.
3. **Regroupe par type conventionnel**, dans cet ordre :
   - ⚠️ **Breaking changes** (`!` ou `BREAKING CHANGE`) — toujours en tête
   - 🚀 Features (`feat`)
   - 🐛 Fixes (`fix`)
   - ⚡ Performance (`perf`)
   - ♻️ Refactoring (`refactor`)
   - 📝 Docs / 🔧 Chore — une ligne condensée, ou omis si non pertinents
4. **Rédige orienté utilisateur** : l'impact, pas l'implémentation. "Les sessions expirées redirigent vers le login" > "fix du middleware auth".

Sortie : markdown prêt pour GitHub Release / CHANGELOG.md. N'écris aucun fichier sauf demande explicite.
