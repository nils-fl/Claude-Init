# Claude Code Workflow Bootstrap

This repository contains a small script that initializes a **structured Claude Code workflow** inside any repository.

The workflow introduces a small `.ai` workspace that helps make AI-assisted development:

* more structured
* easier to follow
* less token intensive

Instead of letting an AI agent run long autonomous loops, development is broken into **plan → tasks → implementation → review**.

---

# What the script creates

Running the script sets up the following structure:

```
.ai/
  plan.md
  tasks/
  repo-map.md
  context.md
```

Purpose of the files:

* **plan.md** – high level feature planning
* **tasks/** – individual implementation tasks
* **repo-map.md** – lightweight overview of the repository structure
* **context.md** – project knowledge Claude can reuse

The script also creates or updates **CLAUDE.md**, which Claude Code automatically reads as project instructions.

---

# Usage

Run the script inside a repository:

```bash
bash init-claude-workflow.sh
```

Or run it on another repo:

```bash
bash init-claude-workflow.sh /path/to/repo
```

---

# Recommended Git setup

Usually you want to commit:

```
CLAUDE.md
.ai/repo-map.md
```

And ignore the dynamic planning files:

```
.ai/plan.md
.ai/tasks/
.ai/context.md
```

---

# Zsh Helper (optional)

To make the script available in any repo, copy it to a global location:

```bash
mkdir -p ~/bin
cp init-claude-workflow.sh ~/bin/init-claude-workflow.sh
chmod +x ~/bin/init-claude-workflow.sh
```

Then add this to your `~/.zshrc`:

```bash
claude_init_repo() {
  bash ~/bin/init-claude-workflow.sh "${1:-.}"
}
```

Reload your shell:

```bash
source ~/.zshrc
```

Now you can initialize a repository with:

```bash
claude_init_repo
```

---

# Example workflow

Start Claude Code:

```bash
claude
```

Then ask Claude to create a plan:

```
Create an implementation plan and tasks for adding OAuth login.
```

Claude will generate:

```
.ai/plan.md
.ai/tasks/01-auth-service.md
.ai/tasks/02-oauth-provider.md
```

Then implement tasks one by one:

```
Implement .ai/tasks/01-auth-service.md
```

This keeps development **structured and predictable** while avoiding long agent loops.
