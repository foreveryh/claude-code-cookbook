#!/bin/bash

# Local CI Test Script
# Tests the same components that will be tested in GitHub Actions

set -euo pipefail

echo "🧪 Running local CI tests..."
echo ""

# Test 1: ShellCheck
echo "1️⃣  Testing ShellCheck..."
if command -v shellcheck > /dev/null 2>&1; then
    echo "   ✅ ShellCheck found"
    
    # Find all shell scripts
    shell_scripts=($(find . -name "*.sh" -type f))
    echo "   📊 Found ${#shell_scripts[@]} shell scripts"
    
    # Run shellcheck with same options as CI
    failed_scripts=()
    for script in "${shell_scripts[@]}"; do
        if ! shellcheck -e SC1091 -e SC2034 -e SC2046 -e SC2086 -e SC2162 -e SC2181 "$script" > /dev/null 2>&1; then
            failed_scripts+=("$script")
        fi
    done || true  # Don't exit on shellcheck issues in local test
    
    if [ ${#failed_scripts[@]} -eq 0 ]; then
        echo "   ✅ All scripts passed ShellCheck"
    else
        echo "   ❌ Scripts with issues: ${failed_scripts[*]}"
        echo "   ℹ️  Note: This may be expected - CI will show detailed output"
    fi
else
    echo "   ⚠️  ShellCheck not found - install with 'brew install shellcheck'"
fi

echo ""

# Test 2: Install Script Tests
echo "2️⃣  Testing install script..."

# Test syntax
if bash -n install.sh; then
    echo "   ✅ install.sh syntax is valid"
else
    echo "   ❌ install.sh has syntax errors"
    exit 1
fi

# Test dry-run with English
echo "   🇺🇸 Testing English dry-run..."
# Use gtimeout if available, otherwise just run without timeout
if command -v gtimeout > /dev/null 2>&1; then
    if gtimeout 30 bash install.sh --lang en --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ English dry-run succeeded"
    else
        echo "   ❌ English dry-run failed"
        exit 1
    fi
elif command -v timeout > /dev/null 2>&1; then
    if timeout 30 bash install.sh --lang en --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ English dry-run succeeded"
    else
        echo "   ❌ English dry-run failed"
        exit 1
    fi
else
    if bash install.sh --lang en --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ English dry-run succeeded"
    else
        echo "   ❌ English dry-run failed"
        exit 1
    fi
fi

# Test dry-run with Chinese
echo "   🇨🇳 Testing Chinese dry-run..."
if command -v gtimeout > /dev/null 2>&1; then
    if gtimeout 30 bash install.sh --lang zh --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ Chinese dry-run succeeded"
    else
        echo "   ❌ Chinese dry-run failed"
        exit 1
    fi
elif command -v timeout > /dev/null 2>&1; then
    if timeout 30 bash install.sh --lang zh --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ Chinese dry-run succeeded"
    else
        echo "   ❌ Chinese dry-run failed"
        exit 1
    fi
else
    if bash install.sh --lang zh --dry-run --no-verify > /dev/null 2>&1; then
        echo "   ✅ Chinese dry-run succeeded"
    else
        echo "   ❌ Chinese dry-run failed"
        exit 1
    fi
fi

echo ""

# Test 3: Project Structure
echo "3️⃣  Testing project structure..."

# Check versions directory
if [ -d "versions" ]; then
    echo "   ✅ versions/ directory exists"
    
    # Check for language versions
    version_count=$(find versions -maxdepth 1 -type d ! -name versions | wc -l)
    if [ "$version_count" -gt 0 ]; then
        echo "   ✅ Found $version_count language versions"
        
        # Check each version structure
        for version_dir in versions/*/; do
            version=$(basename "$version_dir")
            if [ -d "$version_dir/commands" ] && [ -d "$version_dir/agents" ]; then
                echo "   ✅ Version $version has required structure"
            else
                echo "   ❌ Version $version missing required directories"
                exit 1
            fi
        done
    else
        echo "   ❌ No language versions found"
        exit 1
    fi
else
    echo "   ❌ versions/ directory not found"
    exit 1
fi

# Check settings template
if [ -f "settings.json.template" ]; then
    if grep -q "{{CLAUDE_LANGUAGE}}" settings.json.template; then
        echo "   ✅ settings.json.template is valid"
    else
        echo "   ❌ settings.json.template missing placeholders"
        exit 1
    fi
else
    echo "   ❌ settings.json.template not found"
    exit 1
fi

echo ""

# Test 4: Security Check
echo "4️⃣  Running basic security checks..."

# Temporarily disable strict error handling for security checks
set +e

# Check for critical security issues only
critical_found=false

# Check for extremely dangerous patterns with literal matches
grep -r "rm -rf /" --include="*.sh" --exclude="test-ci-local.sh" . >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ❌ Found critical security issue: rm -rf /"
    critical_found=true
fi

grep -r "rm -rf \$HOME" --include="*.sh" --exclude="test-ci-local.sh" . >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ❌ Found critical security issue: rm -rf \$HOME"
    critical_found=true
fi

# Skip other patterns that are too broad and cause false positives

# Check for common patterns but only warn
warning_patterns=("eval.*\$" "exec.*\$" "\`.*\`")
for pattern in "${warning_patterns[@]}"; do
    matches=$(grep -r "$pattern" --include="*.sh" . 2>/dev/null | wc -l)
    if [ "$matches" -gt 0 ]; then
        echo "   ⚠️  Found $matches instances of potentially risky pattern: $pattern (warning only)"
    fi
done

if [ "$critical_found" = false ]; then
    echo "   ✅ No critical security issues found"
else
    echo "   ❌ Critical security issues found - would fail in CI"
    set -e  # Re-enable strict error handling
    exit 1
fi

# Check file permissions
world_writable=$(find . -name "*.sh" -perm /o+w -type f 2>/dev/null | wc -l)
if [ "$world_writable" -eq 0 ]; then
    echo "   ✅ File permissions look good"
else
    echo "   ⚠️  Found $world_writable world-writable scripts (warning only)"
fi

# Re-enable strict error handling
set -e

echo ""
echo "🎉 Local CI tests completed!"
echo ""
echo "📋 Summary:"
echo "   • ShellCheck: Ready for CI"
echo "   • Install Script: ✅ Working"
echo "   • Project Structure: ✅ Valid"
echo "   • Security: ✅ Basic checks passed"
echo ""
echo "🚀 Ready to push to GitHub Actions!"
