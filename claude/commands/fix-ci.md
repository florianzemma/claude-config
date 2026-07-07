---
allowed-tools: Bash(gh run*), Bash(gh pr*), Bash(gh workflow*), Read, Glob, Grep, Edit
description: Analyse le dernier run CI en échec et propose un fix ciblé (sans commit auto)
---
Diagnostique et corrige le CI en échec sur la branche courante.

$ARGUMENTS

Étapes :

1. **Identification** — trouve le dernier run en échec :
   ```
   gh run list --limit 5 --branch $(git branch --show-current)
   gh run view <run-id> --log-failed
   ```

2. **Analyse** — lis les logs d'erreur. Identifie :
   - Quelle étape a échoué (lint, typecheck, test, build, deploy)
   - Le message d'erreur exact
   - Le fichier et la ligne concernés si disponibles

3. **Root cause** — lis les fichiers incriminés. Ne fixe pas le symptôme, fixe la cause.

4. **Fix** — applique le correctif minimal. Si le problème est dans une config CI (`.github/workflows/`, `Dockerfile`, etc.), modifie-la. Si c'est du code, modifie le code.

5. **Rapport** — conclus avec :
   - Ce qui était cassé et pourquoi
   - Ce qui a été modifié
   - Comment vérifier localement avant de push (commande à lancer)

Pas de commit automatique. Montre le diff, laisse l'utilisateur valider.

Si tu n'as pas accès au run (repo privé sans auth), demande à l'utilisateur de coller les logs d'erreur.
