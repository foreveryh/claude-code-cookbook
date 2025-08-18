# Troubleshooting Guide

> **Navigation:** [Previous: Upstream Sync Guide](06-sync-upstream-guide.md) | [Next: Complete Reference](09-reference.md) | [Documentation Index](README.md)

## Quick Reference

```bash
# 🔍 Diagnostic Commands
./utils/workflow-manager.sh status        # Overall system health
python3 utils/translate-content.py validate  # Language completeness
./install.sh --lang en --dry-run         # Test installation

# 🚨 Emergency Recovery
git tag -l | grep backup                 # Find backup points
git reset --hard backup-tag-name        # Restore from backup
./install.sh --lang en --force          # Force reinstall
```

## Common Issues and Solutions

### Installation Issues

#### Issue 1: Commands Not Appearing in Claude Desktop

**Symptoms:**
- Commands like `/explain-code` don't work
- Claude Desktop doesn't recognize custom commands
- No response when typing `/help`

**Solutions:**

```bash
# 1. Check Claude Desktop settings
# Open Claude Desktop → Settings → Developer
# Verify Custom Instructions path: /Users/[username]/.claude

# 2. Verify files exist
ls ~/.claude/commands/           # Should show 42+ files
ls ~/.claude/Claude.md          # Should exist

# 3. Check file permissions
ls -la ~/.claude/               # Files should be readable

# 4. Restart Claude Desktop
# Quit and reopen Claude Desktop application

# 5. Force reinstall if needed
./install.sh --lang en --force
```

#### Issue 2: Installation Script Fails

**Symptoms:**
- `./install.sh` stops with errors
- Permission denied errors
- Missing dependencies

**Solutions:**

```bash
# 1. Check script permissions
chmod +x install.sh
ls -la install.sh               # Should show -rwxr-xr-x

# 2. Check dependencies
git --version                   # Should show 2.0+
python3 --version              # Should show 3.6+

# 3. Check disk space
df -h                          # Ensure sufficient space

# 4. Try dry-run first
./install.sh --lang en --dry-run

# 5. Check for existing installation conflicts
ls ~/.claude/                  # Check what's already there
```

#### Issue 3: Language Installation Problems

**Symptoms:**
- Specific language doesn't install correctly
- Mixed language content
- Translation errors

**Solutions:**

```bash
# 1. Check language availability
ls versions/                   # Should show en, zh, ja, fr, ko

# 2. Validate language completeness
python3 utils/translate-content.py status

# 3. Reinstall specific language
./install.sh --lang zh --force

# 4. Check translation status
python3 utils/translate-content.py validate
```

### Maintenance Tool Issues

#### Issue 4: Sync Tools Not Working

**Symptoms:**
- `./utils/sync-upstream.sh` fails
- "Permission denied" errors
- Tools not found

**Solutions:**

```bash
# 1. Check tool permissions
chmod +x utils/*.sh utils/*.py
ls -la utils/                  # All should be executable

# 2. Check upstream remote
git remote -v                  # Should show upstream
git remote add upstream https://github.com/wasabeef/claude-code-cookbook.git

# 3. Test individual tools
./utils/workflow-manager.sh status
python3 utils/translate-content.py status

# 4. Check Python dependencies
python3 -c "import json, hashlib, pathlib"  # Should not error
```

#### Issue 5: Upstream Sync Failures

**Symptoms:**
- Sync stops with merge conflicts
- "Failed to fetch upstream" errors
- Incomplete synchronization

**Solutions:**

```bash
# 1. Check network connectivity
git fetch upstream main        # Should work without errors

# 2. Resolve merge conflicts
git status                     # Check for conflicts
git stash                      # Save local changes
./utils/workflow-manager.sh sync
git stash pop                  # Restore changes

# 3. Force sync if safe
./utils/sync-upstream.sh sync --force

# 4. Restore from backup if needed
git tag -l | grep backup
git reset --hard backup-tag-name
```

#### Issue 6: Translation Tool Errors

**Symptoms:**
- Python script errors
- Translation validation fails
- Missing language content

**Solutions:**

```bash
# 1. Check Python installation
python3 --version             # Should be 3.6+
which python3                 # Should show path

# 2. Check file structure
ls versions/en/commands/ | wc -l    # Should show 42+
ls versions/zh/commands/ | wc -l    # Should match or be close

# 3. Regenerate translations
python3 utils/translate-content.py scan
python3 utils/translate-content.py translate --lang zh

# 4. Validate and fix
python3 utils/translate-content.py validate
```

### Configuration Issues

#### Issue 7: Settings.json Problems

**Symptoms:**
- "Invalid settings files" error in Claude Desktop
- JSON syntax errors
- Configuration not loading

**Solutions:**

```bash
# 1. Validate JSON syntax
python3 -m json.tool ~/.claude/settings.json

# 2. Regenerate settings
./install.sh --lang en         # Regenerates settings.json

# 3. Check template
python3 -m json.tool settings.json.template

# 4. Manual fix if needed
cp settings.json.example ~/.claude/settings.json
```

#### Issue 8: Hook System Not Working

**Symptoms:**
- Automated scripts not running
- No notifications
- Hooks not executing

**Solutions:**

```bash
# 1. Check hook configuration
cat ~/.claude/settings.json | grep -A 10 "hooks"

# 2. Test hook scripts individually
~/.claude/scripts/auto-comment.sh
~/.claude/scripts/deny-check.sh

# 3. Check script permissions
ls -la ~/.claude/scripts/      # Should be executable

# 4. Simplify hooks for testing
# Edit ~/.claude/settings.json and disable complex hooks
```

### Performance Issues

#### Issue 9: Slow Command Response

**Symptoms:**
- Commands take long time to execute
- Claude Desktop becomes unresponsive
- High CPU usage

**Solutions:**

```bash
# 1. Check hook complexity
cat ~/.claude/settings.json | grep -A 5 "PostToolUse"

# 2. Disable heavy hooks temporarily
# Edit settings.json and comment out slow hooks

# 3. Check script efficiency
time ~/.claude/scripts/statusline.sh

# 4. Optimize configuration
# Remove unnecessary hooks or commands
```

#### Issue 10: Large File Issues

**Symptoms:**
- Installation takes very long
- Disk space warnings
- Slow file operations

**Solutions:**

```bash
# 1. Check disk usage
du -sh ~/.claude/              # Check installation size
df -h                          # Check available space

# 2. Clean up old backups
find ~ -name ".claude_backup_*" -type d -mtime +30 -exec rm -rf {} \;

# 3. Remove unnecessary files
./utils/cleanup-structure.sh cleanup

# 4. Optimize installation
./install.sh --lang en --no-verify  # Skip verification for speed
```

## Advanced Troubleshooting

### Diagnostic Commands

#### System Health Check
```bash
# Complete system diagnostic
./utils/workflow-manager.sh status

# Individual component checks
ls ~/.claude/commands/ | wc -l          # Command count
ls ~/.claude/scripts/ | wc -l           # Script count
python3 utils/translate-content.py validate  # Language completeness
```

#### Log Analysis
```bash
# Check maintenance logs
tail -f maintenance.log

# Check installation logs
./install.sh --lang en 2>&1 | tee install.log

# Check sync logs
./utils/sync-upstream.sh check 2>&1 | tee sync.log
```

#### Configuration Validation
```bash
# Validate all JSON files
find ~/.claude/ -name "*.json" -exec python3 -m json.tool {} \; > /dev/null

# Check file integrity
find ~/.claude/ -name "*.md" -exec head -1 {} \;

# Verify permissions
find ~/.claude/ -type f -not -perm -644 -ls
find ~/.claude/ -type d -not -perm -755 -ls
```

### Recovery Procedures

#### Complete System Recovery
```bash
# 1. Backup current state (if possible)
cp -r ~/.claude ~/.claude_broken_$(date +%Y%m%d)

# 2. Find last known good backup
git tag -l | grep backup | tail -5

# 3. Reset to backup
git reset --hard backup-tag-name

# 4. Reinstall
./install.sh --lang en --force

# 5. Verify recovery
./utils/workflow-manager.sh status
```

#### Partial Recovery
```bash
# Recover just commands
cp -r versions/en/commands ~/.claude/

# Recover just scripts
cp -r versions/en/scripts ~/.claude/

# Recover just configuration
./install.sh --lang en --config-only
```

#### Emergency Minimal Installation
```bash
# Minimal working installation
mkdir -p ~/.claude/{commands,scripts,agents/roles}
cp versions/en/Claude.md ~/.claude/
cp versions/en/commands/*.md ~/.claude/commands/
cp settings.json.example ~/.claude/settings.json
```

### Prevention Strategies

#### Regular Maintenance
```bash
# Weekly health check
./daily-maintenance.sh

# Monthly full maintenance
./utils/workflow-manager.sh maintenance

# Automated monitoring
# Add to crontab:
# 0 9 * * 1 cd /path/to/project && ./utils/auto-maintenance.sh
```

#### Backup Strategy
```bash
# Automatic backups (done by tools)
git tag -l | grep backup

# Manual backups before major changes
git tag manual-backup-$(date +%Y%m%d) -m "Manual backup"
cp -r ~/.claude ~/.claude_manual_backup_$(date +%Y%m%d)
```

#### Monitoring
```bash
# Set up monitoring script
cat > monitor-claude.sh << 'EOF'
#!/bin/bash
if ! ls ~/.claude/commands/ > /dev/null 2>&1; then
  echo "ALERT: Claude commands directory missing!"
fi
if ! python3 -m json.tool ~/.claude/settings.json > /dev/null 2>&1; then
  echo "ALERT: Invalid settings.json!"
fi
EOF
chmod +x monitor-claude.sh
```

## Getting Additional Help

### Documentation Resources
- **[Installation Guide](02-installation-guide.md)** - Detailed setup instructions
- **[Basic Usage](03-basic-usage.md)** - Command and role usage
- **[Maintenance Tools](05-maintenance-tools.md)** - Tool-specific help
- **[Complete Reference](99-reference.md)** - All commands and options

### Community Support
- **GitHub Issues**: Report bugs and get help
- **Discussions**: Ask questions and share solutions
- **Wiki**: Community-maintained troubleshooting tips

### Emergency Contacts
If you encounter critical issues:
1. **Check GitHub Issues** for similar problems
2. **Create detailed bug report** with error messages and steps
3. **Include system information** (OS, Python version, etc.)
4. **Attach relevant logs** (installation, sync, maintenance)

## Troubleshooting Checklist

Before asking for help, please check:

- [ ] ✅ **Basic Requirements**: Git, Python 3.6+, Claude Desktop installed
- [ ] ✅ **File Permissions**: All scripts executable, files readable
- [ ] ✅ **Claude Desktop Settings**: Custom Instructions path set correctly
- [ ] ✅ **Network Connectivity**: Can access GitHub, upstream repository
- [ ] ✅ **Disk Space**: Sufficient space for installation and backups
- [ ] ✅ **Clean State**: No uncommitted changes, clean working directory
- [ ] ✅ **Recent Backup**: Have backup point to restore if needed
- [ ] ✅ **Error Messages**: Captured complete error output
- [ ] ✅ **Reproduction Steps**: Can reproduce the issue consistently

---

**Need complete reference?** Continue to **[Complete Reference](09-reference.md)** for all commands and options.

> **Navigation:** [Previous: Upstream Sync Guide](06-sync-upstream-guide.md) | [Next: Complete Reference](09-reference.md) | [Documentation Index](README.md)