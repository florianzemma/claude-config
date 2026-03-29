---
allowed-tools: Read, Glob, Grep, Bash(find*), Bash(git log*), Bash(git shortlog*), Bash(wc*)
description: Scanner et comprendre l'architecture d'une codebase — utile en reprise ou onboarding
---
Explore et documente cette codebase :

$ARGUMENTS

Utilise des subagents pour chaque domaine (contexte séparé) :

1. **Structure** — arborescence des dossiers, organisation des modules, entry points
2. **Stack technique** — framework, dépendances principales, versions, tooling (build, test, lint)
3. **Architecture** — patterns utilisés (MVC, clean archi, feature-based...), flux de données, couches
4. **Points d'entrée** — routes API, pages, composants racine, scripts npm/pnpm
5. **Hotspots** — fichiers les plus modifiés (`git log --name-only`), dettes techniques visibles
6. **Conventions** — naming, structure des fichiers, patterns récurrents

Produis un résumé en markdown dans EXPLORE.md avec :
- Une carte mentale textuelle de l'architecture
- Les 5 fichiers les plus importants à lire en premier
- Les anti-patterns ou dettes techniques repérés
- Les commandes utiles pour lancer / tester / builder le projet
