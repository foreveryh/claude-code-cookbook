## Test E2E Local

Spin up a local E2E environment to validate critical user flows before pushing.

### Usage

```bash
/test-e2e-local [--headless]
```

### Options

- `--headless` : Run the browser tests in headless mode (if supported by your runner)

### Basic Examples

```bash
# Start local app and run E2E
/test-e2e-local
"Use the project's standard start:test and test:e2e scripts. Ensure cleanup even on failure."

# Headless mode
/test-e2e-local --headless
"Prefer headless browser mode if available."
```

### Claude Integration

```bash
# Provide scripts and env as context
cat package.json | jq '.scripts'

# Optionally paste your .env.test (redact secrets)
# --- ENV TEST START ---
# ...
# --- ENV TEST END ---

# Invoke
/test-e2e-local
"Plan: (1) start test server, (2) wait for readiness, (3) run e2e, (4) collect artifacts, (5) shutdown. Provide fallback instructions if scripts differ."
```

### Considerations

- Prerequisites: Project defines `start:test` and `test:e2e` (or document alternatives in the prompt).
- Limitations: Local flakiness can differ from CI; capture artifacts for debugging.
- Recommendations: Keep tests deterministic, add health checks, ensure proper teardown.

### Related Commands (Optional)

- `/pr-check` : Pre-PR quality gates
- `/pr-create-smart` : Draft PR body from changes
