## AI Writing Check

Detects mechanical patterns in AI-generated text and provides suggestions for more natural writing.

### Usage

```bash
/ai-writing-check [options]
```

### Options

- None: Analyze current file or selected text
- `--file <path>`: Analyze specific file
- `--dir <path>`: Batch analyze files in directory
- `--severity <level>`: Detection level (all/high/medium)
- `--fix`: Auto-fix detected patterns

### Basic Examples

```bash
# Check file for AI-like patterns
cat README.md
/ai-writing-check
"Check this document for AI-like patterns and provide improvement suggestions"

# Analyze specific file
/ai-writing-check --file docs/guide.md
"Detect AI-like expressions and suggest natural alternatives"

# Scan entire project
/ai-writing-check --dir . --severity high
"Report only critical AI-like issues in the project"
```

### Detection Patterns

#### 1. Mechanical List Formatting

```markdown
Detected patterns:
- **Important**: This is an important item
- ✅ Completed item (with checkmark)
- 🔥 Hot topic (with fire emoji)
- 🚀 Ready to start (with rocket emoji)

Improved version:
- Important item: This is an important item
- Completed item
- Notable topic
- Ready to start
```

#### 2. Hyperbolic and Hype Expressions

```markdown
Detected patterns:
Revolutionary technology that transforms the industry.
This completely solves all problems.
Works like magic.

Improved version:
Effective technology that brings change to the industry.
Solves many problems.
Works smoothly.
```

#### 3. Mechanical Emphasis Patterns

```markdown
Detected patterns:
**💡 Idea**: New proposal here (with lightbulb emoji)
**⚠️ Warning**: Important notice (with warning emoji)

Improved version:
Idea: New proposal here
Note: Important notice
```

#### 4. Redundant Technical Writing

```markdown
Detected patterns:
First, start by configuring the settings.
You can utilize this tool to accomplish tasks.
Significantly improves performance.

Improved version:
Configure the settings.
Use this tool to accomplish tasks.
Improves performance by 30%.
```

### Claude Integration

```bash
# Analyze entire document for AI patterns
cat article.md
/ai-writing-check
"Analyze from these perspectives and provide improvements:
1. Detect mechanical expressions
2. Suggest natural alternatives
3. Priority-sorted improvement list"

# Focus on specific patterns
/ai-writing-check --file blog.md
"Focus especially on hyperbolic and redundant expressions"

# Batch check multiple files
find . -name "*.md" -type f
/ai-writing-check --dir docs/
"Analyze AI patterns across all documentation and create summary"
```

### Detailed Examples

```bash
# Before/after comparison
/ai-writing-check --file draft.md
"Detect AI-like expressions and present in this format:
- Problem locations (with line numbers)
- Type and reason for issue
- Specific improvement suggestions
- Expected impact of changes"

# Auto-fix mode
/ai-writing-check --file report.md --fix
"Auto-fix detected patterns and report results"

# Project-wide AI pattern report
/ai-writing-check --dir . --severity all
"Analyze project-wide AI patterns:
1. Statistics (detection count by pattern type)
2. Top 5 most problematic files
3. Improvement priority matrix
4. Phased improvement plan"
```

### Advanced Usage

```bash
# Apply custom rules
/ai-writing-check --file spec.md
"Check as technical specification with additional criteria:
- Vague expressions (appropriate, as needed)
- Lack of specificity (fast → specific metrics)
- Inconsistent terminology"

# CI/CD integration check
/ai-writing-check --dir docs/ --severity high
"Output results in GitHub Actions compatible format:
- Error count and filenames
- Line numbers needing fixes
- Exit code setting"

# Style guide compliance check
/ai-writing-check --file manual.md
"Additional checks based on company style guide:
- Consistent tone (formal/informal)
- Appropriate technical terminology
- Reader consideration"
```

### Notes

- AI pattern detection varies by context; treat suggestions as recommendations
- Adjust criteria based on document type (technical docs, blogs, manuals, etc.)
- Not all suggestions need to be accepted; select appropriate ones
- `--fix` option automatically corrects detected patterns

### Command Execution Behavior

When executing `/ai-writing-check`, Claude performs:

1. **Pattern Detection**: Detects AI-like patterns in specified files or text
2. **Specific Suggestions**: Provides fixes with line numbers for each issue
3. **--fix Mode**: Auto-corrects patterns and displays result summary
4. **Report Generation**: Provides detection counts, improvement priorities, before/after comparisons

Claude reads actual file contents and analyzes based on textlint-rule-preset-ai-writing rules.

### Reference

This command is based on the [textlint-rule-preset-ai-writing](https://github.com/textlint-ja/textlint-rule-preset-ai-writing) ruleset, which detects mechanical patterns in AI-generated text and promotes more natural expression.
