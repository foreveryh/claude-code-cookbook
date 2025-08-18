# Installation Guide

> **Navigation:** [Previous: Getting Started](01-getting-started.md) | [Next: Basic Usage](03-basic-usage.md) | [Documentation Index](README.md)

## Quick Reference

```bash
# Standard Installation
./install.sh --lang en              # English
./install.sh --lang zh              # Chinese  
./install.sh --lang ja              # Japanese

# Advanced Options
./install.sh --lang en --dry-run    # Preview installation
./install.sh --lang zh --no-verify  # Skip verification
./install.sh --help                 # Show all options
```

## Overview

This guide provides comprehensive installation instructions for Claude Code Cookbook. The installation process is designed to be simple and safe, with automatic backup of existing configurations.

## Prerequisites

### System Requirements
- **Operating System**: macOS or Linux
- **Shell**: Bash or Zsh
- **Git**: Version 2.0 or higher
- **Python**: Version 3.6 or higher (for translation tools)
- **Claude Desktop**: Latest version

### Verification Commands
```bash
# Check prerequisites
git --version          # Should show 2.0+
python3 --version      # Should show 3.6+
which bash            # Should show bash path
which zsh             # Should show zsh path (if using zsh)
```

## Installation Methods

### Method 1: Standard Installation (Recommended)

#### Step 1: Clone Repository
```bash
# Clone from GitHub
git clone https://github.com/foreveryh/claude-code-cookbook.git
cd claude-code-cookbook

# Verify clone
ls -la                # Should show install.sh and versions/ directory
```

#### Step 2: Choose Language and Install
```bash
# English (recommended for most users)
./install.sh --lang en

# Chinese (中文)
./install.sh --lang zh

# Japanese (日本語)  
./install.sh --lang ja

# French (Français)
./install.sh --lang fr

# Korean (한국어)
./install.sh --lang ko
```

#### Step 3: Configure Claude Desktop
1. **Open Claude Desktop**
2. **Navigate to Settings**:
   - Click the gear icon or go to Claude Desktop → Settings
3. **Go to Developer Section**:
   - Find "Developer" or "Advanced" settings
4. **Set Custom Instructions Path**:
   - Set path to: `/Users/[your-username]/.claude`
   - On macOS: `/Users/john/.claude` (replace 'john' with your username)
   - On Linux: `/home/[your-username]/.claude`

#### Step 4: Verify Installation
```bash
# Check installed files
ls ~/.claude/                    # Should show commands/, scripts/, agents/
ls ~/.claude/commands/ | wc -l   # Should show 42+ files
ls ~/.claude/scripts/ | wc -l    # Should show 9+ files

# Test in Claude Desktop
# Type: /help or /role-help
```

### Method 2: Preview Installation (Safe Testing)

```bash
# Preview what will be installed
./install.sh --lang en --dry-run

# This shows you:
# - What files will be copied
# - Where they will be placed  
# - What configurations will be created
# - No actual changes are made
```

### Method 3: Custom Installation

#### Advanced Options
```bash
# Skip verification (faster, less safe)
./install.sh --lang en --no-verify

# Custom target directory
./install.sh --lang en --target /custom/path

# Force reinstall (overwrites existing)
./install.sh --lang en --force

# Show all options
./install.sh --help
```

## Language Selection Guide

### English (en) - Recommended
- **Best for**: Most users, contributors, documentation
- **Features**: Complete feature set, latest updates
- **Maintenance**: Easiest to maintain and update

### Chinese (zh) - 中文
- **Best for**: Chinese-speaking users
- **Features**: Complete translation, cultural adaptations
- **Maintenance**: Synchronized with English version

### Japanese (ja) - 日本語
- **Best for**: Japanese-speaking users, original upstream compatibility
- **Features**: Complete translation, matches upstream style
- **Maintenance**: Well-maintained, frequent updates

### French (fr) - Français
- **Best for**: French-speaking users
- **Features**: Basic translation (expanding)
- **Status**: Partial - contributions welcome

### Korean (ko) - 한국어
- **Best for**: Korean-speaking users
- **Features**: Basic translation (expanding)
- **Status**: Partial - contributions welcome

## Installation Process Details

### What Gets Installed

#### Core Components
```
~/.claude/
├── commands/          # 42+ custom commands
├── agents/roles/      # 8 expert roles
├── scripts/           # 9 automation scripts
├── hooks/             # Workflow automation
├── settings.json      # Configuration file
├── Claude.md          # Main instructions
└── .env              # Environment variables
```

#### Language-Specific Content
- **Commands**: Translated command descriptions and examples
- **Roles**: Localized expert role definitions
- **Documentation**: Language-appropriate Claude.md file
- **Scripts**: Localized user messages and notifications

### Backup Process

The installer automatically backs up existing installations:

```bash
# Automatic backup location
~/.claude_backup_YYYYMMDD_HHMMSS/

# Example
~/.claude_backup_20241218_143022/
```

### Configuration Generation

The installer creates optimized configurations:

#### settings.json Features
- **Language-specific notifications**: Localized system messages
- **Performance optimizations**: Faster hook execution
- **Security settings**: Safe command restrictions
- **Integration hooks**: Automated workflows

#### Environment Variables (.env)
- **Model configuration**: AI model settings
- **Language preferences**: UI language settings
- **Feature flags**: Optional feature toggles

## Troubleshooting Installation

### Common Issues

#### Issue 1: Permission Denied
```bash
# Problem
./install.sh: Permission denied

# Solution
chmod +x install.sh
./install.sh --lang en
```

#### Issue 2: Python Not Found
```bash
# Problem
python3: command not found

# Solutions (choose one)
# macOS with Homebrew
brew install python3

# macOS with official installer
# Download from python.org

# Ubuntu/Debian
sudo apt update && sudo apt install python3

# CentOS/RHEL
sudo yum install python3
```

#### Issue 3: Git Not Found
```bash
# Problem
git: command not found

# Solutions
# macOS
xcode-select --install
# or
brew install git

# Ubuntu/Debian  
sudo apt install git

# CentOS/RHEL
sudo yum install git
```

#### Issue 4: Claude Desktop Not Finding Files
```bash
# Problem
Commands not appearing in Claude Desktop

# Solutions
1. Check path in Claude Desktop settings
2. Verify files exist: ls ~/.claude/commands/
3. Restart Claude Desktop
4. Check permissions: ls -la ~/.claude/
```

#### Issue 5: Installation Fails Midway
```bash
# Problem
Installation stops with errors

# Solutions
1. Check disk space: df -h
2. Check permissions: ls -la ~/
3. Try dry-run first: ./install.sh --lang en --dry-run
4. Check logs in terminal output
```

### Verification Commands

```bash
# Complete installation check
./utils/workflow-manager.sh status

# Check specific components
ls ~/.claude/commands/ | head -5     # Should show command files
ls ~/.claude/scripts/               # Should show script files
cat ~/.claude/settings.json | head  # Should show valid JSON

# Test functionality
python3 utils/translate-content.py status  # Should show language stats
```

## Post-Installation Setup

### 1. Configure API Keys (Optional)
```bash
# Edit environment file
nano ~/.claude/.env

# Add your API keys if using external services
PPINFRA_API_KEY=your_key_here
GEMINI_API_KEY=your_key_here
```

### 2. Set Up Maintenance (Recommended)
```bash
# Test maintenance tools
./daily-maintenance.sh

# Set up automated checks (optional)
crontab -e
# Add: 0 9 * * 1 cd /path/to/claude-code-cookbook && ./utils/auto-maintenance.sh
```

### 3. Customize Configuration (Advanced)
```bash
# Edit settings for your needs
nano ~/.claude/settings.json

# Common customizations:
# - Notification preferences
# - Hook timing
# - Security restrictions
```

## Upgrading Existing Installation

### From Previous Version
```bash
# The installer handles upgrades automatically
./install.sh --lang en

# Your existing configuration will be backed up
# New features will be added
# Existing customizations preserved where possible
```

### From Upstream Version
```bash
# If migrating from wasabeef/claude-code-cookbook
# 1. Backup your current setup
cp -r ~/.claude ~/.claude_backup_manual

# 2. Install this version
./install.sh --lang en

# 3. Compare configurations if needed
diff -r ~/.claude_backup_manual ~/.claude
```

## Next Steps

After successful installation:

1. **[Basic Usage Guide](03-basic-usage.md)** - Learn essential commands
2. **[Architecture Overview](04-architecture-overview.md)** - Understand the system
3. **[Maintenance Tools](05-maintenance-tools.md)** - Set up automation

## Getting Help

- **Installation Issues**: Check [Troubleshooting Guide](10-troubleshooting.md)
- **Usage Questions**: See [Basic Usage](03-basic-usage.md)
- **Advanced Setup**: Read [Advanced Configuration](90-advanced-configuration.md)

---

**Installation complete?** Continue to **[Basic Usage](03-basic-usage.md)** to learn the essential commands and workflows.

> **Navigation:** [Previous: Getting Started](01-getting-started.md) | [Next: Basic Usage](03-basic-usage.md) | [Documentation Index](README.md)