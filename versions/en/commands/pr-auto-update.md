## PR Auto Update

## Overview

A command that automatically updates Pull Request descriptions and labels. It analyzes Git changes and generates appropriate descriptions and labels.

## Usage

```bash
/pr-auto-update [options] [PR number]
```

### Options

- `--pr <number>` : Specify target PR number (auto-detect from current branch if omitted)
- `--description-only` : Update only description (don't change labels)
- `--labels-only` : Update only labels (don't change description)
- `--dry-run` : Display generated content without actual updates
- `--lang <language>` : Specify language (ja, en)

### Basic Examples

```bash
# Auto-update current branch PR
/pr-auto-update

# Update specific PR
/pr-auto-update --pr 1234

# Update description only
/pr-auto-update --description-only

# Dry run for confirmation
/pr-auto-update --dry-run
```

## Feature Details

### 1. Automatic PR Detection

Auto-detect corresponding PR from current branch:

```bash
# Search PR from branch
gh pr list --head $(git branch --show-current) --json number,title,url
```

### 2. Change Analysis

Collect and analyze the following information:

- **File changes**: Added, deleted, and modified files
- **Code analysis**: Changes in import statements, function definitions, class definitions
- **Tests**: Presence and content of test files
- **Documentation**: README and docs updates
- **Configuration**: Changes to package.json, pubspec.yaml, configuration files
- **CI/CD**: GitHub Actions and workflow changes

### 3. Automatic Description Generation

#### Template Processing Priority

1. **Existing PR description**: **Complete adherence** to already written content
2. **Project template**: Get structure from `.github/PULL_REQUEST_TEMPLATE.md`
3. **Default template**: Fallback when above doesn't exist

#### Existing Content Preservation Rules

**Important**: Don't change existing content
- Preserve written sections
- Supplement only empty sections
- Preserve functional comments (Copilot review rules, etc.)

#### Using Project Templates

```bash
# Analyze .github/PULL_REQUEST_TEMPLATE.md structure
parse_template_structure() {
    local template_file="$1"
    if [ -f "$template_file" ]; then
        # Extract section structure
        grep -E '^##|^###' "$template_file"
        # Identify comment placeholders
        grep -E '<!--.*-->' "$template_file"
        # Completely follow existing template structure
        cat "$template_file"
    fi
}
```

### 4. Automatic Label Setting

#### Label Acquisition Mechanism

**Priority order**:
1. **`.github/labels.yml`**: Get from project-specific label definitions
2. **GitHub API**: Get existing labels with `gh api repos/{OWNER}/{REPO}/labels --jq '.[].name'`

#### Automatic Determination Rules

**File pattern-based**:
- Documentation: `*.md`, `README`, `docs/` → Labels containing `documentation|docs|doc`
- Tests: `test`, `spec` → Labels containing `test|testing`
- CI/CD: `.github/`, `*.yml`, `Dockerfile` → Labels containing `ci|build|infra|ops`
- Dependencies: `package.json`, `pubspec.yaml`, `requirements.txt` → Labels containing `dependencies|deps`

**Change content-based**:
- Bug fixes: `fix|bug|error|crash` → Labels containing `bug|fix`
- New features: `feat|feature|add|implement` → Labels containing `feature|enhancement|feat`
- Refactoring: `refactor|clean` → Labels containing `refactor|cleanup|clean`
- Performance: `performance|perf|optimize` → Labels containing `performance|perf`
- Security: `security|secure` → Labels containing `security`

#### Constraints

- **Maximum 3**: Upper limit on automatically selected labels
- **Existing labels only**: Creating new labels is prohibited
- **Partial match**: Determined by whether label name contains keyword

#### Actual Usage Examples

**When `.github/labels.yml` exists**:
```bash
# Auto-get from label definitions
grep "^- name:" .github/labels.yml | sed "s/^- name: '\\?\\([^']*\\)'\\?/\\1/"
# Example: Use project-specific label system
```

**When getting from GitHub API**:
```bash
# Get list of existing labels
gh api repos/{OWNER}/{REPO}/labels --jq '.[].name'
# Example: Use standard labels like bug, enhancement, documentation, etc.
```

### 5. Execution Flow

```bash
#!/bin/bash

# 1. PR detection and retrieval
detect_pr() {
    if [ -n "$PR_NUMBER" ]; then
        echo $PR_NUMBER
    else
        gh pr list --head $(git branch --show-current) --json number --jq '.[0].number'
    fi
}

# 2. Change analysis
analyze_changes() {
    local pr_number=$1
    # Get file changes
    gh pr diff $pr_number --name-only
    # Content analysis
    gh pr diff $pr_number | head -1000
}

# 3. Description generation
generate_description() {
    local pr_number=$1
    local changes=$2
    
    # Get current PR description
    local current_body=$(gh pr view $pr_number --json body --jq -r .body)
    
    # Use as-is if existing content
    if [ -n "$current_body" ]; then
        echo "$current_body"
    else
        # Generate new from template
        local template_file=".github/PULL_REQUEST_TEMPLATE.md"
        if [ -f "$template_file" ]; then
            generate_from_template "$(cat "$template_file")" "$changes"
        else
            generate_from_template "" "$changes"
        fi
    fi
}

# Generate from template
generate_from_template() {
    local template="$1"
    local changes="$2"
    
    if [ -n "$template" ]; then
        # Use template as-is (preserve HTML comments)
        echo "$template"
    else
        # Generate in default format
        echo "## What does this change?"
        echo ""
        echo "$changes"
    fi
}

# 4. Label determination
determine_labels() {
    local changes=$1
    local file_list=$2
    local pr_number=$3
    
    # Get available labels
    local available_labels=()
    if [ -f ".github/labels.yml" ]; then
        # Extract label names from labels.yml
        available_labels=($(grep "^- name:" .github/labels.yml | sed "s/^- name: '\\?\\([^']*\\)'\\?/\\1/"))
    else
        # Get labels from GitHub API
        local repo_info=$(gh repo view --json owner,name)
        local owner=$(echo "$repo_info" | jq -r .owner.login)
        local repo=$(echo "$repo_info" | jq -r .name)
        available_labels=($(gh api "repos/$owner/$repo/labels" --jq '.[].name'))
    fi
    
    local suggested_labels=()
    
    # Generic pattern matching
    analyze_change_patterns "$file_list" "$changes" available_labels suggested_labels
    
    # Limit to maximum 3
    echo "${suggested_labels[@]:0:3}"
}

# Determine labels from change patterns
analyze_change_patterns() {
    local file_list="$1"
    local changes="$2"
    local -n available_ref=$3
    local -n suggested_ref=$4
    
    # Judgment by file type
    if echo "$file_list" | grep -q "\\.md$\\|README\\|docs/"; then
        add_matching_label "documentation\\|docs\\|doc" available_ref suggested_ref
    fi
    
    if echo "$file_list" | grep -q "test\\|spec"; then
        add_matching_label "test\\|testing" available_ref suggested_ref
    fi
    
    # Judgment by change content
    if echo "$changes" | grep -iq "fix\\|bug\\|error\\|crash"; then
        add_matching_label "bug\\|fix" available_ref suggested_ref
    fi
    
    if echo "$changes" | grep -iq "feat\\|feature\\|add\\|implement"; then
        add_matching_label "feature\\|enhancement\\|feat" available_ref suggested_ref
    fi
}

# Add matching label
add_matching_label() {
    local pattern="$1"
    local -n available_ref=$2
    local -n suggested_ref=$3
    
    # Skip if already 3
    if [ ${#suggested_ref[@]} -ge 3 ]; then
        return
    fi
    
    # Add first label matching pattern
    for available_label in "${available_ref[@]}"; do
        if echo "$available_label" | grep -iq "$pattern"; then
            # Check for duplicates
            local already_exists=false
            for existing in "${suggested_ref[@]}"; do
                if [ "$existing" = "$available_label" ]; then
                    already_exists=true
                    break
                fi
            done
            
            if [ "$already_exists" = false ]; then
                suggested_ref+=("$available_label")
                return
            fi
        fi
    done
}

# Keep old function for compatibility
find_and_add_label() {
    add_matching_label "$@"
}

# 5. PR update
update_pr() {
    local pr_number=$1
    local description="$2"
    local labels="$3"
    
    if [ "$DRY_RUN" = "true" ]; then
        echo "=== DRY RUN ==="
        echo "Description:"
        echo "$description"
        echo "Labels: $labels"
    else
        # Get repository info
        local repo_info=$(gh repo view --json owner,name)
        local owner=$(echo "$repo_info" | jq -r .owner.login)
        local repo=$(echo "$repo_info" | jq -r .name)
        
        # Update body using GitHub API (preserve HTML comments)
        # Properly handle JSON escaping
        local escaped_body=$(echo "$description" | jq -R -s .)
        gh api \
            --method PATCH \
            "/repos/$owner/$repo/pulls/$pr_number" \
            --field body="$description"
        
        # Labels usually work fine with gh command
        if [ -n "$labels" ]; then
            gh pr edit $pr_number --add-label "$labels"
        fi
    fi
}
```

## Configuration File (For Future Extensions)

`~/.claude/pr-auto-update.config`:
```json
{
  "language": "ja",
  "max_labels": 3
}
```

## Common Patterns

### Flutter Projects

```markdown
## What does this change?

Implemented {feature name}. Solves user's {problem}.

### Main Changes
- **UI Implementation**: Created new {screen name}
- **State Management**: Added Riverpod providers
- **API Integration**: Implemented GraphQL queries and mutations
- **Testing**: Added widget tests and unit tests

### Technical Specifications
- **Architecture**: {pattern used}
- **Dependencies**: {newly added packages}
- **Performance**: {optimization details}
```

### Node.js Projects

```markdown
## What does this change?

Implemented {API name} endpoint. Supports {use case}.

### Main Changes
- **API Implementation**: Created new {endpoint}
- **Validation**: Added request validation logic
- **Database**: Implemented operations for {table name}
- **Testing**: Added integration tests and unit tests

### Security
- **Authentication**: JWT token verification
- **Authorization**: Role-based access control
- **Input Validation**: SQL injection countermeasures
```

### CI/CD Improvements

```markdown
## What does this change?

Improved GitHub Actions workflow. Achieves {effect}.

### Improvements
- **Performance**: Reduced build time by {time}
- **Reliability**: Enhanced error handling
- **Security**: Improved secret management

### Technical Details
- **Parallelization**: Execute {job name} in parallel
- **Caching**: Optimized caching strategy for {cache target}
- **Monitoring**: Added monitoring for {metrics}
```

## Notes

1. **Complete preservation of existing content**:
   - **Don't change a single character** of already written content
   - Supplement only empty comment sections and placeholders
   - Respect content intentionally written by users

2. **Template priority**:
   - Existing PR description > `.github/PULL_REQUEST_TEMPLATE.md` > Default
   - Complete adherence to project-specific template structure

3. **Label constraints**:
   - Prioritize `.github/labels.yml` if it exists
   - Get existing labels from GitHub API if it doesn't exist
   - Creating new labels is prohibited
   - Maximum 3 auto-selected

4. **Safe updates**:
   - Recommend pre-confirmation with `--dry-run`
   - Display warnings for changes containing sensitive information
   - Save original description as backup

5. **Consistency maintenance**:
   - Match existing PR style of the project
   - Unify language (Japanese/English)
   - Inherit labeling rules

## Troubleshooting

### Common Issues

1. **PR not found**: Check branch name and PR association
2. **Permission errors**: Check GitHub CLI authentication status
3. **Cannot set labels**: Check repository permissions
4. **HTML comments get escaped**: GitHub CLI specification converts `<!-- -->` to `&lt;!-- --&gt;`

### GitHub CLI HTML Comment Escaping Issue

**Important**: GitHub CLI (`gh pr edit`) automatically escapes HTML comments. Also, shell redirect processing like `EOF < /dev/null` may introduce invalid strings.

#### Fundamental Solutions

1. **Use GitHub API --field option**: Use `--field` for proper escaping
2. **Simplify shell processing**: Avoid complex redirects and pipe processing
3. **Simplify template processing**: Abolish HTML comment removal processing, preserve completely
4. **Proper JSON escaping**: Handle special characters correctly

### Debug Options

```bash
# Detailed log output (to be added during implementation)
/pr-auto-update --verbose
```
