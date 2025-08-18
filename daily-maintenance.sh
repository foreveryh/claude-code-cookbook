#!/bin/bash

# Claude Code Cookbook Daily Maintenance
# 日常维护脚本 - 简化的上游更新检查和同步
# Version: 1.0.0

set -euo pipefail

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🔄 Claude Code Cookbook 日常维护${NC}"
echo "=================================="

# 检查上游更新
echo -e "${BLUE}📡 检查上游更新...${NC}"
if ./utils/sync-upstream.sh check; then
    echo ""
    echo -e "${YELLOW}发现上游更新！${NC}"
    echo ""
    echo "选择操作："
    echo "1) 🚀 立即同步 (推荐)"
    echo "2) 🔍 预览同步内容"
    echo "3) 📊 查看项目状态"
    echo "4) ❌ 跳过"
    echo ""
    read -p "请选择 (1-4): " choice
    
    case $choice in
        1)
            echo -e "${GREEN}🚀 开始同步...${NC}"
            ./utils/workflow-manager.sh sync
            echo ""
            echo -e "${GREEN}✅ 同步完成！建议测试安装：${NC}"
            echo "   ./install.sh --lang en --dry-run"
            ;;
        2)
            echo -e "${BLUE}🔍 预览同步内容...${NC}"
            ./utils/workflow-manager.sh sync --dry-run
            ;;
        3)
            echo -e "${BLUE}📊 项目状态概览...${NC}"
            ./utils/workflow-manager.sh status
            ;;
        4)
            echo -e "${YELLOW}⏭️ 跳过同步${NC}"
            ;;
        *)
            echo "无效选择"
            ;;
    esac
else
    echo -e "${GREEN}✅ 项目已是最新状态${NC}"
    
    # 显示项目状态
    echo ""
    echo -e "${BLUE}📊 当前项目状态：${NC}"
    python3 utils/translate-content.py status
fi

echo ""
echo -e "${CYAN}维护完成！${NC}"