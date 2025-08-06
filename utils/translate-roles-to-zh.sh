#!/bin/bash

# 批量翻译角色文件到中文

# 定义源目录和目标目录
SOURCE_DIR="versions/ja/agents/roles"
TARGET_DIR="versions/zh/agents/roles"

# 确保目标目录存在
mkdir -p "$TARGET_DIR"

# 获取所有需要翻译的角色文件
ROLES=("analyzer" "frontend" "mobile" "performance" "qa" "reviewer" "security")

echo "开始批量翻译角色文件..."

for role in "${ROLES[@]}"; do
    if [ -f "$SOURCE_DIR/$role.md" ]; then
        echo "正在处理: $role.md"
        
        # 这里应该调用翻译API或手动处理
        # 为了演示，我们先复制文件
        cp "$SOURCE_DIR/$role.md" "$TARGET_DIR/$role.md.tmp"
        
        echo "  - 已创建临时文件: $TARGET_DIR/$role.md.tmp"
    else
        echo "警告: 找不到源文件 $SOURCE_DIR/$role.md"
    fi
done

echo "批量处理完成！"
echo "提示：临时文件需要手动翻译或使用翻译工具处理。"
