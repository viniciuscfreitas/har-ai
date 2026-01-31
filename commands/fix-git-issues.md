# Fix Git Issues

Fix Git problems efficiently. Most Git issues come from over-complicating workflows. Prefer simple commands over complex operations.

## Common Simple Fixes

- **Stuck in merge**: `git merge --abort` then `git pull` or rebase properly
- **Wrong commit**: `git reset --soft HEAD~1` to uncommit but keep changes
- **Lost changes**: `git reflog` to find lost commits, then `git checkout <hash>`
- **Branch mess**: Delete and recreate from clean base

For complex conflicts, ask if the branching strategy needs fixing instead.

## Prevention First

Better to prevent Git issues with:
- Small, frequent commits
- Clear branch naming
- Communication before big merges

Report what was fixed in 1-2 sentences.
