# My agent skills

This repo is a collection of AI coding agent [skills](https://agentskills.io/home) (mostly used [with codex](https://developers.openai.com/codex/skills)).


## Installation

### Codex

If you have Codex already installed, run the following command to install a particular skill:

```sh
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
    --repo mbokinala/agent-skills --path <skill_name>
```

For example:
```sh
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
    --repo mbokinala/agent-skills --path interactive-rebase
```