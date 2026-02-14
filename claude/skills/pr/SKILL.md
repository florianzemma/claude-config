---
name: pr
description: Create a pull request with comprehensive description
disable-model-invocation: true
---

# Pull Request Workflow

Creates a pull request with proper title, description, and context.

## Usage

```bash
/pr
```

## Prerequisites

- Changes committed on a feature branch
- Tests passing
- Branch pushed to remote

## Process

1. **Check current state**
   ```bash
   git status
   git log origin/main..HEAD --oneline
   ```

2. **Ensure branch is pushed**
   ```bash
   git push -u origin $(git branch --show-current)
   ```

3. **Analyze all changes since divergence**
   ```bash
   git diff origin/main...HEAD
   git log origin/main..HEAD
   ```

4. **Generate PR title** (< 70 chars)
   - Format: `type(scope): brief description`
   - Same conventions as commit messages
   - Use description/body for details, not title

5. **Generate PR description**
   ```markdown
   ## Summary
   [2-3 sentence overview of what changed and why]

   ## Changes
   - [Specific change 1]
   - [Specific change 2]
   - [Specific change 3]

   ## Test Plan
   - [ ] Unit tests pass (`npm test`)
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   - [ ] [Specific scenario tested]

   ## Screenshots (if UI changes)
   [Include before/after screenshots]

   ## Related Issues
   Closes #123
   Relates to #456
   ```

6. **Create PR using gh CLI**
   ```bash
   gh pr create --title "pr title" --body "$(cat <<'EOF'
   [Generated PR description]
   EOF
   )"
   ```

7. **Output PR URL**
   ```bash
   gh pr view --web
   ```

## PR Title Examples

**Good:**
```
feat(auth): add Google OAuth2 provider
fix(api): resolve race condition in token refresh
refactor(db): extract query builder module
```

**Bad (too long):**
```
feat(auth): add Google OAuth2 provider with session management and Redis storage
```
(Use description for details)

## PR Description Template

```markdown
## Summary
[What changed and why - be specific about the problem solved]

## Changes
- Specific technical change 1
- Specific technical change 2
- Breaking changes (if any)

## Test Plan
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Manual testing: [describe scenario]
- [ ] Edge cases tested: [list]

## Performance Impact
[Any performance considerations or improvements]

## Security Considerations
[Any security implications or improvements]

## Migration Steps (if needed)
[Steps for deploying this change]

## Screenshots
[If UI changes]

## Related Issues
Closes #XXX
```

## Best Practices

- ✅ Reference specific commits if PR contains multiple logical changes
- ✅ Include screenshots for UI changes
- ✅ Mention breaking changes prominently
- ✅ Link related issues/PRs
- ✅ Provide test instructions
- ❌ Create PRs with >500 lines changed (split into multiple PRs)
- ❌ Include unrelated changes
- ❌ Leave TODO comments without tracking issues

## Post-PR Creation

Ask user if they want to:
1. Request specific reviewers
2. Add labels
3. Link to project board
4. Enable auto-merge (if tests pass)
