# Getting Started with Claude Code Cookbook

> **Navigation:** [Next: Installation Guide](02-installation-guide.md) | [Documentation Index](README.md)

## Table of Contents

### 📚 Learning Path
1. **[Getting Started](01-getting-started.md)** ← You are here
2. **[Installation Guide](02-installation-guide.md)** - Detailed setup instructions
3. **[Basic Usage](03-basic-usage.md)** - Common commands and workflows
4. **[Architecture Overview](04-architecture-overview.md)** - Understanding the project structure

### 🔧 Maintenance Tools
5. **[Maintenance Tools Overview](05-maintenance-tools.md)** - Tool selection guide
6. **[Upstream Sync Guide](06-sync-upstream-guide.md)** - Synchronizing with upstream
7. **[Translation Management](07-translation-management.md)** - Managing multi-language content
8. **[Release Management](08-release-management.md)** - Version control and releases
9. **[Workflow Automation](09-workflow-automation.md)** - Automated maintenance

### 📖 Reference
10. **[Troubleshooting](10-troubleshooting.md)** - Common issues and solutions
90. **[Advanced Configuration](90-advanced-configuration.md)** - Power user features
91. **[Contributing](91-contributing.md)** - How to contribute
99. **[Complete Reference](99-reference.md)** - All commands and options

## Quick Reference

```bash
# 🚀 Quick Start Commands
./install.sh --lang en              # Install English version
./daily-maintenance.sh              # Check for updates
./utils/workflow-manager.sh status  # View project status

# 🔄 Common Maintenance
./utils/workflow-manager.sh sync    # Sync with upstream
./utils/auto-maintenance.sh         # Automated maintenance
```

## Overview

Claude Code Cookbook is an advanced configuration system for Claude Desktop that provides:

- **🎯 Custom Commands**: 42+ specialized commands starting with `/`
- **🤖 Expert Roles**: 8 professional agent roles for different domains
- **🔧 Smart Hooks**: Automated scripts that enhance your workflow
- **🌍 Multi-Language**: Complete support for English, Chinese, Japanese, French, and Korean
- **🔄 Upstream Sync**: Advanced tools to stay synchronized with the original project

## What Makes This Fork Special

### 🏗️ Superior Architecture
- **`versions/` Structure**: Cleaner organization than upstream's `locales/` approach
- **Complete Language Parity**: All languages have identical feature sets
- **Intelligent Installation**: Smart language selection and setup

### 🚀 Advanced Features
- **Leading-Edge Commands**: Features ahead of upstream (pr-create-smart, deploy-check, etc.)
- **Automated Maintenance**: Intelligent upstream synchronization
- **Professional Workflows**: Enterprise-grade release and translation management

### 🛡️ Reliability
- **Smart Risk Assessment**: Automated evaluation of upstream changes
- **Backup & Recovery**: Multiple layers of safety for updates
- **Validation Systems**: Comprehensive testing of all changes

## Prerequisites

Before you begin, ensure you have:

- **Claude Desktop** installed and configured
- **Git** for version control
- **Python 3** for translation tools
- **Bash/Zsh** shell (macOS/Linux)
- **Basic command line** familiarity

## Quick Start (5 Minutes)

### 1. Clone and Install
```bash
# Clone the repository
git clone https://github.com/foreveryh/claude-code-cookbook.git
cd claude-code-cookbook

# Install your preferred language
./install.sh --lang en    # English
# ./install.sh --lang zh  # Chinese
# ./install.sh --lang ja  # Japanese
```

### 2. Configure Claude Desktop
1. Open **Claude Desktop**
2. Go to **Settings** → **Developer**
3. Set **Custom Instructions** path to: `/Users/[your-username]/.claude`

### 3. Test Installation
```bash
# Verify installation
ls ~/.claude/commands/    # Should show 42+ command files
ls ~/.claude/scripts/     # Should show 9 script files

# Test a command in Claude Desktop
# Type: /explain-code
```

### 4. Daily Maintenance
```bash
# Check for updates (recommended weekly)
./daily-maintenance.sh
```

## What's Next?

### For New Users
1. **[Installation Guide](02-installation-guide.md)** - Complete setup instructions
2. **[Basic Usage](03-basic-usage.md)** - Learn the essential commands
3. **[Architecture Overview](04-architecture-overview.md)** - Understand the project structure

### For Maintainers
1. **[Maintenance Tools](05-maintenance-tools.md)** - Overview of automation tools
2. **[Upstream Sync](06-sync-upstream-guide.md)** - Keep up with original project
3. **[Workflow Automation](09-workflow-automation.md)** - Set up automated maintenance

### For Contributors
1. **[Translation Management](07-translation-management.md)** - Help with translations
2. **[Contributing Guide](91-contributing.md)** - Development guidelines
3. **[Advanced Configuration](90-advanced-configuration.md)** - Customization options

## Getting Help

- **📖 Documentation**: Browse the numbered guides above
- **🔧 Troubleshooting**: Check [Troubleshooting Guide](10-troubleshooting.md)
- **📚 Reference**: See [Complete Reference](99-reference.md) for all commands
- **🐛 Issues**: Report problems on GitHub

## Key Concepts

### Commands
Custom commands that start with `/` - like `/explain-code` or `/pr-create-smart`

### Roles
Expert personas that Claude can adopt - like `/role architect` or `/role security`

### Hooks
Automated scripts that run at specific times to enhance your workflow

### Versions Structure
Our superior organization system that keeps each language version complete and synchronized

---

**Ready to dive deeper?** Continue to the **[Installation Guide](02-installation-guide.md)** for detailed setup instructions.

> **Navigation:** [Next: Installation Guide](02-installation-guide.md) | [Documentation Index](README.md)