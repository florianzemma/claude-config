---
name: code-review
description: Apply team code review standards when reviewing PRs or suggesting improvements. Use when reviewing code, discussing best practices, or providing feedback on implementation.
model: opus
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

## Step 0 — Context before reviewing

Before reading any code, gather context that shapes the review:

1. **Check the linked Jira ticket** (if the MR references one — look in the MR title or description):
   ```
   Use mcp__atlassian__jira_get_issue with the ticket key (e.g. DDP-13847)
   ```
   Read the **description**, **acceptance criteria**, and **comments**. This tells you:
   - What was the intended scope (pages only? features too? data migration?)
   - What decisions were already made upstream (no need to re-open them)
   - Which behaviours are intentional vs accidental

2. **Read the MR description** for context the ticket may not cover.

3. **Cross-reference code changes against ticket scope.** A change that looks like a regression may be intentional. Conversely, something not in scope might have snuck in. Flag mismatches as questions, not hard blockers.

> If no ticket is found or the MCP tool is unavailable, proceed with the review but note the missing context.

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

## Posting Inline Comments on GitLab MRs

When the user asks to post review comments directly on a GitLab MR (`/code-review --comment` or "fait les commentaires sur la MR"), use this method.

### 1. Get MR metadata

```bash
glab api "projects/<PROJECT>/merge_requests/<IID>" | python3 -c "
import sys,json; d=json.load(sys.stdin); refs=d['diff_refs']
print('base:', refs['base_sha'])
print('head:', refs['head_sha'])
print('start:', refs['start_sha'])
"
```

### 2. Find exact line numbers in the new file

**Never use diff line offsets.** Always fetch the real file at HEAD to get the exact line number:

```bash
HEAD="<head_sha>"
glab api "projects/<PROJECT>/repository/files/<URL_ENCODED_PATH>/raw?ref=${HEAD}" | grep -n "<pattern>"
```

URL-encode the path: `/` → `%2F`, `(` → `%28`, `)` → `%29`.

### 3. Post inline comment via JSON (required — `-f` flags don't work for nested objects)

```bash
BASE="<base_sha>"
HEAD="<head_sha>"

python3 -c "
import json
print(json.dumps({
  'body': 'comment text here',
  'position': {
    'position_type': 'text',
    'base_sha': '${BASE}',
    'head_sha': '${HEAD}',
    'start_sha': '${BASE}',
    'old_path': 'path/to/file.ts',
    'new_path': 'path/to/file.ts',
    'new_line': 42
  }
}))
" | glab api "projects/<PROJECT>/merge_requests/<IID>/discussions" \
  -X POST \
  -H "Content-Type: application/json" \
  --input - | python3 -c "
import sys,json
d=json.load(sys.stdin)
pos=d.get('notes',[{}])[0].get('position') or {}
print(f'line={pos.get(\"new_line\")} file={pos.get(\"new_path\",\"?\")}')
"
```

### Key rules

- **Only changed lines can be commented** — context lines (unchanged) return `400 Bad request - line_code can't be blank`. Find the nearest changed line (`+` in the diff) to anchor the comment.
- **`old_path` and `new_path` must both be set** even for same-name files.
- **`-f` flags for nested objects silently drop position** — always use `--input -` with JSON and `-H "Content-Type: application/json"`.
- **Verify positioning**: check `new_line` in the response — if it's `None`, the position was rejected and the comment became a general MR comment.
