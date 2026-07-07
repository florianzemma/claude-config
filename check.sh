#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

FAIL=0
err() { echo "FAIL: $*"; FAIL=1; }

# 1. settings.json est un JSON valide
python3 -m json.tool claude/settings.json >/dev/null 2>&1 || err "claude/settings.json : JSON invalide"

# 2. chaque hook est du bash syntaxiquement valide
python3 - <<'EOF' || FAIL=1
import json, subprocess, sys, tempfile, os
ok = True
cfg = json.load(open("claude/settings.json"))
for event, groups in cfg.get("hooks", {}).items():
    for g in groups:
        for h in g.get("hooks", []):
            cmd = h.get("command", "")
            with tempfile.NamedTemporaryFile("w", suffix=".sh", delete=False) as f:
                f.write(cmd)
                path = f.name
            r = subprocess.run(["bash", "-n", path], capture_output=True, text=True)
            os.unlink(path)
            if r.returncode != 0:
                print(f"FAIL: hook {event} : bash invalide — {r.stderr.strip()}")
                ok = False
sys.exit(0 if ok else 1)
EOF

# 3. aucun marqueur de conflit git
CONFLICTS=$(grep -rn '^<<<<<<< \|^>>>>>>> ' claude/ README.md 2>/dev/null || true)
[ -n "$CONFLICTS" ] && err "marqueur de conflit git : $CONFLICTS"

# 4. modèles : alias uniquement, jamais de snapshot daté
BAD_MODELS=$(grep -rn '^model:' claude/ | grep -vE 'model: (opus|sonnet|haiku|fable|inherit)$' || true)
[ -n "$BAD_MODELS" ] && err "modèle non-alias (utiliser opus/sonnet/haiku) : $BAD_MODELS"

# 5. champs frontmatter invalides
BAD_FIELDS=$(grep -rn '^max_turns:' claude/agents/ 2>/dev/null || true)
[ -n "$BAD_FIELDS" ] && err "max_turns n'existe pas (utiliser maxTurns) : $BAD_FIELDS"

# 6. références mortes ou obsolètes connues
DEAD=$(grep -rniE 'serena|superpowers|ERROR_REPORT|mcp__mcp-atlassian|claude-(opus|sonnet|haiku|fable)-[0-9]' claude/ README.md 2>/dev/null || true)
[ -n "$DEAD" ] && err "référence morte/obsolète : $DEAD"

# 7. chaque @agent référencé dans CLAUDE.md / AGENT_STANDARDS.md existe
for a in $(grep -rhoE '@[a-z][a-z-]+' claude/CLAUDE.md claude/AGENT_STANDARDS.md | sort -u | tr -d '@'); do
  [ -f "claude/agents/$a.md" ] || err "agent @$a référencé mais claude/agents/$a.md absent"
done

# 8. chaque `/command` listée dans CLAUDE.md existe
for c in $(grep -oE '`/[a-z][a-z-]+`' claude/CLAUDE.md | tr -d '\`/' | sort -u); do
  [ -f "claude/commands/$c.md" ] || err "command /$c listée dans CLAUDE.md mais claude/commands/$c.md absent"
done

# 9. chaque skill listée dans CLAUDE.md existe
for s in $(grep -oE '`(verify|retro|brainstorming|code-review|code-quality|db-migration|commit-messages|pr-desc|release-notes|refinement)`' claude/CLAUDE.md | tr -d '\`' | sort -u); do
  [ -d "claude/skills/$s" ] || err "skill $s listée dans CLAUDE.md mais claude/skills/$s/ absent"
done

if [ "$FAIL" = "0" ]; then
  echo "OK — config valide"
else
  exit 1
fi
