---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(git diff*), Bash(git status*)
description: Génère et met à jour la documentation pour les fichiers modifiés dans le diff courant
---
Met à jour la documentation pour les changements en cours.

$ARGUMENTS

Étapes :

1. **Analyse du diff** — `git diff HEAD` pour identifier les fichiers modifiés. Si $ARGUMENTS précise un fichier ou dossier, concentre-toi là-dessus.

2. **Détection des gaps** — pour chaque fichier modifié :
   - Fonctions/méthodes publiques sans JSDoc/docstring → génère-les
   - Nouveaux paramètres ou valeurs de retour non documentés → complète
   - Classes exportées sans description → ajoute une ligne de description

3. **README** — si tu as ajouté une route, une commande CLI, une option de config, ou une API publique, mets à jour la section concernée du README. Ne réécris pas ce qui n'a pas changé.

4. **Rapport** — liste en fin de réponse : fichiers documentés, lignes ajoutées, ce qui a été ignoré et pourquoi.

Règles :
- Pas de commentaires qui paraphrasent le code (`// increment counter` → non)
- JSDoc uniquement pour les API publiques (fonctions exportées, méthodes de classe publiques)
- Docstrings Python : format Google-style
- Un commentaire = une contrainte cachée, un invariant subtil, ou un workaround avec ticket
