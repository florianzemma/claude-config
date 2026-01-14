---
name: commit-messages
description: Generate commit messages following conventional commits format. Use when creating commits, helping with commit messages, or reviewing commit history.
---

# Commit Message Format

All commits follow conventional commits. Why? Enables automatic changelog generation and makes git history searchable.

## Format

```
type(scope): description

[optional body]

[optional footer]
```

## Types

- **feat**: New feature for the user
- **fix**: Bug fix for the user
- **docs**: Documentation only changes
- **style**: Formatting, missing semicolons (no code change)
- **refactor**: Code change that neither fixes nor adds
- **test**: Adding or updating tests
- **chore**: Updating build tasks, dependencies
- **perf**: Performance improvement

## Rules

- Description under 50 characters
- Use imperative mood: "add feature" not "added feature"
- No period at the end
- Scope is optional but helpful for large codebases

## Examples

```
feat(auth): add password reset flow
fix(cart): resolve quantity update race condition
refactor(api): extract validation middleware
docs(readme): update installation instructions
test(user): add edge cases for email validation
chore(deps): upgrade React to v19
perf(query): add index for user lookups
```

## Breaking Changes

Add `!` after type or `BREAKING CHANGE:` in footer:

```
feat(api)!: change authentication response format

BREAKING CHANGE: auth endpoint now returns JWT instead of session cookie
```
