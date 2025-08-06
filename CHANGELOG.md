# Changelog

All notable changes to the Claude Code Cookbook project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.0.0] - 2025-08-07

### 🚀 Major Features

#### Unified Installer System
- **BREAKING CHANGE**: Replaced `install-zh.sh` with unified `install.sh` supporting `--lang` option
- Auto-detection of system language for intelligent defaults
- Interactive language selection menu
- Support for English (`--lang en`) and Chinese (`--lang zh`) installations
- Comprehensive error handling and validation
- Backup functionality for existing installations

#### Enhanced Multi-language Support
- Complete Chinese translation achieving 52.2% coverage (24/46 files)
- New Chinese command translations for:
  - Pull Request management (`pr-auto-update`, `pr-feedback`, `pr-issue`, `pr-list`)
  - Code quality tools (`smart-review`, `semantic-commit`, `tech-debt`)
  - Analysis tools (`role-debate`, `sequential-thinking`, `ultrathink`)
  - Dependency management (`update-*-deps` series)
- Updated Chinese MCP configuration with localized model settings

#### CI/CD Infrastructure
- GitHub Actions workflow for automated testing
- Multi-language installation validation
- Dependency verification across different environments
- Local testing capabilities with `test-ci-local.sh`

### 📚 Documentation Improvements
- Installation flowchart and specifications
- Settings validation documentation
- Project management documentation in `pm_docs/`
- Enhanced README with updated installation instructions
- Translation progress tracking with `zh-translation-checklist.md`

### 🛠 Technical Improvements
- Settings template (`settings.json.template`) for easier configuration
- Improved command documentation with better examples
- Enhanced error handling in installation scripts
- Streamlined project structure

### 🗑️ Removed
- `install-zh.sh` - Users should now use `./install.sh --lang zh`

### Migration Guide
If you were using the old `install-zh.sh`, please:
1. Remove your existing installation: `rm -rf ~/.claude`  
2. Use the new unified installer: `./install.sh --lang zh`

---

## [v1.0.0] - 2025-08-06

### Initial Release

#### Core Features
- Custom Commands system with `/` prefix
- Role-based expert perspectives
- Hook automation for development workflows
- Multi-language support (English, Japanese, Chinese foundation)

#### Available Commands
- Code analysis and review tools
- Git workflow automation
- Dependency management
- Performance optimization
- Security analysis

#### Available Roles  
- Architect, Analyzer, Frontend, Mobile
- Performance, QA, Reviewer, Security experts

#### Installation Options
- English version installation
- Japanese version installation  
- Original mixed version installation

---

### Legend
- 🚀 Major Features
- 📚 Documentation  
- 🛠 Technical Improvements
- 🗑️ Removed
- ⚡ Performance
- 🐛 Bug Fixes
- 🔒 Security
