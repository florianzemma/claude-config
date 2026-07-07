---
allowed-tools: Bash(git log*), Bash(git config*), Bash(date*), mcp__atlassian__jira_add_worklog, mcp__atlassian__jira_get_worklog, mcp__atlassian__jira_get_issue
description: Logue 8h sur les tickets DDP des commits du jour, pondéré par nb de commits, via Jira
disable-model-invocation: true
model: sonnet
---
Crée les worklogs Jira du jour à partir des commits poussés aujourd'hui.

$ARGUMENTS

## 1. Collecte des commits du jour

1. `git config user.email` → email de l'auteur.
2. `date +%Y-%m-%d` → date du jour (`TODAY`).
3. Récupérer les commits de l'auteur datés d'aujourd'hui, toutes branches :
   ```
   git log --all --author="<email>" --since="<TODAY> 00:00" --until="<TODAY> 23:59" --pretty=format:"%H%x09%s"
   ```
   (« poussé aujourd'hui » est approximé par « committé aujourd'hui par l'auteur » — git ne stocke pas la date de push.)
4. Extraire les références ticket `DDP-\d+` dans chaque sujet de commit. Un commit peut référencer plusieurs tickets. Un commit sans `DDP-…` est ignoré (le mentionner dans le récap).
5. Compter le nombre de commits par ticket.

## 2. Arrêt si rien à loguer

Si aucun ticket DDP n'est trouvé → **ne rien loguer**, afficher « Aucun ticket DDP dans les commits du jour, rien à loguer » et s'arrêter.

## 3. Répartition des 8h (480 min)

- Total = 480 minutes.
- Poids = nombre de commits par ticket.
- `brut_i = 480 * commits_i / total_commits`.
- Arrondir chaque ticket au multiple de 15 min le plus proche.
- Ajuster pour que la somme = 480 : le reste (positif ou négatif) va au **ticket avec le plus de commits** (en cas d'égalité, le premier par ordre alphabétique de clé).
- Aucun ticket ne doit recevoir 0 min : s'il y a plus de tickets que de tranches de 15 min disponibles, donner 15 min minimum à chacun et réduire d'autant le plus gros.

## 4. Confirmation AVANT écriture

Afficher un tableau récap **et demander validation explicite** avant de créer quoi que ce soit :

| Ticket | Commits | Temps | Date |
|--------|---------|-------|------|

Format du temps pour l'API : `Xh` ou `Xh Ym` (ex. `2h 30m`).

## 5. Création des worklogs

Pour chaque ticket, après validation :
- `mcp__atlassian__jira_add_worklog` avec :
  - `issue_key` = la clé DDP
  - `time_spent` = temps calculé
  - `started` = `TODAY` (date du jour)
  - `comment` = liste courte des sujets de commits du ticket
- En cas d'erreur sur un ticket, continuer les autres et le signaler.

## 6. Récap final

- Total logué (doit faire 8h).
- Tickets traités + temps + statut (OK / erreur).
- Commits ignorés (sans DDP), le cas échéant.

## Règles
- Ne jamais loguer plus de 8h au total.
- Ne jamais écrire de worklog sans la confirmation de l'étape 4.
- Si un ticket DDP n'existe pas dans Jira (`jira_get_issue` échoue), le signaler et ne pas tenter le worklog.
