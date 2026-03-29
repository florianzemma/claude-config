Agent de nettoyage — Vérifie l'état général du projet et combat l'entropie.

$ARGUMENTS

Utilise des subagents pour chaque vérification (contexte séparé, rapporte juste les résultats) :

1. Code mort — fonctions non appelées, imports inutilisés, variables déclarées mais jamais lues
2. TODO/FIXME/HACK — liste-les tous avec fichier et ligne
3. Dépendances — packages dans package.json qui ne sont pas importés dans le code
4. Duplications — logique similaire copiée à plusieurs endroits
5. Cohérence — fichiers qui ne suivent pas les conventions de naming du projet

Rapport priorisé : critique (casse potentielle) → important (dette technique) → suggestion (nice to have).
Ne corrige rien sans validation.
