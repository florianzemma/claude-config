---
name: commit
description: Create a clean conventional commit with proper message format
disable-model-invocation: true
---

# Commit Workflow

Creates a conventional commit following team standards.

## Usage

```bash
/commit
```

## Process

1. **Check status**
   ```bash
   git status
   ```

2. **Review changes**
   ```bash
   git diff
   git diff --staged
   ```

3. **Stage files explicitly**
   - NEVER use `git add .` or `git add -A`
   - Add specific files by name
   ```bash
   git add path/to/file1.ts path/to/file2.ts
   ```

4. **Generate commit message**
   - Format: `type(scope): description`
   - Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`
   - Description: imperative mood, lowercase, no period
   - Body: explain WHY, not WHAT (if needed)

5. **Create commit**
   ```bash
   git commit -m "$(cat <<'EOF'
   type(scope): brief description

   Optional detailed explanation of WHY this change was made.

   - Bullet point detail 1
   - Bullet point detail 2
   EOF
   )"
   ```

6. **Verify commit**
   ```bash
   git log -1 --pretty=format:"%h %s"
   ```

## Commit Message Examples

**Feature:**
```
feat(auth): add OAuth2 Google provider

Implement Google OAuth2 authentication with session management.

- Add OAuth2 strategy configuration
- Configure session storage with Redis
- Add callback endpoint handler
```

**Fix:**
```
fix(api): prevent race condition in token refresh

Users reported intermittent auth failures. The token refresh
logic had a race condition when multiple requests triggered
refresh simultaneously.

- Add mutex lock around token refresh
- Add retry logic with exponential backoff
```

**Refactor:**
```
refactor(db): extract query builder to separate module

Improves testability and reduces duplication across repositories.
```

**Docs:**
```
docs(readme): update installation instructions for Node 20
```

## Critical Rules

- ❌ NEVER include AI attribution
- ❌ NEVER use `git add .` or `git add -A`
- ❌ NEVER commit without conventional format
- ✅ ALWAYS stage files explicitly by name
- ✅ ALWAYS run tests before committing
- ✅ ALWAYS write message in imperative mood

## Post-Commit

After committing, ask user if they want to:
1. Push to remote (`git push`)
2. Create a PR (`/pr`)
3. Continue working
