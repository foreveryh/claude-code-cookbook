## Rust Dependencies Update

Update Rust project dependencies safely.

### Usage

```bash
# Check dependency status and request to Claude
cargo tree
"Update the dependencies in Cargo.toml to the latest versions"
```

### Basic Examples

```bash
# Check current dependencies
cat Cargo.toml
"Analyze this Rust project's dependencies and tell me which crates can be updated"

# Check updatable list
cargo update --dry-run
"Analyze the risk level for updating these crates"
```

### Integration with Claude

```bash
# Comprehensive dependency update
cat Cargo.toml
"Analyze Rust dependencies and perform the following:
1. Investigate the latest version of each crate
2. Check for breaking changes
3. Evaluate risk level (safe/caution/danger)
4. Suggest necessary code changes
5. Generate updated Cargo.toml"

# Safe incremental update
cargo tree
"Avoid major version upgrades and only update crates that can be safely updated"

# Analyze specific crate update impact
"Tell me the impact and necessary changes if I update tokio to the latest version"
```

### Detailed Examples

```bash
# Detailed analysis with Release Notes
cat Cargo.toml && cargo tree
"Analyze dependencies and for each crate provide:
1. Current → Latest version
2. Risk evaluation (safe/caution/danger)
3. Main changes (from CHANGELOG)
4. Trait bounds changes
5. Required code modifications
in table format"

# Async runtime migration analysis
cat Cargo.toml src/main.rs
"Show all necessary changes for migrating from async-std to tokio, or for a tokio major version upgrade"
```

### Risk Level Criteria

```
Safe (🟢):
- Patch version upgrade (0.1.2 → 0.1.3)
- Bug fixes only
- Backward compatibility guaranteed

Caution (🟡):
- Minor version upgrade (0.1.0 → 0.2.0)
- New features added
- Deprecation warnings present

Danger (🔴):
- Major version upgrade (0.x.y → 1.0.0, 1.x.y → 2.0.0)
- Breaking changes
- API deletions/changes
- Trait bounds changes
```

### Executing Updates

```bash
# Create backup
cp Cargo.toml Cargo.toml.backup
cp Cargo.lock Cargo.lock.backup

# Execute update
cargo update

# Verify after update
cargo check
cargo test
cargo clippy
```

### Important Notes

Always test functionality after updates. If problems occur, restore with:

```bash
cp Cargo.toml.backup Cargo.toml
cp Cargo.lock.backup Cargo.lock
cargo build
```
