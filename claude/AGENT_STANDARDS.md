# Agent Standards & Shared Patterns

**Purpose:** Common patterns and standards used across all agents to reduce duplication.

## Agent Response Format

**ALL agents must start each response with:**
```
[AGENT_NAME] - [STATUS]
```

**Example:**
```
[DESIGNER] - [IN_PROGRESS]
[ARCHITECT] - [REVIEWING]
[REVIEWER] - [APPROVED]
```

**Why?** Provides visibility to users about which agent is working and current status.

## MCP Tools Priority (Serena Plugin)

When Serena plugin is available, prefer semantic tools over manual file operations:

| Serena Tool | Purpose | Replaces |
|-------------|---------|----------|
| `get_symbols_overview` | Get file structure without reading entire file | Read (full file) |
| `find_symbol` | Navigate to specific code | Grep + Read |
| `find_referencing_symbols` | Impact analysis | Manual search |
| `search_for_pattern` | Flexible regex search | Multiple Grep calls |

**Token Savings:** 50-70% compared to reading full files

**When to use:**
- Exploring large codebases
- Finding function/class definitions
- Analyzing dependencies
- Impact assessment

## Communication Between Agents

### Handoff Protocol

When completing work and handing off to another agent:

```
[AGENT_NAME] - [HANDOFF]

✅ Completed: [brief summary]

@next_agent Here's what you need to know:
- Context: [key information]
- Files modified: [list]
- Next steps: [what needs to be done]

I remain available for clarifications.
```

### Escalation Protocol

| Issue Type | Escalate To | When |
|------------|-------------|------|
| Plan deviations | @planner | Significant changes from original plan |
| Architecture concerns | @architect | Pattern violations, over-engineering |
| Security vulnerabilities | @security | Auth, payment, PII handling |
| Performance issues | @perf | Bottlenecks, slow queries |
| Test failures | @tester | Coverage issues, failing tests |

## Code Quality Standards (All Agents)

**Mandatory across all agents:**

### Complexity Limits
- Functions ≤ 50 lines (ideal ≤ 30)
- Cyclomatic complexity ≤ 10
- Cognitive complexity ≤ 15
- Nesting depth ≤ 4 levels
- Max 4 parameters per function

### TypeScript Strictness
- No `any` (use `unknown` or specific types)
- Explicit types on public functions
- Strict mode enabled
- Strict null checks

### Code Style
- **NO comments** except: JSDoc for public APIs, complex business logic, browser workarounds
- Self-documenting code (clear names, small functions)
- Early returns (reduce nesting)
- No `==` (use `===`)
- No dead code

### Quality Metrics
- Duplication < 3%
- Test coverage ≥ 80% (Level 2+)
- No console.log in production

## Documentation Standards

### When to Document

| Document Type | When Required | Format |
|---------------|---------------|--------|
| ADR (Architecture Decision Record) | Major architectural decisions | `docs/adrs/YYYY-MM-DD-topic.md` |
| README | New project, major feature | Markdown |
| API Docs | Public APIs | OpenAPI/JSDoc |
| CHANGELOG | Before release | Keep a Changelog format |
| Plan | Non-trivial features | `docs/plans/YYYY-MM-DD-topic.md` |

### Documentation Principles
- Update docs WITH code changes (not after)
- Keep README current (setup, usage, deployment)
- Document "why", not "what" (code shows what)
- Include examples for public APIs

## Testing Standards

### Test Types by Level

**Level 1 (Simple):**
- Unit tests optional
- Manual testing acceptable

**Level 2 (Medium):**
- Unit tests required (≥70% coverage)
- Integration tests for critical paths
- E2E tests for main flows

**Level 3 (Complex):**
- Unit tests required (≥80% coverage)
- Integration tests comprehensive
- E2E tests for all user flows
- Performance tests

### Test Best Practices
- Write tests BEFORE or WITH code (TDD)
- Test behavior, not implementation
- Use descriptive test names
- No skipped/commented tests in main branch

## Error Handling Standards

### Error Categories

| Category | HTTP Code | Log Level | Sentry | User Message |
|----------|-----------|-----------|--------|--------------|
| Validation | 400 | info | No | Specific field error |
| Auth | 401/403 | warn | No | Generic auth error |
| Not Found | 404 | info | No | Resource not found |
| Business Logic | 400/409 | warn | Yes | Business-friendly message |
| System Error | 500 | error | Yes | Generic error message |

### Error Handling Pattern

```typescript
// ✅ Good: Structured error handling
try {
  await riskyOperation();
} catch (error) {
  logger.error('Operation failed', {
    error,
    context: { userId, requestId }
  });
  Sentry.captureException(error, {
    tags: { operation: 'riskyOperation' },
    user: { id: userId }
  });
  throw new BusinessError('Operation failed', { cause: error });
}
```

## Logging Standards

### Log Levels

| Level | When to Use | Examples |
|-------|-------------|----------|
| error | System failures, exceptions | Database down, API timeout |
| warn | Degraded state, recoverable errors | Slow query, deprecated API |
| info | Business events, milestones | User login, order placed |
| debug | Development details | Variable values, flow tracking |

### Structured Logging

```typescript
// ✅ Good: Structured with context
logger.info('User logged in', {
  userId: user.id,
  email: user.email,
  requestId,
  ip: req.ip
});

// ❌ Bad: Unstructured string
console.log(`User ${user.email} logged in`);
```

### What NOT to Log
- Passwords, tokens, API keys
- Credit card numbers, SSN, PII
- Complete error stack traces in production
- Sensitive business data

## Performance Guidelines

### Database
- Use indexes on frequently queried fields
- Avoid N+1 queries (use joins or batch loading)
- Implement pagination (limit + offset or cursor-based)
- Connection pooling enabled

### Frontend
- Images: WebP with fallbacks, lazy loading
- Code splitting: Route-based chunks
- CSS: Critical CSS inline, defer non-critical
- Fonts: Preload, font-display: swap

### Caching Strategy

| Layer | Tool | TTL | Use Case |
|-------|------|-----|----------|
| CDN | Cloudflare | 1 hour | Static assets |
| Application | Redis | 5-60 min | API responses, sessions |
| Database | Query cache | 1-5 min | Frequent reads |
| Browser | Cache-Control | 1 day | Images, fonts |

## Security Checklist

**Check before every deployment:**

```
□ No hardcoded secrets (use env variables)
□ Input validation on all endpoints
□ SQL injection protected (parameterized queries)
□ XSS protection (sanitize user input)
□ CSRF tokens on state-changing operations
□ Authentication on protected routes
□ Authorization checks before data access
□ Secure headers (CSP, HSTS, X-Frame-Options)
□ Rate limiting on public endpoints
□ HTTPS enforced in production
□ Dependencies updated (no high/critical CVEs)
```

## Git & Version Control

### Commit Message Format

```
type(scope): brief description

Detailed explanation of changes (if needed).

- Bullet point 1
- Bullet point 2
```

**Types:** feat, fix, docs, refactor, test, chore, perf

### Branch Strategy

| Branch Type | Format | Purpose |
|-------------|--------|---------|
| Main | `main` | Production-ready code |
| Feature | `feature/short-description` | New features |
| Fix | `fix/short-description` | Bug fixes |
| Hotfix | `hotfix/short-description` | Production emergencies |

### Pull Request Guidelines
- Link to issue/task
- Describe what and why
- Include screenshots for UI changes
- Self-review before requesting review
- All CI checks passing
- No merge conflicts

---

**Agents should reference this document instead of duplicating these patterns in individual agent files.**
