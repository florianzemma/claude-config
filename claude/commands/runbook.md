---
model: opus
allowed-tools: Read, Glob, Grep, Bash(find*), Bash(ls*), Bash(cat*), Bash(git log*), Bash(git blame*)
description: Génère un runbook de troubleshooting condensé pour un module/service.
---
Génère un runbook de troubleshooting pour ce module/service :

$ARGUMENTS

Si l'argument est vide ou introuvable dans le code, demande une précision avant de générer. Ne produis jamais un runbook inventé.

Suis ces 4 étapes dans l'ordre. Ne saute aucune.

---

**Étape 1 — Cartographier le module**

Localise le module dans le code :
- `find . -type f -name "*.ts" | grep -i "<module>"` (et variantes : `.js`, `.py`, etc.)
- `Glob` sur le nom du module pour trouver les répertoires et points d'entrée
- Lis les points d'entrée identifiés (index, main, controller, service, handler)
- `git log -20 -- <module-path>` pour repérer les incidents passés (messages de commit fix/hotfix/revert)

Si aucun fichier correspondant n'est trouvé : arrête et demande une précision.

---

**Étape 2 — Extraire les modes de défaillance**

Depuis le code observé uniquement (pas de généralités) :
- Identifie les dépendances externes : bases de données, APIs, queues, fichiers de config
- Relève les appels réseau, les timeouts configurés, les retry policies
- Repère les `throw`, `catch`, les validations manquantes, les points de contention
- Classe les modes de défaillance par **fréquence probable** (pas gravité théorique) en te basant sur la fréquence des fix dans git log et la complexité du chemin de code

---

**Étape 3 — Écrire le runbook**

Écris dans `docs/runbooks/<module>.md` :

```markdown
# Runbook : <module>

> <Une phrase résumant ce que fait ce module et son rôle critique>

## Dépendances

| Service/Resource | Impact si indisponible |
|-----------------|------------------------|
| <dep>           | <impact>               |

## Symptômes → Causes → Diagnostic → Fix

### <Symptôme le plus fréquent>
**Causes probables (par fréquence) :**
1. <cause 1>
2. <cause 2>

**Diagnostic rapide :**
```bash
<commande réelle et exécutable>
```

**Fix :**
<étapes concrètes>

### <Symptôme 2>
...

## Commandes de diagnostic rapide

```bash
# <description>
<commande>

# <description>
<commande>
```

## Pièges connus

- <piège 1 issu du code ou de git log>
- <piège 2>

## Incidents passés (depuis git log)

| Date | Commit | Description |
|------|--------|-------------|
| <date> | <hash court> | <message du commit> |

## Escalade

Si le problème persiste après diagnostic : <responsable ou canal>
```

**Contraintes strictes :**
- Chaque commande de diagnostic doit être réelle et exécutable dans ce projet
- Chaque cause doit être issue du code observé, pas d'une liste générique
- Variables d'environnement : vérifiées dans `.env.example` uniquement, jamais `.env`
- Le runbook doit tenir sur une page (≤ 80 lignes)
- Aucun secret, token, ou credential dans le runbook

---

**Étape 4 — Checklist de vérification**

Avant de terminer, vérifie :
- [ ] Chaque commande bash est exécutable dans ce projet
- [ ] Chaque cause listée est traceable à une ligne de code ou un commit
- [ ] Aucune variable d'environnement lue depuis `.env` (uniquement `.env.example`)
- [ ] Le fichier tient sur une page
- [ ] Aucun secret dans le fichier

---

Ne commit pas le runbook — l'utilisateur le fait lui-même.
