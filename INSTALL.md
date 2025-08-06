# Installation Guide

[English](INSTALL.md) | [日本語](INSTALL_ja.md) | [中文](INSTALL_zh.md)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/foreveryh/claude-code-cookbook.git
cd claude-code-cookbook

# Run installer (interactive mode)
./install.sh

# Or with flags (non-interactive)
./install.sh --lang en  # English version
./install.sh --lang zh  # Chinese version
```

## Manual Installation

If you prefer manual installation:

### 1. Choose Your Language Version

Available versions are in the `versions/` directory:
- `versions/en/` - English version
- `versions/ja/` - Japanese version (日本語)
- `versions/zh/` - Chinese version (中文版已发布)
- `versions/fr/` - French version (Français) [Coming soon]
- `versions/ko/` - Korean version (한국어) [Coming soon]

### 2. Copy to Your Claude Directory

```bash
# For English version
cp -r versions/en ~/.claude

# For Japanese version
cp -r versions/ja ~/.claude
```

### 3. Make Scripts Executable

```bash
chmod +x ~/.claude/scripts/*.sh
```

## Configuring Claude Desktop

1. Open Claude Desktop App
2. Navigate to: **Settings** → **Developer**
3. Set **Custom Instructions** path to: `~/.claude`
4. Restart Claude if needed

## Advanced Usage

### Interactive Installation
Run without flags to use the interactive installer:
```bash
./install.sh
```
The installer will:
- Auto-detect your system language
- Show a menu if detection fails
- Guide you through the installation process

### Non-Interactive Installation
Use flags for scripted/automated installations:
```bash
# Install English version with PPINFRA model
./install.sh --lang en --model ppinfra

# Install Chinese version with Gemini model
./install.sh --lang zh --model gemini

# Custom target directory
./install.sh --lang en --target ~/custom-claude

# Dry run (preview without changes)
./install.sh --lang en --dry-run

# Skip verification step
./install.sh --lang zh --no-verify
```

### Available Options
- `--lang {en,zh}`: Installation language
- `--model {ppinfra,gemini}`: AI model backend (default: ppinfra)
- `--target <path>`: Target directory (default: ~/.claude)
- `--dry-run`: Preview mode, no changes made
- `--no-verify`: Skip post-installation verification
- `--help`: Show help message

## Switching Languages

To switch to a different language version:

```bash
# Backup current version
mv ~/.claude ~/.claude.backup

# Install new version
./install.sh --lang [language_code]
```

## Directory Structure

```
~/.claude/
├── commands/       # Custom commands (/command-name)
├── agents/        
│   └── roles/     # Role definitions
├── scripts/       # Automation scripts
└── settings.json  # Configuration
```

## Verification

After installation, verify the setup:

```bash
# Check installation
ls -la ~/.claude

# Validate structure
./utils/validate.sh

# Test a command in Claude
# Type: /role-help
```

## Troubleshooting

### Permission Issues
```bash
# Fix script permissions
chmod +x ~/.claude/scripts/*.sh
```

### Path Issues
- Ensure Claude is configured with the correct path
- Use absolute path if `~/.claude` doesn't work: `/Users/[username]/.claude`

### Version Mismatch
- Run `./utils/validate.sh` to check version integrity
- Use `./utils/sync-versions.sh` to sync common files

## Updating

To update to the latest version:

```bash
# Pull latest changes
git pull

# Re-run installer
./install.sh
```

## Uninstallation

To remove Claude Code Cookbook:

```bash
# Remove the .claude directory
rm -rf ~/.claude

# Optionally restore backup
mv ~/.claude.backup ~/.claude
```

## Support

- **Issues**: [GitHub Issues](https://github.com/foreveryh/claude-code-cookbook/issues)
- **Documentation**: See README files in each language
- **Contributing**: Contributions welcome! See CONTRIBUTING.md

## Language Support Status

| Language | Commands | Roles | Scripts | Status |
|----------|----------|-------|---------|--------|
| English  | ✅ | ✅ | ✅ | Complete |
| Japanese | ✅ | ✅ | ✅ | Complete |
| Chinese  | 🚧 | 🚧 | ✅ | In Progress |
| French   | 🚧 | 🚧 | ✅ | In Progress |
| Korean   | 🚧 | 🚧 | ✅ | In Progress |

✅ Complete | 🚧 In Progress | ⏳ Planned
