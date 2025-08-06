## Flutter Dependencies Update

Update Flutter project dependencies safely.

### Usage

```bash
# Check dependency status and request to Claude
flutter pub deps --style=compact
"Update the dependencies in pubspec.yaml to the latest versions"
```

### Basic Examples

```bash
# Check current dependencies
cat pubspec.yaml
"Analyze this Flutter project's dependencies and tell me which packages can be updated"

# Check after upgrade
flutter pub upgrade --dry-run
"Check if there are any breaking changes in this upgrade plan"
```

### Integration with Claude

```bash
# Comprehensive dependency update
cat pubspec.yaml
"Analyze Flutter dependencies and perform the following:
1. Investigate the latest version of each package
2. Check for breaking changes
3. Evaluate risk level (safe/caution/danger)
4. Suggest necessary code changes
5. Generate updated pubspec.yaml"

# Safe incremental update
flutter pub outdated
"Avoid major version upgrades and only update packages that can be safely updated"

# Analyze specific package update impact
"Tell me the impact and necessary changes if I update provider to the latest version"
```

### Detailed Examples

```bash
# Detailed analysis with Release Notes
cat pubspec.yaml && flutter pub outdated
"Analyze dependencies and for each package provide:
1. Current → Latest version
2. Risk evaluation (safe/caution/danger)
3. Main changes (from CHANGELOG)
4. Required code modifications
in table format"

# Null Safety migration analysis
cat pubspec.yaml
"Identify packages that don't support Null Safety and create a migration plan"
```

### Risk Level Criteria

```
Safe (🟢):
- Patch version upgrade (1.2.3 → 1.2.4)
- Bug fixes only
- Backward compatibility guaranteed

Caution (🟡):
- Minor version upgrade (1.2.3 → 1.3.0)
- New features added
- Deprecation warnings present

Danger (🔴):
- Major version upgrade (1.2.3 → 2.0.0)
- Breaking changes
- API deletions/changes
```

### Executing Updates

```bash
# Create backup
cp pubspec.yaml pubspec.yaml.backup
cp pubspec.lock pubspec.lock.backup

# Execute update
flutter pub upgrade

# Verify after update
flutter analyze
flutter test
flutter pub deps --style=compact
```

### Important Notes

Always test functionality after updates. If problems occur, restore with:

```bash
cp pubspec.yaml.backup pubspec.yaml
cp pubspec.lock.backup pubspec.lock
flutter pub get
```
