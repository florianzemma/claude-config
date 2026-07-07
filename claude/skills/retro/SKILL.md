---
name: retro
description: End-of-task retrospective that turns user corrections into config improvements (compounding engineering). Use PROACTIVELY at the end of a task where the user corrected you, repeated an instruction, or expressed friction — proposes CLAUDE.md rule additions, hook conversions, or rule pruning. Proposes only; applies nothing without user validation.
---

# Retro — compounding engineering

Chaque erreur corrigée doit devenir une règle. Chaque règle qui ne sert plus doit disparaître. C'est comme ça qu'une config s'améliore toute seule.

## Étapes

1. **Relis la conversation** : corrections de l'utilisateur, instructions répétées, allers-retours qui auraient pu être évités, hypothèses fausses que j'ai faites.

2. **Classe chaque friction** au bon endroit :
   - Règle générale de travail → une ligne dans `~/.claude/CLAUDE.md`, dans la section appropriée
   - Doit arriver à 100% des cas (format, interdit, protection) → hook dans `settings.json` — déterministe bat advisory
   - Procédure réutilisable multi-étapes → skill ou command
   - Spécifique à un projet → CLAUDE.md du projet, jamais le global

3. **Propose au maximum 3 changements** — les plus rentables — avec le diff exact, prêt à appliquer.

4. **Pruning test** : repère les règles de CLAUDE.md qui n'ont influencé aucune décision récente et propose leur suppression. Une config courte est une config suivie.

5. **N'applique rien sans validation** de l'utilisateur.

## Format par proposition

```
Friction observée : [ce qui s'est mal passé, avec la citation]
Changement proposé : [diff exact — fichier, section, ligne]
Pourquoi ça empêchera la récurrence : [une phrase]
```
