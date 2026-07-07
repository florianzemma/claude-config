---
name: db-migration
description: Safe database schema migration rules (Prisma/PostgreSQL, applicable to any SQL database). Use PROACTIVELY whenever editing schema.prisma, creating or reviewing a migration file, altering tables/columns/indexes, or planning any schema change that must deploy without downtime or data loss.
---

# DB Migration — sans downtime, sans perte

## Non négociable

- JAMAIS `prisma migrate reset` ni `prisma db push` sur une base contenant des données réelles.
- Toujours **lire le SQL généré** (`migration.sql`) avant d'appliquer — un renommage Prisma génère un DROP + CREATE par défaut (perte de données).
- Plan de rollback écrit **avant** d'appliquer, pas après l'incident.

## Pattern expand → migrate → contract

1. **Expand** — changements additifs uniquement : nouvelle colonne nullable (ou avec DEFAULT), nouvelle table, nouvel index. Déployable avant le code.
2. **Migrate** — backfill des données **en batches** (jamais un UPDATE global qui lock la table) ; le code écrit dans l'ancien ET le nouveau champ pendant la transition.
3. **Contract** — suppression de l'ancien champ seulement quand plus aucun code ne le lit : grep sur tout le codebase + un cycle de déploiement complet écoulé.

## Checklist avant d'appliquer

```
□ SQL généré lu et compris (pas de DROP inattendu)
□ Nouvelle colonne NOT NULL → avec DEFAULT, sinon nullable puis backfill puis contrainte
□ Index sur table volumineuse → CREATE INDEX CONCURRENTLY (hors transaction)
□ Renommage → expand/contract, jamais RENAME direct si l'ancien code tourne encore
□ Ordre de déploiement explicite : migration avant code (additif) / code avant migration (contract)
□ Backfill en batches, idempotent, reprenable
□ Rollback documenté et testable
□ Migration testée sur une copie/staging avant prod
```

## Review d'une migration existante

Vérifie dans cet ordre : perte de données possible ? lock de table long ? compatible avec le code encore déployé pendant le rollout ? rollback réel (pas juste `migrate down` théorique) ?
