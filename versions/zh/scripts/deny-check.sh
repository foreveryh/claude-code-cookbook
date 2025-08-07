#!/bin/bash

# 读取 JSON 输入，提取命令和工具名
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null || echo "")
tool_name=$(echo "$input" | jq -r '.tool_name' 2>/dev/null || echo "")

# 仅检查 Bash 命令
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# 从 settings.json 读取拒绝模式
settings_file="$HOME/.claude/settings.json"

# 获取所有 Bash 命令的拒绝模式
deny_patterns=$(jq -r '.permissions.deny[] | select(startswith("Bash(")) | gsub("^Bash\\("; "") | gsub("\\)$"; "")' "$settings_file" 2>/dev/null)

# 检查命令是否匹配拒绝模式的函数
matches_deny_pattern() {
  local cmd="$1"
  local pattern="$2"

  # 删除开头和结尾的空格
  cmd="${cmd#"${cmd%%[![:space:]]*}"}" # 删除开头的空格
  cmd="${cmd%"${cmd##*[![:space:]]}"}" # 删除结尾的空格

  # glob 模式匹配（支持通配符）
  [[ "$cmd" == $pattern ]]
}

# 首先检查整个命令
while IFS= read -r pattern; do
  # 跳过空行
  [ -z "$pattern" ] && continue

  # 检查整个命令是否匹配模式
  if matches_deny_pattern "$command" "$pattern"; then
    echo "Error: 命令被拒绝: '$command' (模式: '$pattern')" >&2
    exit 2
  fi
done <<<"$deny_patterns"

# 使用逻辑运算符分割命令，并检查各部分
# 用分号、&& 和 || 分割（不分割管道 | 和单个 &）
temp_command="${command//;/$'\n'}"
temp_command="${temp_command//&&/$'\n'}"
temp_command="${temp_command//\|\|/$'\n'}"

IFS=$'\n'
for cmd_part in $temp_command; do
  # 跳过空部分
  [ -z "$(echo "$cmd_part" | tr -d '[:space:]')" ] && continue

  # 针对每个拒绝模式进行检查
  while IFS= read -r pattern; do
    # 跳过空行
    [ -z "$pattern" ] && continue

    # 检查这个命令部分是否匹配模式
    if matches_deny_pattern "$cmd_part" "$pattern"; then
      echo "Error: 命令被拒绝: '$cmd_part' (模式: '$pattern')" >&2
      exit 2
    fi
  done <<<"$deny_patterns"
done

# 允许命令
exit 0
