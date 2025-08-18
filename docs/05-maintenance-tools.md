# Maintenance Tools Overview

> **Navigation:** [Previous: Architecture Overview](04-architecture-overview.md) | [Next: Upstream Sync Guide](06-sync-upstream-guide.md) | [Documentation Index](README.md)

## Quick Reference

```bash
# 🎛️ Unified Management (Recommended)
./utils/workflow-manager.sh interactive    # Interactive menu
./utils/workflow-manager.sh sync          # Full synchronization
./utils/workflow-manager.sh status        # Project status

# 🤖 Automated Maintenance
./utils/auto-maintenance.sh               # Smart auto-sync
./daily-maintenance.sh                    # Simple daily check

# 🔧 Individual Tools
./utils/sync-upstream.sh                  # Upstream synchronization
python3 utils/translate-content.py        # Translation management
./utils/release-manager.sh                # Version releases
./utils/cleanup-structure.sh              # Structure optimization
```

## Overview

Claude Code Cookbook includes a comprehensive suite of maintenance tools designed to keep your installation synchronized with upstream improvements while preserving your architectural advantages. This guide helps you choose the right tools for your needs.

## Tool Selection Guide

### For Different User Types

#### 🚀 **New Users** (Just want it to work)
```bash
# Use the simple daily maintenance
./daily-maintenance.sh
```
- **Best for**: Getting started quickly
- **Features**: Friendly interface, safe defaults
- **Frequency**: Weekly or when prompted

#### 🔧 **Regular Users** (Want some control)
```bash
# Use the unified workflow manager
./utils/workflow-manager.sh interactive
```
- **Best for**: Balanced control and convenience
- **Features**: Interactive menus, preview modes
- **Frequency**: Monthly or for major updates

#### 🤖 **Power Users** (Want automation)
```bash
# Set up automated maintenance
./utils/auto-maintenance.sh
# + cron job for scheduling
```
- **Best for**: Set-and-forget automation
- **Features**: Risk assessment, automatic backups
- **Frequency**: Automated (weekly checks)

#### 🛠️ **Developers** (Want full control)
```bash
# Use individual tools as needed
./utils/sync-upstream.sh sync
python3 utils/translate-content.py validate
./utils/release-manager.sh package v2.1.0
```
- **Best for**: Custom workflows, development
- **Features**: Granular control, scriptable
- **Frequency**: As needed for development

## Complete Tool Suite

### 1. 🎛️ Workflow Manager (`workflow-manager.sh`)

**Purpose**: Unified orchestration of all maintenance tasks

#### Key Features
- **Interactive Mode**: User-friendly menu system
- **Workflow Orchestration**: Coordinates multiple tools
- **Preview Mode**: See what will happen before execution
- **Status Monitoring**: Comprehensive project health checks

#### When to Use
- **Regular maintenance**: Monthly synchronization
- **Major updates**: When upstream has significant changes
- **Team coordination**: Standardized maintenance procedures
- **Learning**: Understanding the maintenance process

#### Quick Start
```bash
# Interactive mode (recommended for beginners)
./utils/workflow-manager.sh interactive

# Direct workflows
./utils/workflow-manager.sh sync          # Full synchronization
./utils/workflow-manager.sh maintenance   # Health check and cleanup
./utils/workflow-manager.sh status        # Current project status
```

### 2. 🔄 Upstream Sync (`sync-upstream.sh`)

**Purpose**: Synchronize with the original wasabeef/claude-code-cookbook repository

#### Key Features
- **Intelligent Sync**: Preserves your architectural advantages
- **Risk Assessment**: Evaluates upstream changes before applying
- **Selective Sync**: Sync specific languages or components
- **Dry Run Mode**: Preview changes without applying them

#### When to Use
- **Regular updates**: Keep up with upstream improvements
- **New features**: Get latest commands and roles
- **Bug fixes**: Receive upstream fixes and improvements
- **Security updates**: Stay current with security patches

#### Quick Start
```bash
# Check for upstream updates
./utils/sync-upstream.sh check

# Full synchronization
./utils/sync-upstream.sh sync

# Preview mode
./utils/sync-upstream.sh sync --dry-run

# Sync specific language
./utils/sync-upstream.sh sync --lang zh
```

### 3. 🌍 Translation Manager (`translate-content.py`)

**Purpose**: Manage multi-language content and translations

#### Key Features
- **Translation Status**: Track completeness across languages
- **Smart Detection**: Identify content needing translation
- **Validation System**: Ensure all languages have complete feature sets
- **Translation Assistance**: Generate translation prompts

#### When to Use
- **New content**: Translate new commands or roles
- **Quality assurance**: Verify translation completeness
- **Language expansion**: Add support for new languages
- **Content updates**: Update translations after upstream changes

#### Quick Start
```bash
# Check translation status
python3 utils/translate-content.py status

# Scan for translation needs
python3 utils/translate-content.py scan

# Translate specific language
python3 utils/translate-content.py translate --lang ja

# Validate completeness
python3 utils/translate-content.py validate
```

### 4. 🚀 Release Manager (`release-manager.sh`)

**Purpose**: Manage version releases and distribution

#### Key Features
- **Release Validation**: Ensure readiness before release
- **Package Creation**: Generate distribution packages
- **Version Management**: Handle Git tags and versioning
- **Release Notes**: Automatic generation of release documentation

#### When to Use
- **Version releases**: Create new versions for distribution
- **Quality assurance**: Validate project before release
- **Distribution**: Package for sharing or deployment
- **Documentation**: Generate release statistics and notes

#### Quick Start
```bash
# Validate release readiness
./utils/release-manager.sh validate

# View project statistics
./utils/release-manager.sh stats

# Prepare release
./utils/release-manager.sh prepare v2.1.0

# Create distribution package
./utils/release-manager.sh package v2.1.0
```

### 5. 🤖 Auto Maintenance (`auto-maintenance.sh`)

**Purpose**: Intelligent automated maintenance with safety controls

#### Key Features
- **Risk Assessment**: Automatically evaluate upstream changes
- **Safety Thresholds**: Prevent dangerous automatic updates
- **Backup Management**: Automatic backup and cleanup
- **Notification System**: Email alerts for important events

#### When to Use
- **Automated workflows**: Set-and-forget maintenance
- **Production systems**: Safe automated updates
- **Team environments**: Consistent maintenance across team
- **Monitoring**: Continuous health monitoring

#### Quick Start
```bash
# Run automated maintenance
./utils/auto-maintenance.sh

# Check for updates only
./utils/auto-maintenance.sh check

# Force sync (override safety checks)
./utils/auto-maintenance.sh force

# Preview mode
./utils/auto-maintenance.sh --dry-run
```

### 6. 🧹 Structure Cleanup (`cleanup-structure.sh`)

**Purpose**: Optimize project structure and organization

#### Key Features
- **Structure Analysis**: Analyze current project organization
- **Redundancy Removal**: Clean up duplicate or obsolete files
- **Documentation Organization**: Organize project documentation
- **Upstream Alignment**: Align structure with upstream best practices

#### When to Use
- **Project cleanup**: Remove redundant or obsolete files
- **Structure optimization**: Improve project organization
- **Upstream alignment**: Sync structural improvements
- **Maintenance preparation**: Clean up before major updates

#### Quick Start
```bash
# Analyze current structure
./utils/cleanup-structure.sh analyze

# Clean up redundant files
./utils/cleanup-structure.sh cleanup

# Full cleanup and optimization
./utils/cleanup-structure.sh full

# Integration with sync tools
./utils/cleanup-structure.sh integrate
```

### 7. 📅 Daily Maintenance (`daily-maintenance.sh`)

**Purpose**: Simple, user-friendly daily maintenance

#### Key Features
- **Simplified Interface**: Easy-to-use Chinese/English interface
- **Quick Operations**: Common maintenance tasks in one place
- **Safe Defaults**: Conservative approach to changes
- **Status Overview**: Quick project health summary

#### When to Use
- **Daily/weekly checks**: Regular maintenance routine
- **Non-technical users**: Simple interface for basic users
- **Quick updates**: Fast check for upstream changes
- **Status monitoring**: Quick project health overview

#### Quick Start
```bash
# Run daily maintenance (interactive)
./daily-maintenance.sh

# This provides a simple menu with options:
# 1. Sync with upstream
# 2. Preview changes
# 3. View project status
# 4. Skip maintenance
```

## Tool Integration Workflows

### Workflow 1: Regular Maintenance (Recommended)

```bash
# Step 1: Check status
./utils/workflow-manager.sh status

# Step 2: Sync if needed
./utils/workflow-manager.sh sync

# Step 3: Validate results
python3 utils/translate-content.py validate
```

**Frequency**: Monthly or when notified of upstream changes

### Workflow 2: Automated Maintenance

```bash
# Setup: Configure automated maintenance
./utils/auto-maintenance.sh --email your@email.com

# Add to crontab for weekly checks
crontab -e
# Add: 0 9 * * 1 cd /path/to/project && ./utils/auto-maintenance.sh
```

**Frequency**: Automated (weekly checks, daily monitoring)

### Workflow 3: Development Workflow

```bash
# During development
./utils/sync-upstream.sh check           # Check for upstream changes
python3 utils/translate-content.py scan  # Check translation needs

# Before release
./utils/release-manager.sh validate      # Validate release readiness
./utils/cleanup-structure.sh full        # Clean up project structure
```

**Frequency**: As needed during development cycles

### Workflow 4: Translation Workflow

```bash
# After upstream sync
python3 utils/translate-content.py scan                    # Find new content
python3 utils/translate-content.py translate --lang zh     # Translate Chinese
python3 utils/translate-content.py translate --lang ja     # Translate Japanese
python3 utils/translate-content.py validate               # Verify completeness
```

**Frequency**: After major upstream updates or new feature additions

## Choosing the Right Approach

### Decision Matrix

| Scenario | Recommended Tool | Frequency | Automation Level |
|----------|------------------|-----------|------------------|
| **New User** | `daily-maintenance.sh` | Weekly | Manual |
| **Regular Use** | `workflow-manager.sh interactive` | Monthly | Semi-automated |
| **Power User** | `auto-maintenance.sh` + cron | Automated | Fully automated |
| **Developer** | Individual tools as needed | As needed | Custom scripts |
| **Team Lead** | `workflow-manager.sh` + `release-manager.sh` | Bi-weekly | Scheduled |

### Risk Tolerance

#### Conservative (Recommended for Production)
```bash
# Always preview first
./utils/workflow-manager.sh sync --dry-run
# Then execute if safe
./utils/workflow-manager.sh sync
```

#### Balanced (Recommended for Development)
```bash
# Use automated maintenance with safety checks
./utils/auto-maintenance.sh
```

#### Aggressive (Only for Testing)
```bash
# Force sync regardless of risk assessment
./utils/auto-maintenance.sh force
```

## Getting Started

### First-Time Setup

1. **Choose Your Approach**:
   - New to maintenance? Start with `./daily-maintenance.sh`
   - Want control? Use `./utils/workflow-manager.sh interactive`
   - Want automation? Set up `./utils/auto-maintenance.sh`

2. **Test Your Choice**:
   ```bash
   # Always test with dry-run first
   ./utils/workflow-manager.sh sync --dry-run
   ```

3. **Establish Routine**:
   - Set calendar reminders for manual approaches
   - Configure cron jobs for automated approaches
   - Document your team's preferred workflow

### Next Steps

Choose your path based on your needs:

- **[Upstream Sync Guide](06-sync-upstream-guide.md)** - Learn detailed synchronization
- **[Translation Management](07-translation-management.md)** - Manage multi-language content
- **[Workflow Automation](09-workflow-automation.md)** - Set up automated maintenance
- **[Troubleshooting](10-troubleshooting.md)** - Solve common issues

---

**Ready to sync with upstream?** Continue to **[Upstream Sync Guide](06-sync-upstream-guide.md)** for detailed synchronization instructions.

> **Navigation:** [Previous: Architecture Overview](04-architecture-overview.md) | [Next: Upstream Sync Guide](06-sync-upstream-guide.md) | [Documentation Index](README.md)