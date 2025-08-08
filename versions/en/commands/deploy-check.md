## Deploy Check

A pre-deployment intent to verify that a release candidate is safe and ready for the target environment.

### Usage

```bash
/deploy-check [--env <staging|production|custom>] [--smoke-url <url>] [--migrations] [--strict]
```

### Options

- `--env <staging|production|custom>` : Target environment (affects required checks)
- `--smoke-url <url>` : Health/smoke endpoint to verify after deploy (if available)
- `--migrations` : Include DB migration readiness checks (dry-run/plans)
- `--strict` : Enforce stricter gates (0 vulnerabilities, no TODO/FIXME, coverage threshold, etc.)
- `--template` : Output a standard Markdown checklist template for CI artifacts or manual review

### Basic Examples

```bash
# Output a standard checklist template (for CI artifacts or local copy)
/deploy-check --template
"Print a markdown checklist I can copy into the deployment ticket."
```

```bash
# Staging pre-deploy gate
/deploy-check --env staging --smoke-url https://staging.example.com/health
"Use the context below (build/test outputs, audit results, env vars) to validate readiness and list blockers with fixes."

# Production pre-deploy with migrations
/deploy-check --env production --migrations --strict
"Assume minimal downtime requirement. Validate rollback strategy and config drift as well."
```

### Claude Integration

```bash
# 1) Provide branch and cleanliness
 git branch --show-current && git status --porcelain

# 2) Provide latest main sync status (paste result)
 git fetch origin && git rev-parse --short HEAD && git rev-parse --short origin/main && git log --oneline -5

# 3) Provide test/lint/type/build/audit outputs (paste concise logs)
# --- LINT OUTPUT START ---
# ...
# --- TEST OUTPUT START ---
# ...
# --- BUILD OUTPUT START ---
# ...
# --- AUDIT OUTPUT START ---
# ...

# 4) Provide runtime env overview (redact secrets)
# Required envs for target env (example)
# API_URL=...
# DATABASE_URL=...
# SECRET_KEY=...

# 5) If migrations requested, paste migration plan/dry-run
# --- MIGRATION PLAN START ---
# ...
# --- MIGRATION PLAN END ---

# 6) Optional: current infra/config summary (IaC drift, image tags, replicas)
# --- INFRA SUMMARY START ---
# ...
# --- INFRA SUMMARY END ---

# 7) Invoke
/deploy-check --env production --migrations --strict
"Produce a PASS/FAIL checklist. For each failed gate, provide concrete remediation steps/commands. Include risk assessment, rollback plan, and post-deploy smoke steps (curl <url> / verify logs)."
```

### What This Command Does (Mechanism)

This is an intent-definition command. It does not execute deployment; instead it:
- Consolidates pre-deploy gates into a single checklist (branch, cleanliness, sync with main, tests, build, audit, required envs, migration readiness, config/infrastructure drift, smoke readiness)
- Uses user-provided context (logs, diffs, env summaries) to judge PASS/FAIL
- Outputs:
  - A clear checklist with PASS/FAIL per gate
  - Exact remediation steps (commands/config changes) for FAILED items
  - A minimal post-deploy smoke plan and a rollback path

### Template (Output Example)

```
# Deploy Readiness Checklist

- [ ] Branch clean (no uncommitted changes)
- [ ] In sync with main (HEAD == origin/main or justified)
- [ ] Lint passed
- [ ] Type-check passed (if applicable)
- [ ] Unit tests passed
- [ ] E2E tests passed (or scoped justification)
- [ ] Build succeeded
- [ ] Security audit: 0 critical/high (list mitigations if any)
- [ ] Required env vars present: API_URL, DATABASE_URL, SECRET_KEY
- [ ] Migrations reviewed (plan dry-run attached)
- [ ] Infra/config drift checked (IaC, image tags, replicas)
- [ ] Rollback plan documented
- [ ] Post-deploy smoke: curl <SMOKE_URL> and log verification
```

### Considerations

- Prerequisites: Project should define standard scripts (lint/test/build). Security/audit tools should be available in your stack.
- Limitations: Safety gates depend on the accuracy of pasted logs and environment summaries.
- Recommendations: Automate producing the context via CI artifacts; for production, require explicit human confirmation for any risky action.

### Related Commands (Optional)

- `/pr-check` : Pre-PR quality gates
- `/test-e2e-local` : Local E2E validation
- `/check-github-ci` : Track CI status
