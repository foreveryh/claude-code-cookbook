# Basic Usage Guide

> **Navigation:** [Previous: Installation Guide](02-installation-guide.md) | [Next: Architecture Overview](04-architecture-overview.md) | [Documentation Index](README.md)

## Quick Reference

```bash
# Essential Commands in Claude Desktop
/help                    # Show available commands
/role-help              # Show available roles
/explain-code           # Explain selected code
/pr-create-smart        # Create smart PR description
/semantic-commit        # Generate semantic commit message

# Essential Roles
/role architect         # Software architecture expert
/role security          # Security analysis expert
/role reviewer          # Code review expert
```

## Overview

This guide covers the essential usage patterns for Claude Code Cookbook. After installation, you'll have access to 42+ custom commands and 8 expert roles that enhance your development workflow.

## Core Concepts

### Commands
Commands start with `/` and provide specialized functionality:
- **Code Analysis**: `/explain-code`, `/analyze-dependencies`
- **Development**: `/refactor`, `/fix-error`, `/design-patterns`
- **Git/PR**: `/pr-create-smart`, `/semantic-commit`, `/pr-review`
- **Documentation**: `/update-doc-string`, `/update-dart-doc`

### Roles
Roles transform Claude into domain experts:
- **Architecture**: `/role architect` - System design and patterns
- **Security**: `/role security` - Security analysis and best practices
- **Performance**: `/role performance` - Optimization and profiling
- **QA**: `/role qa` - Testing strategies and quality assurance

### Hooks
Automated scripts that enhance your workflow:
- **Auto-formatting**: Formats code on save
- **Commit validation**: Checks commit messages
- **Notification system**: Desktop notifications for tasks

## Essential Commands

### Code Understanding
```bash
# Explain any code snippet
/explain-code
# Select code in your editor, then use this command
# Claude will provide detailed explanations

# Analyze project dependencies
/analyze-dependencies
# Shows dependency relationships and potential issues

# Check code for potential issues
/check-fact
# Validates code against project context
```

### Development Workflow
```bash
# Refactor code safely
/refactor
# Provides step-by-step refactoring suggestions

# Fix errors intelligently
/fix-error
# Analyzes error messages and suggests solutions

# Apply design patterns
/design-patterns
# Suggests appropriate patterns for your code
```

### Git and PR Management
```bash
# Create intelligent PR descriptions
/pr-create-smart
# Analyzes your changes and creates comprehensive PR descriptions

# Generate semantic commit messages
/semantic-commit
# Creates conventional commit messages based on your changes

# Review pull requests
/pr-review
# Provides systematic code review with best practices
```

### Documentation
```bash
# Update documentation strings
/update-doc-string
# Generates or improves code documentation

# Update project documentation
/update-dart-doc
# Specialized for Dart/Flutter projects
```

## Expert Roles

### Architecture Expert
```bash
/role architect

# Now Claude becomes a software architect
# Ask questions like:
# - "How should I structure this microservice?"
# - "What design patterns fit this use case?"
# - "How can I improve this system's scalability?"
```

### Security Expert
```bash
/role security

# Claude becomes a security specialist
# Ask questions like:
# - "Are there security vulnerabilities in this code?"
# - "How should I implement authentication?"
# - "What are the security implications of this design?"
```

### Performance Expert
```bash
/role performance

# Claude becomes a performance optimization expert
# Ask questions like:
# - "How can I optimize this algorithm?"
# - "What are the performance bottlenecks?"
# - "How should I profile this application?"
```

### Code Review Expert
```bash
/role reviewer

# Claude becomes a code review specialist
# Ask questions like:
# - "Please review this pull request"
# - "What improvements can be made to this code?"
# - "Are there any code quality issues?"
```

## Common Workflows

### Daily Development Workflow

#### 1. Morning Setup
```bash
# Check project status
/check-fact "What's the current state of the project?"

# Review recent changes
/pr-list
```

#### 2. Feature Development
```bash
# Plan implementation
/plan "Implement user authentication system"

# Get architectural guidance
/role architect
# Ask: "How should I structure the authentication system?"

# Implement with help
/explain-code  # For understanding existing code
/refactor      # For improving code structure
```

#### 3. Code Review and Commit
```bash
# Review your changes
/role reviewer
# Ask: "Please review my changes"

# Create commit message
/semantic-commit

# Create PR description
/pr-create-smart
```

### Debugging Workflow

#### 1. Error Analysis
```bash
# Analyze error messages
/fix-error
# Paste the error message and get solutions

# Check dependencies
/analyze-dependencies
# Look for version conflicts or missing dependencies
```

#### 2. Performance Investigation
```bash
# Switch to performance expert
/role performance
# Ask: "How can I optimize this slow function?"

# Analyze performance patterns
/analyze-performance
```

### Documentation Workflow

#### 1. Code Documentation
```bash
# Update function documentation
/update-doc-string
# Select function and generate/improve documentation

# Explain complex code
/explain-code
# Generate explanations for complex algorithms
```

#### 2. Project Documentation
```bash
# Update README or docs
/role architect
# Ask: "How should I document this system architecture?"
```

## Advanced Usage Patterns

### Multi-Role Discussions
```bash
# Get multiple expert perspectives
/multi-role "security,performance,architect" "Review this API design"

# This engages multiple experts simultaneously
```

### Role Debates
```bash
# Have experts debate approaches
/role-debate "security vs performance" "Should we cache user sessions?"

# Watch security and performance experts discuss trade-offs
```

### Context-Aware Analysis
```bash
# Use project context for better analysis
/context7 "Analyze this component in the context of our microservices architecture"

# Provides analysis considering your specific project context
```

## Customization

### Personal Preferences
You can customize command behavior by editing `~/.claude/settings.json`:

```json
{
  "preferences": {
    "defaultRole": "architect",
    "verboseExplanations": true,
    "autoFormatCode": true
  }
}
```

### Hook Configuration
Customize automated behaviors in the hooks section:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/scripts/auto-comment.sh"
          }
        ]
      }
    ]
  }
}
```

## Tips and Best Practices

### Effective Command Usage
1. **Be Specific**: Provide context when using commands
2. **Use Roles**: Switch to appropriate expert roles for domain-specific questions
3. **Combine Commands**: Use multiple commands in sequence for complex tasks
4. **Provide Context**: Include relevant code or project information

### Role Management
1. **Switch Roles**: Use `/role [name]` to change expert context
2. **Reset Context**: Use `/role` without parameters to return to general mode
3. **Role Help**: Use `/role-help` to see all available roles

### Workflow Integration
1. **Daily Routine**: Incorporate commands into your daily development routine
2. **Team Usage**: Share useful command patterns with your team
3. **Documentation**: Document your team's preferred command workflows

## Troubleshooting Common Issues

### Commands Not Working
```bash
# Check if commands are loaded
ls ~/.claude/commands/ | grep -E "(explain-code|pr-create)"

# Restart Claude Desktop
# Check Custom Instructions path in settings
```

### Roles Not Responding Correctly
```bash
# Verify role files exist
ls ~/.claude/agents/roles/

# Check role syntax
cat ~/.claude/agents/roles/architect.md
```

### Performance Issues
```bash
# Check hook configuration
cat ~/.claude/settings.json | grep -A 10 "hooks"

# Disable heavy hooks temporarily
# Edit settings.json and comment out slow hooks
```

## Next Steps

### For Continued Learning
1. **[Architecture Overview](04-architecture-overview.md)** - Understand the system design
2. **[Maintenance Tools](05-maintenance-tools.md)** - Learn automation tools
3. **[Advanced Configuration](90-advanced-configuration.md)** - Customize for your needs

### For Team Usage
1. **[Contributing Guide](91-contributing.md)** - Add your own commands
2. **[Translation Management](07-translation-management.md)** - Support multiple languages
3. **[Workflow Automation](09-workflow-automation.md)** - Set up team automation

## Getting Help

- **Command Issues**: Check [Troubleshooting Guide](10-troubleshooting.md)
- **Role Problems**: See [Complete Reference](99-reference.md)
- **Advanced Usage**: Read [Advanced Configuration](90-advanced-configuration.md)

---

**Ready to understand the architecture?** Continue to **[Architecture Overview](04-architecture-overview.md)** to learn how the system works.

> **Navigation:** [Previous: Installation Guide](02-installation-guide.md) | [Next: Architecture Overview](04-architecture-overview.md) | [Documentation Index](README.md)