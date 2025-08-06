# GitHub Actions CI Workflow

This directory contains the GitHub Actions workflows for automated testing and continuous integration of the Claude Code Cookbook project.

## Workflows

### 🔄 `ci.yml` - Continuous Integration

Automated testing pipeline that runs on every push and pull request to main branches (`main`, `dev`, `develop`).

#### Triggers
- **Push** to main branches with changes to:
  - Shell scripts (`**.sh`)
  - Workflow files (`.github/workflows/**`)
  - Version files (`versions/**`)
  - Settings template (`settings.json.template`)
- **Pull requests** targeting main branches with the same path filters

#### Jobs

##### 1. 🔍 ShellCheck (`shellcheck`)
- **Purpose**: Lint shell scripts for potential issues
- **Strategy**: Focus on critical scripts (mainly `install.sh`) with lenient rules for existing codebase
- **Configuration**: Excludes common warnings (SC1091, SC2034, SC2046, etc.)
- **Behavior**: 
  - ✅ **Critical scripts** (install.sh) must pass - build fails if they don't
  - ⚠️ **Other scripts** show warnings only - don't fail the build

##### 2. 🧪 Test Installer (`test-installer`)
- **Purpose**: Test the main installation script in various environments
- **Matrix Strategy**:
  - **Languages**: `en` (English), `zh` (Chinese)
  - **Containers**: `ubuntu:22.04`, `ubuntu:20.04`, `debian:bullseye`
- **Tests**:
  - Script permissions and structure validation
  - Dry-run installation for both languages
  - Bash syntax validation for all scripts
- **Timeout**: 300 seconds per test

##### 3. 🔧 Integration Tests (`integration-test`)
- **Purpose**: Verify project structure and end-to-end workflows
- **Tests**:
  - Version directory structure validation
  - Settings template validation
  - Complete workflow simulation for both languages
  - Temporary directory cleanup

##### 4. 🛡️ Security Checks (`security-check`)
- **Purpose**: Scan for potential security issues
- **Critical Patterns** (fail build):
  - `rm -rf /` - Dangerous file deletion
  - `rm -rf $HOME` - Home directory deletion
  - `chmod 777.*` - Overly permissive permissions
  - Unsafe download-and-execute patterns
- **Warning Patterns** (informational only):
  - `eval.*$` - Dynamic code execution
  - `exec.*$` - Process replacement
  - Backtick command substitution
- **File Permissions**: Check for world-writable scripts

##### 5. 📊 Summary (`summary`)
- **Purpose**: Aggregate results from all jobs
- **Behavior**: Always runs and provides a comprehensive status report
- **Output**: Clear pass/fail status for each job category

## Local Testing

### Quick Test Script
Run the local CI validation script to test your changes before pushing:

```bash
./test-ci-local.sh
```

This script replicates the same tests that run in GitHub Actions:
- ShellCheck validation
- Install script dry-run tests (English & Chinese)
- Project structure validation
- Basic security checks

### Manual Testing

#### Test Install Script
```bash
# Test English version
bash install.sh --lang en --dry-run --no-verify

# Test Chinese version  
bash install.sh --lang zh --dry-run --no-verify
```

#### Run ShellCheck
```bash
# Test critical script (install.sh)
shellcheck -e SC1091 -e SC2034 -e SC2046 -e SC2086 -e SC2162 -e SC2181 -e SC2155 -e SC2005 -e SC2207 -e SC2011 -e SC2199 -e SC2076 install.sh

# Test all scripts
find . -name "*.sh" -type f -exec shellcheck {} \;
```

#### Validate YAML Syntax
```bash
# Check workflow syntax
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"
```

## CI Configuration

### Environment Variables
The CI workflow uses the following environment variables:
- `LANG` / `LC_ALL`: Set to appropriate locales for language testing
- `HOME`: Used for temporary directory creation
- `GITHUB_OUTPUT`: For GitHub Actions step outputs

### Dependencies
All required dependencies are installed automatically:
- `shellcheck`: Shell script linting
- `git`, `curl`, `wget`: Version control and networking
- `bash`, `coreutils`, `findutils`, `sed`: Core utilities
- `timeout`: Command timeout management

### Timeouts
- **Install script tests**: 300 seconds (5 minutes)
- **Local test script**: 30 seconds per language test

## Workflow Optimization

### Performance Features
- **Path-based triggers**: Only runs when relevant files change
- **Parallel execution**: Jobs run concurrently when possible
- **Matrix strategy**: Tests multiple environments efficiently
- **Dependency management**: Jobs only run when prerequisites pass

### Failure Handling
- **Fail-fast disabled**: Continue testing other matrix combinations even if one fails
- **Conditional execution**: Summary job always runs to provide status
- **Graceful degradation**: Non-critical issues show warnings instead of failing

## Contributing

When adding new shell scripts or modifying existing ones:

1. **Test locally first**: Run `./test-ci-local.sh`
2. **Check ShellCheck compliance**: Especially for critical scripts
3. **Update workflow**: Add new critical scripts to the `critical_scripts` array if needed
4. **Document changes**: Update this README if workflow behavior changes

## Troubleshooting

### Common Issues

#### ShellCheck Failures
- Check the specific SC codes and either fix the issues or add exclusions
- Critical scripts must pass - non-critical scripts only show warnings

#### Container Permission Issues
- CI runs as root in containers - this is expected
- Local testing may differ from CI environment

#### Timeout Issues
- Install script should complete within 300 seconds
- If tests consistently timeout, increase the timeout value

#### Path Issues
- Workflow triggers on specific paths - ensure your changes match the path filters
- Use relative paths in scripts when possible

### Getting Help

If you encounter CI issues:
1. Check the **Actions** tab in GitHub for detailed logs
2. Run the local test script to reproduce issues
3. Review recent changes to shell scripts or workflow files
4. Check that all required files exist and have proper structure

## Security Notes

The CI workflow includes security scanning to prevent:
- Destructive file operations
- Unsafe code execution patterns
- Permission escalation issues
- Download-and-execute vulnerabilities

These checks help maintain the security of the installation process while allowing necessary functionality.
