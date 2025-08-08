# Team Project Full Workflow Guide

From pulling the repo to merging the PR – a practical, end‑to‑end workflow with Claude Code and this Cookbook.

## Workflow Overview

```mermaid
flowchart LR
    A[1. Pull] --> B[2. Analyze]
    B --> C[3. Plan/Tasks]
    C --> D[4. Branch]
    D --> E[5. Implement]
    E --> F[6. Local Tests]
    F --> G[7. Review]
    G --> H[8. PR]
    H --> I[9. CI]
    I --> J[10. Merge]
```

---

## 1) Pull & Initialize

```bash
# Clone or update
git clone https://github.com/team/project.git
cd project
# or
git fetch origin && git pull origin main
```

Project context (official): keep a concise root‑level Claude.md as the single entry. Optionally keep rich docs under docs/context and link to them from Claude.md.

Safety: add .env, .claude/secrets/, *.key to .gitignore.

---

## 2) Let Claude Analyze the Project

- /analyze-dependencies to map structure and hotspots
- /tech-debt for risks and improvements
- /explain-code <path> for focused understanding

---

## 3) Task Planning

- /spec to generate requirements/design/tasks skeletons
- Prioritize tasks (must/should/could) and estimate time ranges

---

## 4) Create a Feature Branch

```bash
git checkout -b feature/meaningful-name
# or fix/login-bug-#123
```

---

## 5) Implement (Claude Assisted)

- Ask for implementation details; follow project style.
- Commit in small, semantic steps using /semantic-commit.

---

## 6) Local Tests

- Unit tests: npm/yarn/pytest etc.
- E2E: /test-e2e-local (starts app, runs E2E, cleans up)
- Coverage: aim >= 80% (or your team threshold)

---

## 7) Pre‑PR Checks & Review

- /pr-check for lint/type/test/build/audit/sensitive scan gates
- /smart-review for code quality and security

---

## 8) Create the PR

```bash
git push origin feature/...
/pr-create-smart  # drafts a high‑quality PR body
```

Add labels/reviewers; link Issues.

---

## 9) CI/CD & Deploy Readiness

- /check-github-ci to track CI
- /deploy-check --env staging --smoke-url ... to validate readiness

---

## 10) Address Feedback & Merge

- /pr-feedback to process reviews
- Merge after all gates pass

---

## Security Checklist

- No secrets in diffs/logs
- Inputs validated; use parameterized queries
- Audit dependencies; mitigate findings

---

## Command Quick Reference

- /pr-check — Pre‑PR quality/safety checklist
- /pr-create-smart — Draft PR description from commits/diff
- /test-e2e-local — Local E2E harness
- /deploy-check — Pre‑deploy readiness checklist
- /check-github-ci — Track CI runs

---

## Best Practices

- Small, frequent commits; short‑lived branches
- Keep Claude.md concise; link to deep docs
- Automate logs/artifacts used by /pr-check and /deploy-check

