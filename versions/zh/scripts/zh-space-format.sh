#!/bin/bash
set -euo pipefail

# 中文与半角英数字之间插入半角空格

# 获取文件路径
if [ -n "${1:-}" ]; then
  file_path="$1"
else
  file_path=$(jq -r '.tool_input.file_path // empty' <<<"${CLAUDE_TOOL_INPUT:-$(cat)}")
fi

# 基本检查
[ -z "$file_path" ] || [ ! -f "$file_path" ] || [ ! -r "$file_path" ] || [ ! -w "$file_path" ] && exit 0

# 排除列表
EXCLUSIONS_FILE="$(dirname "${BASH_SOURCE[0]}")/zh-space-exclusions.json"

# 使用临时文件处理
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

# 基本的空格插入（中文字符范围）
sed -E \
  -e 's/([一-鿿])([a-zA-Z0-9])/\1 \2/g' \
  -e 's/([a-zA-Z0-9])([一-鿿])/\1 \2/g' \
  -e 's/([一-鿿])(\()/\1 \2/g' \
  -e 's/(\))([一-鿿])/\1 \2/g' \
  -e 's/(\))([a-zA-Z0-9])/\1 \2/g' \
  -e 's/\$\(([^)]*)\) ([0-9])/\$(\1)\2/g' \
  -e 's/(%)([一-鿿])/\1 \2/g' \
  -e 's/([（(\[{][^）)\]}]*[）)\]}])\s+(的|和|在|是|了|不|有)/\1\2/g' \
  "$file_path" >"$temp_file"

# 应用排除列表
if [ -f "$EXCLUSIONS_FILE" ] && command -v jq >/dev/null 2>&1; then
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    escaped="${pattern//[\[\\^$()|*+?{]/\\&}"
    spaced=$(sed -E 's/([一-鿿])([a-zA-Z0-9])/\1 \2/g; s/([a-zA-Z0-9])([一-鿿])/\1 \2/g' <<<"$escaped")
    sed -i '' "s/$spaced/$pattern/g" "$temp_file"
  done < <(jq -r '.exclusions[]' "$EXCLUSIONS_FILE" 2>/dev/null)
fi

mv "$temp_file" "$file_path"
