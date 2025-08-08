## PR Create Smart

Draft a high-quality PR description from your commit history and diff, including goals, changes, tests, and links to issues.

### Repository Guard (Recommended)

Before running any git commands, check that you're inside a Git repository. If not, skip PR steps and instruct the user instead of trying to auto-initialize a repo.

```bash
# Guard: skip when not inside a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a Git repository. Skipping PR creation steps."
  echo "Initialize Git (git init) in the correct project, add a remote, and commit changes before running /pr-create-smart."
  exit 0
fi
```

### Usage

```bash
/pr-create-smart [--assignees <users>] [--labels <labels>]
```

### Options

- `--assignees <users>` : Comma-separated GitHub usernames to assign
- `--labels <labels>` : Comma-separated labels to add (e.g., enhancement,needs-review)

### Basic Examples

```bash
# Create a PR description draft for the current branch
/pr-create-smart
"Use the following metadata to prepare a PR body: commit log since origin/main and summary of diff stats."

# With initial metadata
/pr-create-smart --assignees @me --labels enhancement
"Prepare a concise PR body with: Goals, Changes, Tests, Screenshots (optional), Related Issues."
```

### Claude Integration

```bash
# Provide diff stats and commits as context
changes=$(git diff --stat origin/main..HEAD)
commits=$(git log origin/main..HEAD --oneline)

# Invoke the command
/pr-create-smart --labels enhancement
"Generate a PR body with:
- Goals (why)
- Changes (what)
- Tests (how verified)
- Risk/Mitigations
- Checklist
- Related Issues (parse #123 style references if present)
Use bullet lists, keep under ~400-600 words."
```

### Considerations

- Prerequisites: `git` history should be clean; squash local WIP commits if needed before drafting.
- Limitations: This command drafts text; you still create the PR via your usual flow (gh/GUI).
- Recommendations: Keep scope small; include screenshots for UI changes.

### Related Commands (Optional)

- `/pr-check` : Pre-PR quality and safety checklist
- `/pr-review` : Review flow and feedback handling
