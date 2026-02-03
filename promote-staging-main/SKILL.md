---
name: promote-staging-main
description: 'Create a PR from `staging` to `main` with a generated title like "Promote: feature A, feature B, feature C" by summarizing commits that are in staging but not main, using the gh CLI. Use when a user asks to merge/rollout/release/promo staging to main or open a promotion PR.'
---

# Promote Staging Main

## Overview

Raise a `staging` -> `main` PR by summarizing the unique staging commits into a concise title and opening the PR via `gh`.

## Workflow

1. Ensure you are in the target git repo and `staging`/`main` exist locally.
2. (Optional) Update local refs if you expect them to be stale (e.g., `git fetch origin`).
3. Run the script to generate the title and open the PR:

```bash
bash /Users/mbokinala/.codex/skills/promote-staging-main/scripts/promote_staging_main.sh
```

## Notes

- Title format is `Promote: <topic A>, <topic B>, <topic C>` derived by analyzing commit subjects (prefers conventional-commit scopes, otherwise frequent keywords; falls back to recent subjects).
- If there are no unique commits, the script exits without creating a PR.
- For a safe preview, run with `DRY_RUN=1` to print the title and body without creating a PR.
- If `gh` is not authenticated, run `gh auth login` and retry.

## Resources

### scripts/
- `promote_staging_main.sh`: generates the PR title and creates the PR using `gh`.
