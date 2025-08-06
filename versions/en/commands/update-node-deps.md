## Update Node Deps

Safely update Node.js dependencies with compatibility checks and risk assessment.

### Usage

```bash
# Check dependency status and request Claude to update
npm outdated
"Update package.json dependencies to their latest versions"
```

### Basic Examples

```bash
# Check current dependencies
cat package.json
"Analyze this Node.js project dependencies and tell me which packages can be updated"

# Check available updates
npm outdated
"Analyze the risk level of updating these packages"
```

### Claude Integration

```bash
# Comprehensive dependency update
cat package.json
"Analyze Node.js dependencies and perform the following:
1. Research latest version for each package
2. Check for breaking changes
3. Evaluate risk level (Safe/Caution/Risky)
4. Suggest necessary code changes
5. Generate updated package.json"

# Safe incremental updates
npm outdated
"Avoid major version updates and only update packages that can be safely updated"

# Specific package update impact analysis
"What would be the impact and necessary changes if I update Express to the latest version?"
```

### Detailed Examples

```bash
# Detailed analysis including release notes
cat package.json && npm outdated
"Analyze dependencies and for each package provide:
1. Current → Latest version
2. Risk evaluation (Safe/Caution/Risky)
3. Key changes (from CHANGELOG)
4. Required code modifications
Present in table format"

# TypeScript project with type definitions
cat package.json tsconfig.json
"Update dependencies including TypeScript type definitions, ensuring no type errors occur"
```

### Risk Assessment Criteria

```
Safe (🟢):
- Patch version updates (1.2.3 → 1.2.4)
- Bug fixes only
- Backward compatibility guaranteed

Caution (🟡):
- Minor version updates (1.2.3 → 1.3.0)
- New features added
- Deprecation warnings present

Risky (🔴):
- Major version updates (1.2.3 → 2.0.0)
- Breaking changes
- API removals/changes
```

### Update Execution

```bash
# Create backup
cp package.json package.json.backup
cp package-lock.json package-lock.json.backup

# Execute update
npm update

# Post-update verification
npm test
npm run build
npm audit
```

### Important Notes

Always perform functionality testing after updates. If problems occur, restore using:

```bash
cp package.json.backup package.json
cp package-lock.json.backup package-lock.json
npm install
```
