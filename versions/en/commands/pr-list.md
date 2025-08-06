## PR List

Display open pull requests list with priority ranking for the current repository.

### Usage

```bash
# Request to Claude
"Display open PR list with priority ranking"
```

### Basic Examples

```bash
# Get repository information
gh repo view --json nameWithOwner | jq -r '.nameWithOwner'

# Get open PR information and request to Claude
gh pr list --state open --draft=false --json number,title,author,createdAt,additions,deletions,reviews --limit 30

"Organize the above PRs by priority and include a 2-line summary for each PR. Generate URLs using the repository name obtained above"
```

### Display Format

```
Open PR List (Sorted by Priority)

### High Priority
#Number Title [Draft/DNM] | Author | Time Since Opened | Approved Count | +Additions/-Deletions
      ├─ Summary line 1
      └─ Summary line 2
      https://github.com/owner/repo/pull/number

### Medium Priority
(Same format)

### Low Priority
(Same format)
```

### Priority Criteria

**High Priority**

- `fix:` Bug fixes
- `release:` Release work

**Medium Priority**

- `feat:` New features
- `update:` Feature improvements
- Other regular PRs

**Low Priority**

- PRs containing DO NOT MERGE
- Draft PRs with `test:`, `build:`, `perf:`

### Important Notes

- GitHub CLI (`gh`) is required
- Only displays open PRs (excludes Drafts)
- Displays maximum 30 PRs
- Elapsed time is from when the PR was opened
- PR URLs are automatically generated from the actual repository name
