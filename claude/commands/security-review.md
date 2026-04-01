---
allowed-tools: Read, Glob, Grep, Bash(git diff*), Bash(git log*)
description: Audit sécurité OWASP Top 10 sur le code modifié — sévérité + fix concret
model: claude-opus-4-5
---
Fais un audit de sécurité OWASP Top 10 sur les changements en cours :

$ARGUMENTS

Analyse `git diff HEAD~1` ou les fichiers spécifiés. Pour chaque catégorie OWASP :

1. **A01 Broken Access Control** — routes non protégées, IDOR, privilege escalation
2. **A02 Cryptographic Failures** — secrets hardcodés, algos faibles, données sensibles non chiffrées
3. **A03 Injection** — SQL injection, NoSQL injection, command injection, XSS
4. **A04 Insecure Design** — logique métier contournable, rate limiting absent
5. **A05 Security Misconfiguration** — CORS trop permissif, headers manquants, debug en prod
6. **A06 Vulnerable Components** — dépendances avec CVE connues
7. **A07 Auth Failures** — sessions mal gérées, tokens faibles, brute force possible
8. **A08 Integrity Failures** — désérialisation non sécurisée, supply chain
9. **A09 Logging Failures** — données sensibles loggées, audit trail absent
10. **A10 SSRF** — requêtes vers URLs contrôlées par l'utilisateur

Format par finding :
```
[CRITIQUE|ÉLEVÉ|MOYEN|FAIBLE] Catégorie OWASP
Fichier: path/to/file.ts:ligne
Problème: description précise
Fix: code corrigé ou étapes concrètes
```

Ne rapporter que les findings réels. Zéro faux positif.
