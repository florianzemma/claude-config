# /review

Review de code niveau staff engineer — pragmatique et actionnab.

## Comportement

Analyser le diff ou les fichiers spécifiés selon :

1. **Bugs & correctness** — erreurs logiques, edge cases, race conditions
2. **Sécurité** — injections, auth bypass, données non validées, secrets exposés
3. **Performance** — N+1 queries, memory leaks, algorithmes sous-optimaux
4. **Maintenabilité** — lisibilité, duplication, couplage excessif
5. **Tests** — coverage suffisant, cas manquants

## Format de sortie

```
✅ Approuvé / ⚠️ Approuvé avec réserves / ❌ Refusé

### Must fix
- [problème] → [solution concrète]

### Should fix
- [problème] → [suggestion]

### Nice to have
- [amélioration optionnelle]
```

Rester concis. Prioriser les must-fix. Proposer la correction, pas juste signaler.
