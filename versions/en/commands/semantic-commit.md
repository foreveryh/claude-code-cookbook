## Semantic Commit

Splits large changes into meaningful atomic units and commits them sequentially with semantic commit messages. Uses only standard git commands without external tool dependencies.

### Usage

```bash
/semantic-commit [options]
```

### Options

- `--dry-run` : Display proposed commit splits without actually committing
- `--lang <language>` : Force commit message language (en, ja)
- `--max-commits <number>` : Specify maximum number of commits (default: 10)

### Basic Examples

```bash
# Analyze current changes and commit in logical units
/semantic-commit

# Review split proposal only (no actual commits)
/semantic-commit --dry-run

# Generate commit messages in English
/semantic-commit --lang en

# Split into maximum 5 commits
/semantic-commit --max-commits 5
```

### Workflow

1. **Change Analysis**: Get all changes with `git diff HEAD`
2. **File Classification**: Group changed files logically
3. **Commit Proposal**: Generate semantic commit messages for each group
4. **Sequential Execution**: Execute commits sequentially after user confirmation

### Core Change Splitting Features

#### "Large Change" Detection

Detects large changes based on the following criteria:
1. **File Count**: 5 or more changed files
2. **Line Count**: 100 or more changed lines
3. **Multiple Features**: Changes spanning 2 or more functional areas
4. **Mixed Patterns**: feat + fix + docs mixed together

```bash
# Change scale analysis
CHANGED_FILES=$(git diff HEAD --name-only | wc -l)
CHANGED_LINES=$(git diff HEAD --stat | tail -1 | grep -o '[0-9]\+ insertions\|[0-9]\+ deletions' | awk '{sum+=$1} END {print sum}')

if [ $CHANGED_FILES -ge 5 ] || [ $CHANGED_LINES -ge 100 ]; then
    echo "Large change detected: splitting recommended"
fi
```

#### Strategy for Splitting into "Meaningful Atomic Units"

##### 1. Split by Functional Boundaries

```bash
# Identify functional units from directory structure
git diff HEAD --name-only | cut -d'/' -f1-2 | sort | uniq
# → src/auth, src/api, components/ui etc
```

##### 2. Separate by Change Type

```bash
# New files vs existing file modifications
git diff HEAD --name-status | grep '^A' # New files
git diff HEAD --name-status | grep '^M' # Modified files
git diff HEAD --name-status | grep '^D' # Deleted files
```

##### 3. Dependency Analysis

```bash
# Detect import-related changes
git diff HEAD | grep -E '^[+-].*import|^[+-].*require' | \
cut -d' ' -f2- | sort | uniq
```

#### File-Level Detail Analysis

```bash
# Get list of changed files
git diff HEAD --name-only

# Analyze change content for each file individually
git diff HEAD -- <file>

# Determine file change type
git diff HEAD --name-status | while read status file; do
    case $status in
        A) echo "$file: New creation" ;;
        M) echo "$file: Modified" ;;
        D) echo "$file: Deleted" ;;
        R*) echo "$file: Renamed" ;;
    esac
done
```

#### Logical Grouping Criteria

1. **Functional Units**: Files related to the same feature
   - Files under `src/auth/` → Authentication feature
   - Files under `components/` → UI components

2. **Change Type**: Same type of changes
   - Test files only → `test:`
   - Documentation only → `docs:`
   - Configuration files only → `chore:`

3. **Dependencies**: Mutually related files
   - Model + Migration
   - Component + Style

4. **Change Scale**: Maintain appropriate commit size
   - Max 10 files per commit
   - Group highly related files

### Output Example

```bash
$ /semantic-commit

Analyzing changes...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Detected changes:
• src/auth/login.ts (modified)
• src/auth/register.ts (new)
• src/auth/types.ts (modified)
• tests/auth.test.ts (new)
• docs/authentication.md (new)

Proposed commit split:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commit 1/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Message: feat: implement user registration and login system

Included files:
• src/auth/login.ts
• src/auth/register.ts
• src/auth/types.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commit 2/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Message: test: add comprehensive tests for authentication system

Included files:
• tests/auth.test.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commit 3/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Message: docs: add authentication system documentation

Included files:
• docs/authentication.md

Execute commits with this split plan? (y/n/edit):
```

### Runtime Options

- `y` : Execute with proposed commit split
- `n` : Cancel
- `edit` : Edit commit messages individually
- `merge <number1> <number2>` : Merge specified commits
- `split <number>` : Further split specified commit

### Dry Run Mode

```bash
$ /semantic-commit --dry-run

Analyzing changes... (DRY RUN)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Commit split proposal display]

ℹ️ DRY RUN mode: No actual commits will be executed
💡 To execute, rerun without the --dry-run option
```

### Smart Analysis Features

#### 1. Project Structure Understanding
- Determine project type from `package.json`, `Cargo.toml`, `pom.xml` etc
- Infer functional units from folder structure

#### 2. Change Pattern Recognition

```bash
# Bug fix pattern detection
- Keywords like "fix", "bug", "error" etc
- Addition of exception handling
- Conditional logic fixes

# New feature pattern detection
- New file creation
- New method addition
- API endpoint addition
```

#### 3. Dependency Analysis
- Import statement changes
- Type definition additions/modifications
- Configuration file relationships

### Conventional Commits Compliance

#### Basic Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Standard Types

**Required Types**:
- `feat`: New features (user-visible feature additions)
- `fix`: Bug fixes

**Optional Types**:
- `build`: Build system or external dependency changes
- `chore`: Other changes (not affecting releases)
- `ci`: CI configuration file or script changes
- `docs`: Documentation-only changes
- `style`: Code changes that don't affect meaning (whitespace, formatting, semicolons etc)
- `refactor`: Code changes that neither fix bugs nor add features
- `perf`: Performance improvements
- `test`: Test additions or corrections

#### Scope (Optional)

Indicates the scope of change impact:

```
feat(api): add user authentication endpoint
fix(ui): resolve button alignment issue
docs(readme): update installation instructions
```

#### Breaking Changes

For API breaking changes:

```
feat!: change user API response format

BREAKING CHANGE: user response now includes additional metadata
```

or

```
feat(api)!: change authentication flow
```

### Prerequisites

- Execute within Git repository
- Uncommitted changes must exist
- Staged changes will be temporarily reset

### Notes

- **No Automatic Push**: Manual `git push` required after commits
- **No Branch Creation**: Commits on current branch
- **Backup Recommended**: Use `git stash` for backup before important changes

### Best Practices

1. **Respect Project Conventions**: Follow existing settings and patterns
2. **Small Change Units**: One logical change per commit
3. **Clear Messages**: Make changes clearly understandable
4. **Emphasize Relationships**: Group functionally related files
5. **Separate Tests**: Test files in separate commits
6. **Utilize Configuration Files**: Introduce CommitLint for team-wide convention unity

### Troubleshooting

#### When Commits Fail
- Check pre-commit hooks
- Resolve dependencies
- Retry with individual files

#### When Split is Inappropriate
- Adjust with `--max-commits` option
- Use manual `edit` mode
- Re-execute with finer granularity
