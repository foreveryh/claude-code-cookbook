# Complete Reference

> **Navigation:** [Previous: Contributing](91-contributing.md) | [Documentation Index](README.md)

## Overview

This document provides a complete reference for all commands, tools, options, and configurations in Claude Code Cookbook. Use this as a quick lookup guide for specific functionality.

## Table of Contents

- [Commands Reference](#commands-reference)
- [Roles Reference](#roles-reference)
- [Maintenance Tools Reference](#maintenance-tools-reference)
- [Configuration Reference](#configuration-reference)
- [File Structure Reference](#file-structure-reference)
- [Environment Variables](#environment-variables)
- [Hook System Reference](#hook-system-reference)

## Commands Reference

### Code Analysis Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/explain-code` | Explain selected code | Select code, then use command |
| `/analyze-dependencies` | Analyze project dependencies | Run in project root |
| `/analyze-performance` | Performance analysis | Analyze code or system performance |
| `/check-fact` | Verify information against codebase | Ask questions about project |

### Development Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/refactor` | Safe code refactoring | Select code to refactor |
| `/fix-error` | Fix errors intelligently | Paste error message |
| `/design-patterns` | Apply design patterns | Describe your use case |
| `/plan` | Implementation planning | Describe feature to implement |

### Git and PR Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/pr-create-smart` | Create intelligent PR descriptions | Run after making changes |
| `/pr-review` | Systematic PR review | Provide PR link or diff |
| `/pr-auto-update` | Update PR descriptions/labels | Run on existing PR |
| `/pr-feedback` | Handle PR review comments | Paste review comments |
| `/pr-issue` | List open issues | Run in repository |
| `/pr-list` | List open PRs | Run in repository |
| `/pr-check` | Pre-PR quality check | Run before creating PR |
| `/semantic-commit` | Generate commit messages | Run after staging changes |

### Documentation Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/update-doc-string` | Update code documentation | Select function/class |
| `/update-dart-doc` | Update Dart documentation | For Dart/Flutter projects |

### Project Management Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/task` | Task management | Create/manage tasks |
| `/spec` | Specification management | Create/manage specs |
| `/show-plan` | Display implementation plans | Show current plans |

### Utility Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/screenshot` | Analyze screenshots | Upload image |
| `/search-gemini` | Search with Gemini | Search query |
| `/context7` | Context management | Manage conversation context |
| `/ultrathink` | Deep thinking mode | Complex problem solving |

### Advanced Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/multi-role` | Multiple expert analysis | Specify roles and topic |
| `/role-debate` | Expert role debates | Specify roles and topic |
| `/sequential-thinking` | Step-by-step analysis | Complex reasoning tasks |
| `/smart-review` | Intelligent code review | Comprehensive code analysis |
| `/style-ai-writting` | AI writing style guide | Improve writing style |

### Specialized Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| `/update-flutter-deps` | Update Flutter dependencies | Flutter projects |
| `/update-node-deps` | Update Node.js dependencies | Node.js projects |
| `/update-rust-deps` | Update Rust dependencies | Rust projects |
| `/tech-debt` | Technical debt analysis | Analyze code quality |
| `/deploy-check` | Pre-deployment checklist | Before deployment |
| `/test-e2e-local` | Local E2E testing | Test critical flows |

## Roles Reference

### Technical Roles

| Role | Command | Expertise |
|------|---------|-----------|
| **Architect** | `/role architect` | System design, architecture patterns, scalability |
| **Performance** | `/role performance` | Optimization, profiling, performance analysis |
| **Security** | `/role security` | Security analysis, vulnerabilities, best practices |
| **Frontend** | `/role frontend` | UI/UX, frontend frameworks, user experience |
| **Mobile** | `/role mobile` | Mobile development, iOS/Android, cross-platform |

### Process Roles

| Role | Command | Expertise |
|------|---------|-----------|
| **Reviewer** | `/role reviewer` | Code review, quality assurance, best practices |
| **QA** | `/role qa` | Testing strategies, quality assurance, test automation |
| **Analyzer** | `/role analyzer` | Data analysis, system analysis, problem diagnosis |

### Role Usage Patterns

```bash
# Switch to specific role
/role architect

# Ask role-specific questions
"How should I design this microservice architecture?"

# Return to general mode
/role

# Get role help
/role-help

# Multi-role analysis
/multi-role "security,performance" "Review this API design"

# Role debate
/role-debate "architect vs performance" "Should we use microservices?"
```

## Maintenance Tools Reference

### Workflow Manager (`workflow-manager.sh`)

#### Commands
```bash
./utils/workflow-manager.sh [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `interactive` | Interactive menu mode |
| `sync` | Full synchronization workflow |
| `translate LANG` | Translation workflow |
| `release VERSION` | Release workflow |
| `maintenance` | Maintenance workflow |
| `status` | Project status overview |

#### Options
| Option | Description |
|--------|-------------|
| `--dry-run` | Preview mode, no changes |
| `--force` | Skip confirmation prompts |

### Upstream Sync (`sync-upstream.sh`)

#### Commands
```bash
./utils/sync-upstream.sh [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `check` | Check for upstream changes |
| `sync` | Synchronize with upstream |
| `help` | Show help information |

#### Options
| Option | Description |
|--------|-------------|
| `--dry-run` | Preview changes only |
| `--force` | Force sync even if no changes |
| `--lang LANG` | Sync specific language only |

### Translation Manager (`translate-content.py`)

#### Commands
```bash
python3 utils/translate-content.py [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `scan` | Scan for translation needs |
| `translate` | Translate specific language |
| `validate` | Validate completeness |
| `status` | Show translation status |

#### Options
| Option | Description |
|--------|-------------|
| `--lang LANG` | Target language (zh, ja, fr, ko) |
| `--project-root PATH` | Project root directory |

### Release Manager (`release-manager.sh`)

#### Commands
```bash
./utils/release-manager.sh [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `validate` | Validate release readiness |
| `prepare VERSION` | Prepare release |
| `package VERSION` | Create release package |
| `publish VERSION` | Publish release |
| `stats` | Show statistics |

#### Options
| Option | Description |
|--------|-------------|
| `--dry-run` | Preview actions |
| `--force` | Skip validation checks |
| `--message MSG` | Custom release message |

### Auto Maintenance (`auto-maintenance.sh`)

#### Commands
```bash
./utils/auto-maintenance.sh [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `run` | Run automatic maintenance |
| `check` | Check for updates only |
| `force` | Force sync regardless of risk |
| `status` | Show project status |
| `cleanup` | Clean up old backups |

#### Options
| Option | Description |
|--------|-------------|
| `--dry-run` | Preview mode |
| `--quiet` | Suppress non-essential output |
| `--email EMAIL` | Set notification email |

### Structure Cleanup (`cleanup-structure.sh`)

#### Commands
```bash
./utils/cleanup-structure.sh [COMMAND] [OPTIONS]
```

| Command | Description |
|---------|-------------|
| `analyze` | Analyze current structure |
| `cleanup` | Clean up redundant files |
| `organize` | Organize documentation |
| `sync` | Sync core files |
| `validate` | Validate structure |
| `full` | Complete cleanup |
| `integrate` | Integration with sync tools |

#### Options
| Option | Description |
|--------|-------------|
| `--dry-run` | Preview changes |
| `--force` | Skip confirmation prompts |

## Configuration Reference

### settings.json Structure

```json
{
  "cleanupPeriodDays": 30,
  "env": {
    "BASH_DEFAULT_TIMEOUT_MS": "600000",
    "BASH_MAX_TIMEOUT_MS": "600000",
    "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "true",
    "CLAUDE_LANGUAGE": "en",
    "SHELL": "/opt/homebrew/bin/zsh"
  },
  "includeCoAuthoredBy": false,
  "permissions": {
    "allow": ["Bash(*)", "Edit(**)", "Read(**)"],
    "deny": ["Bash(rm -rf /)", "Bash(sudo*)"]
  },
  "hooks": {
    "PreToolUse": [],
    "PostToolUse": [],
    "UserPromptSubmit": [],
    "Notification": [],
    "Stop": []
  }
}
```

### Permission System

#### Allow Patterns
| Pattern | Description |
|---------|-------------|
| `Bash(*)` | All bash commands |
| `Edit(**)` | All file editing |
| `Read(**)` | All file reading |
| `Glob(**)` | File globbing |
| `Grep(**)` | Text searching |

#### Deny Patterns
| Pattern | Description |
|---------|-------------|
| `Bash(rm -rf /)` | Dangerous deletions |
| `Bash(sudo*)` | Privilege escalation |
| `Bash(format*)` | Disk formatting |
| `Bash(dd*)` | Low-level disk operations |

### Environment Variables

#### Core Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_LANGUAGE` | UI language | `en` |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | Maintain working directory | `true` |
| `BASH_DEFAULT_TIMEOUT_MS` | Default timeout | `600000` |
| `BASH_MAX_TIMEOUT_MS` | Maximum timeout | `600000` |

#### Model Configuration
| Variable | Description | Example |
|----------|-------------|---------|
| `PPINFRA_API_KEY` | PPINFRA API key | `your_key_here` |
| `PPINFRA_MODEL` | Model selection | `qwen/qwen3-235b-a22b-thinking-2507` |
| `GEMINI_API_KEY` | Gemini API key | `your_key_here` |
| `DEFAULT_MODEL` | Default model | `ppinfra` |

## File Structure Reference

### Project Structure
```
claude-code-cookbook/
├── versions/                 # Language versions
│   ├── en/                  # English version
│   ├── zh/                  # Chinese version
│   ├── ja/                  # Japanese version
│   ├── fr/                  # French version
│   └── ko/                  # Korean version
├── utils/                   # Maintenance tools
├── scripts/                 # Root scripts
├── commands/                # Root commands
├── agents/                  # Root agents
├── docs/                    # Documentation
├── install.sh               # Installation script
└── daily-maintenance.sh     # Quick maintenance
```

### Version Structure
```
versions/[lang]/
├── commands/                # Command definitions
├── agents/roles/            # Role definitions
├── scripts/                 # Automation scripts
├── hooks/                   # Workflow hooks
├── Claude.md                # Main instructions
└── .mcp.json               # MCP configuration
```

### Installation Structure
```
~/.claude/
├── commands/                # Active commands
├── agents/roles/            # Active roles
├── scripts/                 # Active scripts
├── hooks/                   # Active hooks
├── settings.json            # Configuration
├── Claude.md                # Instructions
└── .env                    # Environment
```

## Hook System Reference

### Hook Types

#### PreToolUse Hooks
Execute before Claude uses tools.

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash(git commit*)",
      "hooks": [
        {
          "type": "command",
          "command": "~/.claude/scripts/check-ai-commit.sh"
        }
      ]
    }
  ]
}
```

#### PostToolUse Hooks
Execute after Claude uses tools.

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [
        {
          "type": "command",
          "command": "~/.claude/scripts/auto-comment.sh"
        }
      ]
    }
  ]
}
```

#### UserPromptSubmit Hooks
Execute when user submits prompts.

```json
{
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "python3 ~/.claude/hooks/UserPromptSubmit/append_ultrathink.py"
        }
      ]
    }
  ]
}
```

#### Notification Hooks
Execute for user notifications.

```json
{
  "Notification": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "osascript -e 'display notification \"Waiting for confirmation\" with title \"Claude Code\"'"
        }
      ]
    }
  ]
}
```

#### Stop Hooks
Execute when tasks complete.

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "~/.claude/scripts/check-continue.sh"
        }
      ]
    }
  ]
}
```

### Hook Matchers

| Matcher | Description |
|---------|-------------|
| `*` | Match all tools |
| `Bash` | Match bash commands |
| `Bash(git commit*)` | Match specific bash patterns |
| `Edit\|Write` | Match multiple tool types |
| `Edit(**)` | Match with wildcards |

## Installation Reference

### Installation Commands

```bash
# Basic installation
./install.sh --lang LANG

# Installation options
./install.sh --lang LANG [OPTIONS]
```

### Installation Options

| Option | Description |
|--------|-------------|
| `--lang LANG` | Language (en, zh, ja, fr, ko) |
| `--dry-run` | Preview installation |
| `--no-verify` | Skip verification |
| `--force` | Force overwrite |
| `--target PATH` | Custom target directory |
| `--help` | Show help |

### Supported Languages

| Code | Language | Status |
|------|----------|--------|
| `en` | English | ✅ Complete |
| `zh` | Chinese | ✅ Complete |
| `ja` | Japanese | ✅ Complete |
| `fr` | French | ⚠️ Partial |
| `ko` | Korean | ⚠️ Partial |

## Error Codes and Messages

### Common Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | General error |
| `2` | Permission denied |
| `126` | Command not executable |
| `127` | Command not found |
| `130` | Script terminated by user |

### Common Error Messages

| Message | Cause | Solution |
|---------|-------|---------|
| "Permission denied" | Script not executable | `chmod +x script.sh` |
| "Command not found" | Missing dependency | Install required tool |
| "Invalid settings files" | JSON syntax error | Regenerate settings.json |
| "Upstream remote not found" | Git remote missing | Add upstream remote |
| "Working directory has uncommitted changes" | Dirty git state | Commit or stash changes |

## Performance Tuning

### Optimization Settings

```json
{
  "env": {
    "BASH_DEFAULT_TIMEOUT_MS": "300000",
    "BASH_MAX_TIMEOUT_MS": "600000"
  },
  "hooks": {
    "PostToolUse": []
  }
}
```

### Resource Limits

| Resource | Default | Recommended Range |
|----------|---------|-------------------|
| Timeout | 600000ms | 300000-900000ms |
| Commands | 42 | 20-50 |
| Roles | 8 | 5-15 |
| Scripts | 9 | 5-20 |

## Security Reference

### Safe Commands
- All read operations
- Standard editing operations
- Git operations (non-destructive)
- Python script execution

### Dangerous Commands (Blocked)
- `rm -rf /` - System deletion
- `sudo *` - Privilege escalation
- `format *` - Disk formatting
- `dd *` - Low-level disk operations

### Security Best Practices
1. Review hook scripts before installation
2. Use dry-run mode for testing
3. Keep backups before major changes
4. Validate JSON configurations
5. Monitor hook execution logs

---

This completes the comprehensive reference for Claude Code Cookbook. For specific usage examples and tutorials, refer to the numbered documentation guides.

> **Navigation:** [Previous: Contributing](91-contributing.md) | [Documentation Index](README.md)