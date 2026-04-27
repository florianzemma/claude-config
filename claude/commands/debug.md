---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(npm test*), Bash(pnpm test*), Bash(npx vitest*), Bash(npx jest*), Bash(git log*), Bash(git blame*), Bash(git bisect*)
description: Debug systématique en 5 étapes — reproduce, isoler, root cause, fix minimal, régression
---
Debug ce problème de façon systématique :

$ARGUMENTS

Suis ces 5 étapes dans l'ordre. Ne saute aucune.

**1. Reproduire**
Écris un test qui échoue démontrant le bug. Si tu ne peux pas le reproduire, dis-le clairement avant d'aller plus loin.

**2. Isoler**
Réduis le périmètre au minimum : quel fichier, quelle fonction, quelle ligne. Si le bug est régressif, utilise `git log` pour trouver le commit qui l'a introduit. `git bisect` si nécessaire.

**3. Root cause**
Identifie la cause racine — pas le symptôme. "La valeur est null" n'est pas une root cause. Remonte jusqu'à "pourquoi est-elle null ici ?". Lis `git blame` sur la ligne suspecte si utile.

**4. Fix minimal**
Applique le fix le plus petit possible qui corrige la root cause. Pas de refactor opportuniste. Pas de "pendant que j'y suis".

**5. Régression**
Vérifie que le test de l'étape 1 est maintenant vert. Lance toute la suite de tests. Documente le fix dans un commentaire seulement si le WHY est non-obvious.

Si tu bloques après 3 tentatives sur l'étape 2 ou 3, dis-le et expose tes hypothèses restantes.
