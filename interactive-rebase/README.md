# Interactive rebase skill
Guides a clean, safe interactive rebase to squash, reorder, and reword commits. You choose the base branch and the agent does the rest.

## Installation

```sh
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
    --repo mbokinala/agent-skills --path interactive-rebase
```

## Usage

You can invoke the skill directly by entering the following:

```
$interactive-rebase
```

Or, ask Codex something along the lines of "clean up the commit history" or "prepare this branch for merge" or "interactively rebase"