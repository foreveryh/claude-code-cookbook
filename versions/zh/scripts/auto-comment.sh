#!/bin/bash
# 基于触发器的注释检查

input="$CLAUDE_TOOL_INPUT"
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] || [ ! -f "$file_path" ] && exit 0

# 仅在创建新文件时检查
if echo "$input" | jq -e '.tool == "Write"' >/dev/null; then
  jq -n '{decision: "block", reason: "已创建新文件。如果是代码文件，请考虑添加适当的 docstring（函数、类、模块级别的 API 文档）。"}'
fi

# 仅在大幅编辑时（使用 MultiEdit 时）检查
if echo "$input" | jq -e '.tool == "MultiEdit"' >/dev/null; then
  jq -n '{decision: "block", reason: "已执行多项编辑。请确认是否需要根据更改更新 docstring 或 API 文档。"}'
fi
