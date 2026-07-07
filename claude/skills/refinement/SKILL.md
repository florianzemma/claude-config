---
name: refinement
description: "Refinement technique Jira — récupère les tickets en Technical Analysis assignés à l'utilisateur sur le board PI Planning, analyse la codebase si disponible, et remplit les champs Technical solution, Story point estimate et Statut Cyber-sécurité."
disable-model-invocation: true
---

# Refinement technique Jira

## Objectif

Pour chaque ticket en statut **Technical Analysis** assigné à `currentUser()` sur le board **DDP - PI Planning** (ID `161`), produire une analyse technique complète et renseigner les champs Jira correspondants.

---

## Champs Jira cibles

| Champ | ID | Type |
|---|---|---|
| Technical solution | `customfield_10652` | Textarea (string) |
| Story point estimate | `customfield_10016` | Number |
| Statut Cyber-sécurité | `customfield_10360` | Dropdown (option) |
| AI Review - Technical Score | `customfield_11279` | Number (float, échelle 0–5) |

**Valeurs connues pour Statut Cyber-sécurité :**
- `"Pas d'impact"` — feature sans nouvelle exposition de données sensibles, pas de changement d'accès
- `"Conforme (ISP / Etude impact)"` — feature traitant des données de production, actions destructives, ou exposition externe
- En cas de doute → choisir `"Conforme (ISP / Etude impact)"` par précaution

---

## Étapes d'exécution

### 1. Récupérer les tickets

```
jira_get_board_issues(
  board_id: "161",
  jql: "status = 'Technical Analysis' AND assignee = currentUser()",
  limit: 20,
  fields: "summary,description,priority,labels,components,comment,customfield_10652,customfield_10016,customfield_10360,parent"
)
```

Pour chaque ticket : lire `summary`, `description`, `comments`, `parent` (epic).

---

### 2. Identifier le projet / codebase

Pour chaque ticket, déduire à quel repo/app il appartient depuis :
- le préfixe dans le summary : `[WebConsole]`, `[BSCAN PROD]`, `[Assets]`, etc.
- la clé de l'epic parent

**Mapping connu :**

| Préfixe summary | App / Repo local |
|---|---|
| `[WebConsole]` | `/home/ext_florian_zemma_gailleton_ext_/webconsole_v2` |
| `[BSCAN PROD]` | repo séparé — demander à l'utilisateur |
| `[Assets]` | `/home/ext_florian_zemma_gailleton_ext_/webconsole_v2/apps/assets` |
| `[Exports]` | `/home/ext_florian_zemma_gailleton_ext_/webconsole_v2/apps/exports` |
| Inconnu | demander à l'utilisateur |

**Vérification de présence locale :**
```bash
ls <chemin_repo> 2>/dev/null || echo "ABSENT"
```

Si le repo **n'est pas présent localement** :
> "Le projet **[nom]** n'est pas disponible localement. Peux-tu le cloner ou me donner le chemin ? Je vais attendre avant de rédiger la solution technique."

Ne pas rédiger la solution technique tant que la codebase n'est pas accessible — sauf si le ticket est purement documentaire ou de configuration (pas de code à produire).

---

### 3. Analyser la codebase (si disponible)

Lire les fichiers pertinents pour comprendre les patterns existants :
- Structure des pages/composants pour la feature concernée
- Hooks, actions serveur, schémas Zod existants
- Client API / SDK utilisé (ex: `packages/exports-sdk`)
- Patterns de routing Next.js (`app/` ou `pages/`)
- Composants MUI réutilisables dans `packages/ui`

Ne lire que ce qui est utile au ticket — ne pas explorer tout le monorepo.

---

### 4. Rédiger l'analyse technique

Produire un texte structuré pour `customfield_10652` couvrant :

```
**Approche**
[Architecture retenue, choix techniques justifiés par la codebase existante]

**Découpage**
- T1 (X SP) : [tâche]
- T2 (Y SP) : ...

**Points bloquants**
- [Question à trancher avant le sprint]

**Risques**
| Risque | Impact | Mitigation |
```

Garder le texte factuel et court. Éviter de recopier les critères d'acceptation.

---

### 5. Évaluer la Cyber-sécurité

Appliquer la grille suivante :

| Critère | Valeur |
|---|---|
| Affiche ou manipule des données de production (colis, compteurs, users) | Conforme (ISP / Etude impact) |
| Comporte une action destructive (suppression, archivage) | Conforme (ISP / Etude impact) |
| Expose une interface à des utilisateurs externes ou partenaires | Conforme (ISP / Etude impact) |
| Feature purement interne, read-only, pas de nouvelle surface d'attaque | Pas d'impact |
| Documentation, configuration statique sans runtime sensible | Pas d'impact |

---

### 6. Scorer la solution (AI Review - Technical Score)

Note sur 5 (float) évaluant la qualité de la solution technique rédigée.

| Score | Critères |
|---|---|
| **5** | Solution complète, architecture justifiée, découpage précis, questions bloquantes identifiées, codebase analysée |
| **4** | Solution solide, quelques questions ouvertes mineures ou codebase partiellement disponible |
| **3.5** | Solution fonctionnelle mais codebase indisponible ou estimation conditionnelle sur questions majeures |
| **3** | Solution incomplète, manque de détails techniques ou dépendances non clarifiées |
| **< 3** | Solution insuffisante — ne pas valider, relancer l'analyse |

Pénaliser si : codebase non consultée pour un ticket de code, questions bloquantes non identifiées, découpage absent, estimation non justifiée.

---

### 7. Estimer en Story Points

Utiliser la suite de Fibonacci : 1, 2, 3, 5, 8, 13, 21.

Calibration :
- **1 SP** — changement de config, ajout d'un champ simple
- **2 SP** — nouveau composant simple sans logique métier
- **3 SP** — page avec appel API et état local
- **5 SP** — feature avec plusieurs composants, pagination, état complexe
- **8 SP** — feature multi-composants avec interactions, actions serveur, cas d'erreurs
- **13 SP** — feature nécessitant back + front + tests E2E
- **21 SP** — trop large, décomposer

Mentionner explicitement si l'estimation dépend d'une question bloquante (ex: "5 SP sans 'Try it out', 8 SP si inclus").

---

### 8. Mettre à jour le ticket Jira

```
jira_update_issue(
  issue_key: "DDP-XXXXX",
  fields: {
    "customfield_10652": "<texte solution technique>",
    "customfield_10016": <nombre>,
    "customfield_10360": { "value": "<valeur>" },
    "customfield_11279": <score 0-5>
  }
)
```


---

## Règles importantes

- **Ne jamais inventer une solution sans avoir lu la codebase** pour les tickets qui impliquent du code. Demander le pull si absent.
- Ne pas chiffrer avant d'avoir identifié les questions bloquantes — les lister explicitement et donner une fourchette si nécessaire.
- Traiter les tickets **un par un** : présenter l'analyse à l'utilisateur avant de mettre à jour Jira, pour validation.
- Respecter les patterns du projet existant — ne pas proposer de stack différente sans justification.
- Ne pas modifier des champs déjà remplis sans en informer l'utilisateur.
