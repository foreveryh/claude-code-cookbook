#!/bin/bash

# 简单的继续检查
# 如果没有暗号就提示「请继续工作」
#
# 暗号是在 CLAUDE.md 中定义的完成时的固定用语
# 详情: ~/.claude/CLAUDE.md 的「工作完成报告规则」

COMPLETION_PHRASE="May the Force be with you."

# 从 Stop hook 传递的 JSON 读取
input_json=$(cat)

# 提取 transcript_path
transcript_path=$(echo "$input_json" | jq -r '.transcript_path // empty')

if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # 获取最后一条完整消息（包括错误消息）
  last_entry=$(tail -n 1 "$transcript_path")

  # 调试用（根据需要启用）
  # echo "Debug: last_entry=$last_entry" >&2

  # 获取助手消息的文本
  last_message=$(echo "$last_entry" | jq -r '.message.content[0].text // empty' 2>/dev/null || echo "")

  # 检查错误字段的各种可能性
  error_message=$(echo "$last_entry" | jq -r '.message.error // .error // empty' 2>/dev/null || echo "")

  # 将整个消息字符串化并检查（无论 JSON 结构如何）
  full_entry_text=$(echo "$last_entry" | jq -r '.' 2>/dev/null || echo "$last_entry")

  # Claude usage limit reached 的检查（多种方法）
  if echo "$error_message" | grep -qi "usage limit" ||
    echo "$last_message" | grep -qi "usage limit" ||
    echo "$full_entry_text" | grep -qi "usage limit"; then
    # Usage limit 错误时不执行任何操作（正常结束）
    exit 0
  fi

  # 其他错误模式的检测
  if echo "$error_message" | grep -qi "network error\|timeout\|connection refused" ||
    echo "$full_entry_text" | grep -qi "network error\|timeout\|connection refused"; then
    # 网络错误时不执行任何操作（正常结束）
    exit 0
  fi

  # /compact 相关模式的检测（作为错误消息处理）
  if echo "$error_message" | grep -qi "Context low.*Run /compact to compact" ||
    echo "$full_entry_text" | grep -qi "Context low.*Run /compact to compact"; then
    # /compact 相关消息时不执行任何操作（正常结束）
    exit 0
  fi

  # Stop hook feedback 的重复模式检测
  if echo "$last_message" | grep -qi "Stop hook feedback" &&
    echo "$last_message" | grep -qi "请继续工作"; then
    # Stop hook feedback 的重复模式时不执行任何操作（正常结束）
    exit 0
  fi

  # 计划提示相关的模式检查（修正：已批准的情况下继续）
  if echo "$last_message" | grep -qi "User approved Claude's plan" ||
    echo "$full_entry_text" | grep -qi "User approved Claude's plan"; then
    # 计划已批准 → 继续工作（不阻止）
    exit 0
  fi

  # 请求 y/n 确认的情况
  if echo "$last_message" | grep -qi "y/n" ||
    echo "$full_entry_text" | grep -qi "y/n"; then
    # 计划已批准 → 继续工作（不阻止）
    exit 0
  fi

  # /spec 相关的工作模式检查
  if echo "$last_message" | grep -qi "spec" ||
    echo "$last_message" | grep -qi "spec-driven" ||
    echo "$last_message" | grep -qi "requirements\.md\|design\.md\|tasks\.md"; then
    # /spec 相关工作中不提示继续（正常结束）
    exit 0
  fi

  # 暗号检查
  if echo "$last_message" | grep -q "$COMPLETION_PHRASE"; then
    # 有暗号则不执行任何操作（正常结束）
    exit 0
  fi
fi

# 没有暗号则提示继续
cat <<EOF
{
  "decision": "block",
  "reason": "请继续工作。\n  如果没有需要继续的工作，请输出 \`$COMPLETION_PHRASE\` 并结束。"
}
EOF
