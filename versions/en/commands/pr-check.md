## PR Check

A pre-PR checklist command to verify code quality, tests, build, and common safety gates before opening a pull request.

### Usage

```bash
/pr-check [--strict]
```

### Options

- `--strict` : Enforce stricter gates (e.g., higher coverage threshold, zero audit warnings)

### Basic Examples

```bash
# Run a standard pre-PR check on the current change
/pr-check
"Please analyze the staged diff and local outputs below, list blocking issues and provide concrete fixes."

# Strict mode with higher standards
/pr-check --strict
"Apply stricter gates: require >90% coverage on changed files and no audit warnings."
```

### Claude Integration

```bash
# Provide context then invoke the command
# 1) Show current branch, staged changes, and package scripts
git branch --show-current && git status --porcelain && cat package.json

# 2) Provide recent test/build/lint outputs (paste if needed)
#    Example placeholders below; replace with your actual outputs
# --- LINT OUTPUT START ---
# ...
# --- LINT OUTPUT END ---
# --- TEST OUTPUT START ---
# ...
# --- TEST OUTPUT END ---
# --- BUILD OUTPUT START ---
# ...
# --- BUILD OUTPUT END ---

# 3) Invoke the command
/pr-check --strict
"Summarize pass/fail per gate (lint, type-check, unit, e2e optional, build, sensitive scan, audit). For each failure, provide specific fix commands or diffs."
```

### Considerations

- Prerequisites: Your project should define scripts for lint/test/build/type-check as applicable.
- Limitations: The command relies on user-provided context (outputs and diffs). Paste concise but sufficient logs.
- Recommendations: Keep PRs small. Run locally before invoking this command for faster iteration.

### Related Commands (Optional)

- `/pr-create-smart` : Draft a PR description based on your commit history and diff
- `/test-e2e-local` : Intent for standing up local E2E and validating critical flows
