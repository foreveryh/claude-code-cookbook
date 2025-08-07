#!/bin/bash

# Simple continuation check
# If there's no completion phrase, prompt to continue work
#
# The completion phrase is defined in CLAUDE.md
# Details: See "Work Completion Reporting Rules" in ~/.claude/CLAUDE.md

COMPLETION_PHRASE="May the Force be with you."

# Stop hook から渡される JSON を読み取り
input_json=$(cat)

# transcript_path を抽出
transcript_path=$(echo "$input_json" | jq -r '.transcript_path // empty')

if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # Get the entire last message (including error messages)
  last_entry=$(tail -n 1 "$transcript_path")

  # For debugging (enable if needed)
  # echo "Debug: last_entry=$last_entry" >&2

  # Get assistant message text
  last_message=$(echo "$last_entry" | jq -r '.message.content[0].text // empty' 2>/dev/null || echo "")

  # Check various error field possibilities
  error_message=$(echo "$last_entry" | jq -r '.message.error // .error // empty' 2>/dev/null || echo "")

  # Stringify entire message for checking (regardless of JSON structure)
  full_entry_text=$(echo "$last_entry" | jq -r '.' 2>/dev/null || echo "$last_entry")

  # Check for Claude usage limit reached (multiple methods)
  if echo "$error_message" | grep -qi "usage limit" ||
    echo "$last_message" | grep -qi "usage limit" ||
    echo "$full_entry_text" | grep -qi "usage limit"; then
    # For usage limit errors, do nothing (normal exit)
    exit 0
  fi

  # Detect other error patterns
  if echo "$error_message" | grep -qi "network error\|timeout\|connection refused" ||
    echo "$full_entry_text" | grep -qi "network error\|timeout\|connection refused"; then
    # For network errors, do nothing (normal exit)
    exit 0
  fi

  # Detect /compact related patterns (treat as error messages)
  if echo "$error_message" | grep -qi "Context low.*Run /compact to compact" ||
    echo "$full_entry_text" | grep -qi "Context low.*Run /compact to compact"; then
    # For /compact related messages, do nothing (normal exit)
    exit 0
  fi

  # Detect Stop hook feedback repetition patterns
  if echo "$last_message" | grep -qi "Stop hook feedback" &&
    echo "$last_message" | grep -qi "Please continue with your work"; then
    # For Stop hook feedback repetition patterns, do nothing (normal exit)
    exit 0
  fi

  # Check plan presentation patterns (fix: continue if approved)
  if echo "$last_message" | grep -qi "User approved Claude's plan" ||
    echo "$full_entry_text" | grep -qi "User approved Claude's plan"; then
    # Plan approved → Continue work (don't block)
    exit 0
  fi

  # When asking for y/n confirmation
  if echo "$last_message" | grep -qi "y/n" ||
    echo "$full_entry_text" | grep -qi "y/n"; then
    # Awaiting confirmation → Continue work (don't block)
    exit 0
  fi

  # Check /spec related work patterns
  if echo "$last_message" | grep -qi "spec" ||
    echo "$last_message" | grep -qi "spec-driven" ||
    echo "$last_message" | grep -qi "requirements\.md\\|design\.md\\|tasks\.md"; then
    # During /spec related work, don't prompt to continue (normal exit)
    exit 0
  fi

  # Check for completion phrase
  if echo "$last_message" | grep -q "$COMPLETION_PHRASE"; then
    # If completion phrase is present, do nothing (normal exit)
    exit 0
  fi
fi

# If no completion phrase, prompt to continue
cat <<EOF
{
  "decision": "block",
  "reason": "Please continue with your work.\n  If there's no more work to do, output \`$COMPLETION_PHRASE\` to end."
}
EOF
