#!/bin/bash

# Batch translation processor for commands and roles
# This script helps track translation progress

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EN_COMMANDS="$PROJECT_ROOT/versions/en/commands"
EN_ROLES="$PROJECT_ROOT/versions/en/agents/roles"

# Track translation status
echo "Translation Status Report"
echo "========================"
echo ""

# Commands to translate (in priority order)
PRIORITY_COMMANDS=(
    "pr-create.md"
    "pr-review.md"
    "pr-feedback.md"
    "fix-error.md"
    "refactor.md"
    "smart-review.md"
    "commit-message.md"
    "semantic-commit.md"
    "analyze-performance.md"
    "tech-debt.md"
    "explain-code.md"
    "plan.md"
    "spec.md"
    "role.md"
    "role-help.md"
)

OTHER_COMMANDS=(
    "analyze-dependencies.md"
    "check-fact.md"
    "check-github-ci.md"
    "check-prompt.md"
    "context7.md"
    "design-patterns.md"
    "multi-role.md"
    "pr-auto-update.md"
    "pr-issue.md"
    "pr-list.md"
    "role-debate.md"
    "screenshot.md"
    "search-gemini.md"
    "sequential-thinking.md"
    "show-plan.md"
    "style-ai-writting.md"
    "task.md"
    "ultrathink.md"
    "update-dart-doc.md"
    "update-doc-string.md"
    "update-flutter-deps.md"
    "update-node-deps.md"
    "update-rust-deps.md"
)

# Roles to translate
ROLES=(
    "analyzer.md"
    "architect.md"
    "frontend.md"
    "mobile.md"
    "performance.md"
    "qa.md"
    "reviewer.md"
    "security.md"
)

echo "Priority Commands (${#PRIORITY_COMMANDS[@]} files):"
for cmd in "${PRIORITY_COMMANDS[@]}"; do
    if grep -q '[ぁ-んァ-ヶー一-龯]' "$EN_COMMANDS/$cmd" 2>/dev/null; then
        echo "  ❌ $cmd - Needs translation"
    else
        echo "  ✅ $cmd - Translated"
    fi
done

echo ""
echo "Other Commands (${#OTHER_COMMANDS[@]} files):"
for cmd in "${OTHER_COMMANDS[@]}"; do
    if grep -q '[ぁ-んァ-ヶー一-龯]' "$EN_COMMANDS/$cmd" 2>/dev/null; then
        echo "  ❌ $cmd - Needs translation"
    else
        echo "  ✅ $cmd - Translated"
    fi
done

echo ""
echo "Roles (${#ROLES[@]} files):"
for role in "${ROLES[@]}"; do
    if grep -q '[ぁ-んァ-ヶー一-龯]' "$EN_ROLES/$role" 2>/dev/null; then
        echo "  ❌ $role - Needs translation"
    else
        echo "  ✅ $role - Translated"
    fi
done

# Count totals
TOTAL_FILES=$((${#PRIORITY_COMMANDS[@]} + ${#OTHER_COMMANDS[@]} + ${#ROLES[@]}))
TRANSLATED=0

for file in "$EN_COMMANDS"/*.md "$EN_ROLES"/*.md; do
    if [[ -f "$file" ]]; then
        if ! grep -q '[ぁ-んァ-ヶー一-龯]' "$file" 2>/dev/null; then
            TRANSLATED=$((TRANSLATED + 1))
        fi
    fi
done

echo ""
echo "========================"
echo "Summary:"
echo "  Total files: $TOTAL_FILES"
echo "  Translated: $TRANSLATED"
echo "  Remaining: $((TOTAL_FILES - TRANSLATED))"
echo "  Progress: $(( TRANSLATED * 100 / TOTAL_FILES ))%"
