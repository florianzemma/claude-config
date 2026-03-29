# /cleanup

Agent anti-entropie — nettoie et restructure le codebase.

## Comportement

1. **Scanner** les fichiers modifiés récemment ou le scope spécifié
2. **Identifier** : code mort, TODO orphelins, imports inutilisés, duplication > 3%
3. **Proposer** une liste de nettoyages avec priorité
4. **Exécuter** après validation (pas d'auto-exécution destructive)

## Checklist type

- [ ] Supprimer imports inutilisés
- [ ] Extraire les magic numbers en constantes
- [ ] Renommer les variables peu claires
- [ ] Supprimer le code commenté
- [ ] Consolider les types dupliqués
- [ ] Mettre à jour les TODO résolus

Un commit propre par catégorie de nettoyage.
