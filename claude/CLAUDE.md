# Claude Code Instructions

## Core Workflow

**Default: Single Session** - Most tasks don't need agents (90% of cases)

**When to use @planner (complex features):**
- New features requiring design thinking
- Multiple possible approaches to evaluate
- Need creative brainstorming (uses superpowers plugin)
- Complex requirements to break down

**When to use Plan Mode (`/plan`):**
- Quick codebase exploration (read-only)
- Understand existing code before modifying

**When to spawn subagents (max 3):**
- Codebase investigation (verbose output)
- Code review or security audit
- Parallel research tasks

**Recovery:**
- `Esc Esc` or `/rewind` to restore previous state
- `/clear` between unrelated tasks
- `claude --continue` to resume last session

## Development Workflow

**Recommended phases:**
1. **Explore** (`/plan`) - Read files, understand codebase
2. **Plan** - Create approach, `Ctrl+G` to edit plan
3. **Implement** (Normal mode) - Auto-accept edits for speed
4. **Verify** - Run tests, check output
5. **Commit** - Clean commit message, conventional format

## Build & Test Commands

```bash
# Install dependencies
npm install

# Build
npm run build

# Test
npm test                    # Run all tests
npm test -- <file>          # Run specific test

# Lint
npm run lint
npm run lint:fix

# Type check
npm run typecheck
```

## Git Workflow

**Commits:**
- Use conventional commits: `type(scope): description`
- Types: feat, fix, docs, refactor, test, chore, perf
- NO AI attribution in commits

**Branches:**
- Feature: `feature/description`
- Fix: `fix/description`
- Hotfix: `hotfix/description`

## Code Standards

**Keep it simple:**
- Functions ≤ 50 lines
- Complexity ≤ 10
- No `any` in TypeScript
- Early returns, self-documenting code
- Minimal comments (code should be clear)

**Testing:**
- Write tests alongside code (TDD)
- Run tests before committing
- Fix failing tests immediately

## Project-Specific Rules

**Architecture:**
- Agents in `.claude/agents/` (max 3 subagents)
- Skills in `.claude/skills/` for reusable workflows
- See `AGENT_STANDARDS.md` for shared patterns

**Plugins enabled:**
- `serena` - Semantic code navigation
- `context7` - Library documentation
- `feature-dev` - Simple features
- `commit-commands` - Git workflows
- `frontend-design` - UI components
- `github` - PR/issue management

**Available subagents:**
- `@planner` - Planning + brainstorming (uses superpowers)
- `@investigator` - Codebase research
- `@reviewer` - Code review + quality
- `@security` - Security audit (OWASP/NIST)
- `@architect` - Architecture decisions

**Available skills:**
- `/commit` - Create conventional commit
- `/pr` - Open pull request
- `/review` - Code review workflow

## Context Management

**Auto-compaction:** When context fills, preserve:
- Modified files list
- Test commands run
- Architectural decisions made

**Use subagents to keep main context clean:**
```
"Use a subagent to investigate how authentication works"
"Use a subagent to review this PR for security issues"
```

## Verification

**Always provide verification so I can check my own work:**
- Include test cases with expected outputs
- Provide screenshots for UI changes
- Specify success criteria upfront

## Continuous Improvement

**Self-correction loop:**
When I make the same mistake twice, you'll add it here as a one-line rule.

**Current rules:**
- NEVER use `git add .` or `git add -A` - add files explicitly
- NEVER skip running tests after implementation
- NEVER commit without conventional format
- NEVER include AI attribution in commits

---

**Keep this file under 150 lines.** If longer, Claude starts ignoring instructions.

For detailed agent configs: `.claude/agents/`
For reusable workflows: `.claude/skills/`
