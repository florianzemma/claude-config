# /plan

Crée un plan structuré avant d'implémenter quoi que ce soit.

## Comportement

1. **Analyser** la demande — poser max 3 questions clarifiantes si nécessaire
2. **Décomposer** en étapes numérotées avec estimation effort
3. **Identifier** les risques et dépendances
4. **Écrire** le plan dans `docs/plans/YYYY-MM-DD-[sujet].md`
5. **Attendre** la validation explicite avant de coder

## Format du plan

```markdown
# Plan : [Titre]

## Objectif
[Ce qu'on build et pourquoi]

## Étapes
1. [ ] Étape 1 — [description] (~Xh)
2. [ ] Étape 2 — [description] (~Xh)

## Risques
- [risque] → [mitigation]

## Hors scope
- [ce qu'on ne fait PAS]
```

**Ne pas coder avant validation explicite du plan.**
