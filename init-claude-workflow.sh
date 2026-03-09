#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash init-claude-workflow.sh
#   bash init-claude-workflow.sh /path/to/repo
#
# Safe behavior:
# - creates .ai structure if missing
# - appends workflow section to CLAUDE.md only if not already present
# - does not overwrite existing files unless you edit them manually

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR"

if [ ! -d .git ]; then
  echo "[WARN] No .git directory found in: $PWD"
  echo "[INFO] Continuing anyway."
fi

mkdir -p .ai/tasks .ai/tasks-done

ensure_file() {
  local file="$1"
  local content="$2"

  if [ ! -f "$file" ]; then
    printf "%s\n" "$content" > "$file"
    echo "[OK] Created $file"
  else
    echo "[SKIP] Exists: $file"
  fi
}

ensure_contains() {
  local file="$1"
  local marker="$2"
  local content="$3"

  if [ ! -f "$file" ]; then
    printf "%s\n" "$content" > "$file"
    echo "[OK] Created $file"
    return
  fi

  if grep -Fq "$marker" "$file"; then
    echo "[SKIP] Marker already present in $file"
  else
    printf "\n\n%s\n" "$content" >> "$file"
    echo "[OK] Appended workflow section to $file"
  fi
}

PLAN_MD_CONTENT='# Implementation Plan

## Goal

## Tasks

## Progress

## Notes
'

CONTEXT_MD_CONTENT='# Project Context

## Architecture Notes

## Conventions

## Commands

## Known Constraints
'

REPO_MAP_MD_CONTENT='# Repository Map

## Backend

## Frontend

## Database

## Tests

## Commands
- test:
- lint:
- typecheck:
'

CLAUDE_WORKFLOW_SECTION='## Claude Code Workflow

You are orchestrating a small AI development team.

### Planner
- Analyze the repository and create an implementation plan.
- Write the plan to `.ai/plan.md`.
- Break work into task files in `.ai/tasks/`.
- **Crucial:** Name task files with a timestamp prefix format `YYYYMMDD-HHMM-` (e.g., `YYYYMMDD-HHMM-setup-db.md`) to avoid numbering collisions.
- Do not implement code during planning.

### Coder
- Implement exactly one task at a time.
- Modify only files required for the current task.
- Avoid re-scanning the entire repository unless necessary.

### Tester
- Run the relevant verification steps:
  - tests
  - lint
  - type checks
- Report failures clearly.

### Reviewer
- Review the diff and improve correctness and code quality.

### Workflow
1. Planner writes `.ai/plan.md`
2. Planner creates `.ai/tasks/YYYYMMDD-HHMM-*.md`
3. Coder implements ONE task
4. Tester verifies
5. Reviewer checks changes
6. Move completed tasks from `.ai/tasks/` to `.ai/tasks-done/`
7. Stop after each task

Never execute the entire feature in a single loop.

### Repository Context
- Use `.ai/repo-map.md` as the primary reference for project structure.
- Avoid scanning the entire repository unless needed.
- If new files or modules are added, update `.ai/repo-map.md`.
'

CLAUDE_NEW_FILE_CONTENT='# Project Instructions

Add project-specific coding conventions, architecture rules, and important commands here.

## Development Commands

Run tests:

Run linter:

Run type checks:

'"$CLAUDE_WORKFLOW_SECTION"

ensure_file ".ai/plan.md" "$PLAN_MD_CONTENT"
ensure_file ".ai/context.md" "$CONTEXT_MD_CONTENT"
ensure_file ".ai/repo-map.md" "$REPO_MAP_MD_CONTENT"

ensure_contains "CLAUDE.md" "## Claude Code Workflow" "$CLAUDE_WORKFLOW_SECTION"

# If CLAUDE.md was just created by ensure_contains, it only contains the workflow section.
# Upgrade it to a better starter template if it has no Project Instructions header.
if ! grep -Fq "# Project Instructions" "CLAUDE.md"; then
  tmp_file="$(mktemp)"
  {
    printf "%s\n" "$CLAUDE_NEW_FILE_CONTENT"
  } > "$tmp_file"
  mv "$tmp_file" "CLAUDE.md"
  echo "[OK] Replaced bare CLAUDE.md with starter template"
fi

if [ ! -f .gitignore ]; then
  cat > .gitignore <<'EOF'
.ai/plan.md
.ai/tasks/
.ai/tasks-done/
.ai/context.md
EOF
  echo "[OK] Created .gitignore"
else
  for pattern in ".ai/plan.md" ".ai/tasks/" ".ai/tasks-done/" ".ai/context.md"; do
    if ! grep -Fq "$pattern" .gitignore; then
      printf "%s\n" "$pattern" >> .gitignore
      echo "[OK] Added $pattern to .gitignore"
    else
      echo "[SKIP] .gitignore already contains $pattern"
    fi
  done
fi

echo
echo "[DONE] Claude workflow initialized in: $PWD"
echo
echo "Next steps:"
echo "1. Fill in CLAUDE.md project-specific instructions"
echo "2. Fill in .ai/repo-map.md"
echo "3. Start Claude C
