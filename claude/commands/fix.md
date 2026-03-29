# /fix

Quick bug fix sans pipeline — pour les corrections simples et localisées.

## Comportement

1. **Identifier** le bug — lire le contexte, les logs, reproduire si possible
2. **Root cause** — ne pas patcher le symptôme, trouver la cause
3. **Fixer** — minimal, chirurgical, pas de refactoring opportuniste
4. **Tester** — vérifier que le fix ne casse rien (run tests si dispo)
5. **Commiter** — `fix(scope): description du bug corrigé`

## Règles

- Un fix = un commit
- Pas de changements hors scope du bug
- Si le fix révèle un problème plus profond → signaler mais ne pas fixer maintenant
- Si le bug nécessite > 3 fichiers modifiés → utiliser le pipeline complet (`/plan`)
