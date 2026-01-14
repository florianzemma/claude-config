---
name: code-review
description: Apply team code review standards when reviewing PRs or suggesting improvements. Use when reviewing code, discussing best practices, or providing feedback on implementation.
---

# Code Review Standards

## Output Format

Structure all reviews as:

```yaml
praise:
  - What's done well (encourage good patterns)

concerns:
  - Potential issues that need discussion

must_fix:
  - Blocking issues that must be resolved before merge

nice_to_have:
  - Improvements that could be made but aren't blocking
```

## Review Checklist

### Security (BLOCKING)
- [ ] No hardcoded credentials or secrets
- [ ] Input validation on all user inputs
- [ ] No SQL injection vectors
- [ ] No XSS vulnerabilities
- [ ] Auth/authz checks in place

### Code Quality (BLOCKING if severe)
- [ ] Functions ≤ 50 lines
- [ ] Complexity ≤ 10
- [ ] No `any` types in TypeScript
- [ ] No obvious code duplication

### Testing
- [ ] Tests cover happy path
- [ ] Tests cover edge cases
- [ ] Tests cover error cases
- [ ] Coverage meets project threshold

### Documentation
- [ ] Complex logic has comments explaining WHY
- [ ] Public APIs have JSDoc/docstrings
- [ ] README updated if needed

## Review Tone

- Be specific: "Line 42: this could be simplified" > "code is messy"
- Explain why: "This creates a race condition because..."
- Offer alternatives: "Consider using X instead because..."
- Acknowledge good work: "Nice use of early returns here"

## When to Block

- Security vulnerabilities
- Obvious bugs
- Missing tests for critical paths
- Breaking changes without migration plan

## When NOT to Block

- Style preferences (that's what linters are for)
- Minor improvements
- "I would have done it differently"
