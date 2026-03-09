# Claude Code Workflow Bootstrap

This repository contains a small script that initializes a structured Claude Code workflow inside an existing repository.

It creates:

.ai/
  plan.md
  tasks/
  repo-map.md
  context.md

and adds a `CLAUDE.md` workflow configuration if it doesn't exist.

## Usage

Run inside your repository:

bash init-claude-workflow.sh

Or run it on another repo:

bash init-claude-workflow.sh /path/to/repo
