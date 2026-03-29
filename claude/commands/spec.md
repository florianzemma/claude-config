# /spec

Interview + rédaction de spec avant implémentation.

## Comportement

1. **Interviewer** l'utilisateur avec max 5 questions pour comprendre :
   - Le problème métier (pas juste la feature)
   - Les cas d'usage principaux
   - Les contraintes (perf, sécurité, compatibilité)
   - Ce qui est hors scope

2. **Rédiger** la spec dans `docs/specs/YYYY-MM-DD-[feature].md`

## Format spec

```markdown
# Spec : [Feature]

## Problème
[Pourquoi on build ça]

## Solution
[Ce qu'on build exactement]

## Cas d'usage
1. [acteur] peut [action] pour [résultat]

## Contraintes
- [contrainte technique/métier]

## Hors scope
- [ce qu'on ne couvre pas]

## Critères d'acceptation
- [ ] [test concret]
```

**La spec est validée avant tout planning ou coding.**
