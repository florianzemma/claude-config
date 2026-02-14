---
name: review
description: Comprehensive code review workflow using reviewer subagent
disable-model-invocation: true
---

# Code Review Workflow

Performs comprehensive code review using the reviewer subagent.

## Usage

```bash
/review [PR number or branch name]
```

## Process

1. **Fetch PR information**
   ```bash
   gh pr view <number> --json title,body,commits,files
   ```

2. **Get changed files**
   ```bash
   gh pr diff <number>
   ```

3. **Spawn reviewer subagent**
   ```
   Use the @reviewer subagent to review this PR:

   PR #<number>: <title>

   Focus on:
   - Security vulnerabilities (OWASP Top 10)
   - Logic errors and edge cases
   - Code quality issues
   - Architectural fit
   - Test coverage

   Provide prioritized feedback with specific line references.
   ```

4. **Wait for reviewer to complete**
   - Reviewer will analyze all changes
   - Check security, quality, architecture
   - Provide categorized feedback

5. **Format review feedback**
   - CRITICAL issues (must fix)
   - HIGH priority (should fix)
   - MEDIUM priority (nice to have)
   - LOW priority (optional)
   - Positive feedback (what's good)

6. **Post review to PR**
   ```bash
   gh pr review <number> --comment --body "$(cat <<'EOF'
   [Formatted review feedback]
   EOF
   )"
   ```

## Review Checklist

The reviewer subagent will check:

**Security:**
- [ ] No SQL injection vulnerabilities
- [ ] XSS prevented
- [ ] Authentication/authorization proper
- [ ] No secrets in code
- [ ] Input validation present
- [ ] Secure headers configured

**Code Quality:**
- [ ] Functions ≤ 50 lines
- [ ] Complexity ≤ 10
- [ ] No `any` in TypeScript
- [ ] Self-documenting code
- [ ] Error handling present
- [ ] Edge cases covered

**Testing:**
- [ ] Tests written for new code
- [ ] Tests actually pass
- [ ] Edge cases tested
- [ ] No skipped tests

**Architecture:**
- [ ] Follows existing patterns
- [ ] No unnecessary abstractions
- [ ] Appropriate separation of concerns
- [ ] Dependencies reasonable

## Review Comment Format

```markdown
## Code Review

### 🔴 CRITICAL Issues (Must Fix Before Merge)
[None or specific issues with file:line references]

### 🟠 HIGH Priority (Should Fix)
[None or specific issues]

### 🟡 MEDIUM Priority (Nice to Have)
[Suggestions for improvement]

### 🟢 LOW Priority / Optional
[Minor suggestions]

### ✅ What Looks Good
[Specific positive feedback]

---

**Verdict:**
- [ ] ✅ APPROVED - Ship it
- [ ] ⚠️ APPROVED WITH COMMENTS - Address HIGH priority items
- [ ] ❌ CHANGES REQUESTED - Fix CRITICAL issues
```

## Review Types

**Quick Review** (< 5 min):
```
Focus on:
- Security red flags
- Obvious bugs
- Breaking changes
```

**Standard Review** (15-30 min):
```
Focus on:
- Security (OWASP checklist)
- Logic correctness
- Code quality
- Test coverage
```

**Deep Review** (1+ hour):
```
Focus on:
- Everything in standard review
- Architecture implications
- Performance impact
- Future maintenance burden
- Documentation quality
```

## Best Practices

- ✅ Be specific with file:line references
- ✅ Explain WHY something is an issue
- ✅ Suggest concrete fixes
- ✅ Include positive feedback
- ✅ Prioritize findings (critical > high > medium > low)
- ❌ Nitpick style issues (use linter)
- ❌ Suggest rewrites without justification
- ❌ Approve without actually reviewing

## After Review

Ask user if they want to:
1. Approve the PR (`gh pr review <number> --approve`)
2. Request changes (`gh pr review <number> --request-changes`)
3. Add more comments
4. Review another PR
