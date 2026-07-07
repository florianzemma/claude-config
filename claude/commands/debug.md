---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(npm test*), Bash(pnpm test*), Bash(npx vitest*), Bash(npx jest*), Bash(git log*), Bash(git blame*), Bash(git bisect*)
description: Debug systématique en 5 étapes — reproduce, isoler, root cause, fix minimal, régression
---
Debug ce problème de façon systématique :

$ARGUMENTS

**Prérequis : construis une feedback loop avant tout**

Avant de formuler la moindre hypothèse, tu dois avoir une commande rouge-capable — une commande unique qui reproduit le bug et que tu peux relancer en 1-2 secondes. Sans ça, ne passe pas à l'étape 1.

Options par ordre de préférence :
- Test automatisé qui échoue (`npx vitest run path/to/test`)
- Appel CLI/curl qui reproduit le comportement fautif
- Script minimal isolé (`node reproduce.ts`)
- `git bisect run <commande>` si c'est une régression

Si aucune n'est réalisable, dis-le explicitement et explique pourquoi.

---

Suis ces 5 étapes dans l'ordre. Ne saute aucune.

**1. Reproduire**
Lance ta commande rouge-capable. Elle doit échouer de façon déterministe. Si le bug est intermittent, documente les conditions qui le déclenchent avant d'aller plus loin.

**2. Isoler**
Réduis le périmètre au minimum : quel fichier, quelle fonction, quelle ligne. Si le bug est régressif, utilise `git log` pour trouver le commit qui l'a introduit. `git bisect` si nécessaire.

**3. Root cause**
Identifie la cause racine — pas le symptôme. "La valeur est null" n'est pas une root cause. Remonte jusqu'à "pourquoi est-elle null ici ?". Lis `git blame` sur la ligne suspecte si utile.

**4. Fix minimal**
Applique le fix le plus petit possible qui corrige la root cause. Pas de refactor opportuniste. Pas de "pendant que j'y suis".

**5. Régression**
Vérifie que le test de l'étape 1 est maintenant vert. Lance toute la suite de tests. Documente le fix dans un commentaire seulement si le WHY est non-obvious.

Si tu bloques après 3 tentatives sur l'étape 2 ou 3, dis-le et expose tes hypothèses restantes.
