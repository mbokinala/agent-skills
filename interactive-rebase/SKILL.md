---
name: interactive-rebase
description: Guided interactive git rebase to clean up a branch's commit history by squashing WIP commits, rewording messages, and dropping noise. Use when the user asks to interactively rebase a branch, clean up commit history, or prepare a branch for merging by consolidating and clarifying commits.
---

# Interactive Rebase

## Workflow

0. Plan for permission escalation.
Most commands in this workflow will require permission escalation. Ask for approval before running Git commands that modify history or the working tree. Use the escalation flow for any command that is blocked by sandboxing.

1. Gather context and confirm safety.
Use `git rev-parse --abbrev-ref HEAD` to confirm the current branch. Ask for the parent branch to rebase onto (for example `main`, `master`, `staging`, `develop`). Ask whether the branch has been pushed or shared and warn that history will change. Ensure the working tree is clean with `git status -sb`; if dirty, ask the user to stash or commit before proceeding.

2. Review commits and diffs.
List commits on the branch with `git log --oneline --decorate <parent>..HEAD`. Inspect each commit with `git show --stat <sha>` and use `git show <sha>` when deeper inspection is needed.

3. Propose a rebase plan.
Identify likely WIP commits, such as messages containing `wip`, `tmp`, `debug`, `fix`, `lint`, `format`, `typo`, `oops`, `cleanup`, `chore`, or `test`. Suggest squashing consecutive commits that touch the same feature or files and represent incremental progress. Avoid squashing unrelated features or semantic boundaries (for example refactors vs behavior changes). Prefer `fixup` for tiny follow-ups and `squash` when the message should be combined or edited. Propose concise, descriptive commit messages in imperative mood.

4. Execute the rebase only after explicit confirmation.
If fixup commits exist, prefer `git rebase -i --autosquash <parent>`. Otherwise use `git rebase -i <parent>`. If the branch contains merge commits and the user wants to preserve them, use `git rebase -i --rebase-merges <parent>`. In the editor, change `pick` to `reword`, `squash`, or `fixup` per the plan and rewrite messages as needed. If conflicts occur, resolve them, then run `git add -A` and `git rebase --continue`. If the rebase should be abandoned, run `git rebase --abort`.

5. Validate and finalize.
Verify the new history with `git log --oneline --decorate <parent>..HEAD`. Ensure content is unchanged with `git diff <parent>...HEAD`. If the branch was previously pushed, remind the user to use `git push --force-with-lease`.

## Commit Message Guidelines

- Use imperative mood: "Add", "Fix", "Refactor", "Remove".
- Keep messages concise and specific; include scope only when helpful.
- Prefer one logical change per commit after squashing.

## Decision Points

- Ask for the parent branch to rebase onto.
- Ask whether the branch is shared or pushed and whether force-push is acceptable.
- Ask for confirmation before running `git rebase -i`.
