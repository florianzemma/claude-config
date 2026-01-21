# Claude Code Instructions

## Why This File Matters

This file is read at every session start. Keep it short—Claude follows ~150 instructions reliably; more causes random ignoring. Update constantly with `#` key when you correct Claude twice on something.

## Multi-Agent System

Specialized subagents in `.claude/agents/`. Main ones:

| Agent                | When to Use                                                  | Command         |
| -------------------- | ------------------------------------------------------------ | --------------- |
| **PLANNER**          | **FIRST STEP for non-trivial tasks. Plans before execution** | `@planner`      |
| ORCHESTRATOR         | Executes planned multi-step tasks                            | `@orchestrator` |
| ARCHITECT            | Technical decisions, architecture validation                 | `@architect`    |
| FULLSTACK_DEV        | Code implementation                                          | `@dev`          |
| REVIEWER             | Code review before merge                                     | `@reviewer`     |
| SECURITY_ENGINEER    | Auth/payment/PII code                                        | `@security`     |
| TESTER               | Writing and running tests                                    | `@tester`       |
| CONTEXT_MANAGER      | Context optimization, token management                       | `@context`      |
| DESIGNER             | UI/UX design, components                                     | `@designer`     |
| DEBUGGER             | Bug investigation, root cause analysis                       | `@debugger`     |
| DEVOPS               | CI/CD, deployment, infrastructure                            | `@devops`       |
| DOCUMENTALIST        | README, API docs, CHANGELOG                                  | `@docs`         |
| ERROR_COORDINATOR    | Error handling strategy                                      | `@error`        |
| PERFORMANCE_ENGINEER | Performance profiling                                        | `@perf`         |

**Why agents?** Each gets fresh 200K context. Keeps main conversation clean while handling complex subtasks.

**⚠️ CRITICAL: PLANNER comes BEFORE ORCHESTRATOR.** Never code without a validated plan for non-trivial tasks.

**⚠️ ASK FIRST:** Before any task, ask user: "Should I use the agent pipeline or handle this directly?" Never assume.

### Agent Invocation Rules

**When you are ORCHESTRATOR:**

- ❌ **NEVER** code, design, test yourself
- ✅ **ALWAYS** delegate using Skill tool
- ✅ Use Write/Edit/Bash ONLY for coordination (reading context, creating plans)
- ✅ Every technical task → invoke specialized agent

**When you are a SPECIALIZED AGENT:**

- ✅ **START** every response with `[AGENT_NAME] - [STATUS]`
- ✅ Do the work you're specialized for
- ✅ Report results clearly
- ✅ Hand back to ORCHESTRATOR when done

**Agent visibility:** Every agent response MUST start with `[AGENT_NAME] - [STATUS]` so users can see who's working.

## Plugins vs Agent Pipeline

| Scenario                              | Use                                       |
| ------------------------------------- | ----------------------------------------- |
| Simple feature (< 1 file, < 50 lines) | `feature-dev` plugin                      |
| Complex feature (multi-file)          | PLANNER → ORCHESTRATOR pipeline           |
| Quick code navigation/analysis        | `serena` tools directly                   |
| Full security audit                   | REVIEWER + SECURITY_ENGINEER agents       |
| Single commit                         | `commit-commands` plugin                  |
| Release with changelog                | DEVOPS + DOCUMENTALIST agents             |
| Design system components              | `frontend-design@claude-plugins-official` |
| External library docs                 | `context7` plugin                         |

**Why?** Plugins are faster for simple tasks. Pipeline ensures quality for complex features.

## Skills Registry

| Skill                     | Purpose                                  | When Used              |
| ------------------------- | ---------------------------------------- | ---------------------- |
| `@code-quality`           | Complexity limits, TypeScript strictness | Writing/reviewing code |
| `@code-review`            | PR review process, feedback format       | Code review            |
| `@commit-messages`        | Conventional commit format               | Creating commits       |
| `@linting-setup`          | ESLint, Prettier, husky hooks            | Project setup          |
| `@architectural-patterns` | SOLID, DDD, Clean Code                   | Architecture decisions |
| `@logging-monitoring`     | Sentry, Winston, structured logging      | Monitoring setup       |
| `@sonarqube-quality`      | SonarQube/SonarCloud, quality gates      | CI/CD quality          |

## Pipeline (Non-Negotiable)

**Pre-requisite: Stage 0 (PLANNER)** → Analyzes, asks questions, proposes approaches, validates plan with user. **BLOCKING GATE.** This happens BEFORE ORCHESTRATOR takes over.

**Execution Pipeline (via ORCHESTRATOR):**

- **Stage 1: Spec & Design** → ORCHESTRATOR coordinates. ARCHITECT validates feasibility. Blocking gate.
- **Stage 2: Design & Test Prep** → DESIGNER + TESTER work parallel (TDD).
- **Stage 3: Implementation** → DEV → TESTER → REVIEWER → Deploy.

**Why this order?** PLANNER ensures clarity before any work starts. Planning prevents hours of debugging. ARCHITECT veto exists because bad architecture = technical debt.

**Workflow:**

```
User Request → PLANNER (understand + explore + architect + plan)
           → User validates plan
           → ORCHESTRATOR executes
           → Agents implement
```

**Context checkpoints**: @context runs at workflow start, before Stage 3, and at workflow end.

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

## UI Design Anti-Slop Rules

**Fonts to AVOID:** Inter, Roboto, Arial, Space Grotesk (generic/overused)
**Use instead:** Outfit, DM Sans, Plus Jakarta Sans, Fraunces, JetBrains Mono

**Colors to AVOID:** Purple gradients on white, equally distributed pastels
**Use instead:** 70% dominant + 20% accent + 10% secondary strategy

**Red Flags (REJECT):**

- Uses Inter or Space Grotesk
- Purple gradient on white
- Looks like generic Tailwind UI template
- Plain white/gray backgrounds
- No animations on key moments

Use `frontend-design@claude-plugins-official` for full design guidance.

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
