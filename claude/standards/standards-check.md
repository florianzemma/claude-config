# Standard Validation Report

Tout agent doit inclure ce rapport à la fin de chaque tâche significative pour garantir l'application automatique des standards.

## 📋 Rapport de Conformité

| Standard               | Statut | Commentaire                                    |
| ---------------------- | ------ | ---------------------------------------------- |
| **Auto-documentation** | ✅/❌  | Pas de commentaires superflus, noms explicites |
| **Complexité (≤ 10)**  | ✅/❌  | Vérifié via ESLint ou review manuelle          |
| **Longueur (≤ 50 l.)** | ✅/❌  | Fonctions courtes et focalisées                |
| **TypeScript Strict**  | ✅/❌  | Pas de `any`, types explicites                 |
| **Tests / QA**         | ✅/❌  | Tests unitaires ajoutés ou mis à jour          |
| **Sécurité (OWASP)**   | ✅/❌  | Pas de secrets, inputs validés                 |

## ⚖️ Gate Protocol (Orchestrator)

L'Orchestrateur DOIT refuser toute livraison si :

1. Le rapport de conformité est manquant.
2. Un item critique est marqué ❌ sans justification exceptionnelle validée par l'ARCHITECT.
3. Le code contient des commentaires interdits (sauf exceptions documentées).
