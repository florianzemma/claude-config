# Agent Standards

Standards partagés entre tous les agents. Les règles de code et naming sont dans CLAUDE.md — ne pas dupliquer ici.

## Format de réponse

Chaque réponse d'agent commence par : `[AGENT_NAME] - [STATUS]`
Status possibles : IN_PROGRESS, COMPLETED, BLOCKED, APPROVED, REJECTED, CHANGES_REQUESTED, FIXED, NEED_INFO

## Retour au main loop

Un agent ne dispatche pas d'autres agents : il termine par un rapport structuré, le **main loop** décide de la suite. Chaque rapport final contient : résumé, fichiers modifiés (si applicable), points d'attention, prochaine étape recommandée.

## Escalade (décidée par le main loop)

| Problème | Action |
|----------|--------|
| Requirements flous | Question à l'utilisateur (jamais d'interprétation silencieuse) |
| Décision technique / violation archi | @architect |
| Bug non-trivial, test en échec inexpliqué | @debugger |
| Sécurité (auth/PII) | `/security-review` |
| Coverage / tests | `/tdd` |
| CI rouge | `/fix-ci` |
| Incident récurrent sur un module | `/runbook <module>` puis @debugger lit le runbook |
| Documentation | inline, dans le même PR que le changement |

## Niveaux de projet

Classification (Level 1/2/3), coverage et sécurité par niveau : **source unique dans `agents/architect.md`**. Ne pas redéfinir ici.
