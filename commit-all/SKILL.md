---
name: commit-all
description: Create a single git commit that includes all current changes (tracked, untracked, deletions) by reviewing the diff and writing an appropriate commit message. Use when the user asks to "commit all changes," "commit everything," or similar requests to stage and commit the entire working tree at once.
---

# Commit All

## Overview

Create one well-formed commit from the entire working tree by staging everything, reviewing the diff, and writing a concise message with an optional body.

## Workflow

### 1) Inspect the working tree

- Run `git status -sb` to see the scope of changes.
- If there are no changes, report that there is nothing to commit and stop.
- Review diffs to understand intent:
  - `git diff` (unstaged)
  - `git diff --staged` after staging

### 2) Stage everything

- Use `git add -A` to include tracked files, untracked files, and deletions.
- Re-check with `git status -sb` and `git diff --staged` to confirm the full change set.

### 3) Compose the commit message

- Keep the message super brief: a single subject line only, imperative mood, present tense, <= 72 chars.
- Base the subject on the dominant change (feature, fix, refactor, docs, chore).
- Only add a body if there are a TON of changes and the subject alone is insufficient; otherwise, never add a body.

### 4) Commit

- Run `git commit -m "Message"` or include a body with:
  - `git commit -m "Message" -m "Body line 1" -m "Body line 2"`
- If the diff includes sensitive data or secrets, stop and ask before committing.
