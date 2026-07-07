---
name: pr-desc
description: Generate a PR description from the current branch diff. Use when the user asks for a PR description, PR summary, or wants to prepare a pull request.
---

# PR Description Generator

Generate a PR description from `git diff dev...HEAD` (or the relevant base branch).

## Steps

1. Run `git log <base>..HEAD --oneline` to list commits
2. Run `git diff <base>...HEAD` to read all changes
3. Write the description following the format below

## Format

```
## Summary

- <bullet: what changed and why, one idea per line>
- <bullet>
- <bullet>

## Test plan

- [ ] <what to verify manually or in tests>
- [ ] <edge case or regression check>
```

## Rules

- No tables, ever
- No headers other than `## Summary` and `## Test plan`
- Bullets in Summary describe *what* changed and *why*, not file names
- Keep each bullet to one line — if it needs two, split into two bullets
- Test plan items are checkboxes, written as things a reviewer can verify
- Language matches the repo's convention (French if the project uses French labels, English otherwise)
- Do not mention file names or line counts unless it's the only way to convey the change
- Do not add a "Files changed" section
