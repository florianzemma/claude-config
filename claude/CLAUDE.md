# Claude Code Instructions

## Why This File Matters

This file is read at every session start. Keep it short—Claude follows ~150 instructions reliably; more causes random ignoring. Update constantly with `#` key when you correct Claude twice on something.

## Multi-Agent System

Specialized subagents in `.claude/agents/`. Main ones:

| Agent | When to Use | Command |
|-------|-------------|---------|
| **PLANNER** | **FIRST STEP for non-trivial tasks. Plans before execution** | `@planner` |
| ORCHESTRATOR | Executes planned multi-step tasks | `@orchestrator` |
| ARCHITECT | Technical decisions, architecture validation | `@architect` |
| FULLSTACK_DEV | Implementation | `@dev` |
| REVIEWER | Code review before merge | `@reviewer` |
| SECURITY_ENGINEER | Auth/payment/PII code | `@security` |
| TESTER | Writing and running tests | `@tester` |

**Why agents?** Each gets fresh 200K context. Keeps main conversation clean while handling complex subtasks.

**⚠️ CRITICAL: PLANNER comes BEFORE ORCHESTRATOR.** Never code without a validated plan for non-trivial tasks.

## 4-Stage Pipeline (Non-Negotiable)

**Stage 0: Planning** → PLANNER analyzes, asks questions, proposes approaches, validates plan with user. **BLOCKING GATE.**
**Stage 1: Spec & Design** → ORCHESTRATOR coordinates. ARCHITECT validates feasibility. Blocking gate.
**Stage 2: Design & Test Prep** → DESIGNER + TESTER work parallel (TDD).
**Stage 3: Implementation** → DEV → TESTER → REVIEWER → Deploy.

**Why this order?** PLANNER ensures clarity before any work starts. Planning prevents hours of debugging. ARCHITECT veto exists because bad architecture = technical debt.

**Workflow:**
```
User Request → PLANNER (understand + explore + architect + plan)
           → User validates plan
           → ORCHESTRATOR executes
           → Agents implement
```

## Project Classification (Prevent Over-Engineering)

ARCHITECT classifies every new project:

- **Level 1 (Simple)**: Landing pages, blogs → ESLint + Vercel only
- **Level 2 (Medium)**: SaaS, internal apps → + Sentry + 70% coverage
- **Level 3 (Complex)**: Fintech, healthtech → Full stack + 80% + E2E

**Why?** SonarQube + K8s for a landing page is over-engineering. Match tools to project size.

## Code Standards (All Levels)

- **NO COMMENTS** except rare exceptions (complex business logic, JSDoc for public APIs, temporary workarounds)
- Code MUST be self-documenting (explicit names, small functions, clear structure)
- Functions ≤ 50 lines, complexity ≤ 10 (breaks = harder to test/maintain)
- No `any` in TypeScript (caused production bugs from implicit types)
- Duplication ≤ 3% (DRY prevents bug-fixing in multiple places)
- Early returns (reduces cognitive complexity)

**Linting is mandatory.** ESLint + Prettier + husky pre-commit hooks. No exceptions.

**Comments check:** If you write a comment, ask: "Can I make the code clearer instead?" If yes → delete comment, improve code.

Detailed configs → skills: `@code-quality`, `@linting-setup`, `@architectural-patterns`

## Naming Conventions

```
Files: PascalCase.tsx (components), use-kebab-case.ts (hooks), kebab-case.ts (utils)
Variables: SCREAMING_SNAKE (constants), camelCase (functions), PascalCase (classes/types)
Commits: type(scope): description — feat, fix, docs, refactor, test, chore, perf
```

## Git Commit Conventions

**CRITICAL: NO Claude attribution in commits**

```bash
# ✅ CORRECT commit format
git commit -m "feat(auth): add OAuth2 provider

Implement Google OAuth2 authentication with session management.

- Add OAuth2 strategy
- Configure session storage
- Add callback endpoint"

# ❌ WRONG - DO NOT include these lines:
# 🤖 Generated with [Claude Code](https://claude.com/claude-code)
# Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Rules:**
- Clean, professional commit messages
- No AI/tool attribution
- Focus on what changed and why
- Follow conventional commits format

## Context Management (Critical)

Context degrades at ~30-40%, not 100%. When output quality drops:

1. **Use /clear frequently** — One conversation per feature. Don't mix auth + refactoring.
2. **External memory** — Write plans to `SCRATCHPAD.md` or `plan.md`. Read on resume.
3. **Copy-paste reset** — Copy important context, /compact, /clear, paste back essentials.

**Why?** More context after degradation makes it worse, not better.

## Prompting Tips

- **Be specific**: "Build auth" → bad. "Email/password auth, User model, Redis sessions 24h TTL, protect /api/protected" → good.
- **Say what NOT to do**: "Keep minimal. No abstractions I didn't ask for. One file if possible."
- **Give WHY**: "Needs to be fast—runs on every request" changes approach.

## Skills & Commands

Skills in `.claude/skills/` auto-apply when relevant. Progressive disclosure—only name/description loaded until needed.

Custom commands in `.claude/commands/` become `/commandname`.

## MCP Servers Available

- **filesystem**: Read/write files
- **git**: Git operations
- **postgres**: Database (if configured)

Third-party MCP servers aren't verified—review source for sensitive integrations.

## Agent Visibility Rules

Every agent response starts with: `[AGENT_NAME] - [STATUS]`
Transitions announced: `[TRANSITION] Done: @agent_out | Next: @agent_in`

---

**For detailed configs:** `.claude/agents/`, `.claude/skills/`
