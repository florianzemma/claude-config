---
allowed-tools: Bash(gh issue*), Bash(gh pr*), Bash(git*), Read, Glob, Grep, Edit, Write
description: Résout une issue GitHub de bout en bout — lecture, plan, implémentation, PR liée
---
Implémente l'issue GitHub numéro $ARGUMENTS.

Suis ce pipeline strict :

1. **Lecture** — `gh issue view $ARGUMENTS` pour comprendre l'issue, les labels, les commentaires.

2. **Exploration** — lis les fichiers concernés. Utilise un subagent si la codebase est large.

3. **Plan** — écris un plan dans PLAN.md (objectif, fichiers impactés, phases, critères de succès). N'implémente rien avant que le plan soit clair.

4. **Implémentation** — code phase par phase. Chaque phase doit être testable indépendamment.

5. **Tests** — lance les tests existants. Si un test échoue, fixe-le avant de continuer.

6. **PR** — crée la PR avec :
   - Titre : résumé concis de la fix
   - Corps : `Closes #$ARGUMENTS` + description du changement
   - Branche : `fix/issue-$ARGUMENTS` ou `feat/issue-$ARGUMENTS` selon le type

Si l'issue est ambiguë, arrête-toi après l'étape 1 et pose une question précise avant de continuer.
