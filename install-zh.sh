#!/bin/bash

# Claude Code Cookbook 中文版安装脚本
# 作者：Claude Code Cookbook 团队
# 版本：1.0.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印彩色消息
print_color() {
    echo -e "${2}${1}${NC}"
}

# 打印标题
print_header() {
    echo ""
    print_color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$BLUE"
    print_color "  Claude Code Cookbook 中文版安装程序" "$BLUE"
    print_color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$BLUE"
    echo ""
}

# 检查依赖
check_dependencies() {
    print_color "🔍 检查系统依赖..." "$YELLOW"
    
    # 检查 Git
    if ! command -v git &> /dev/null; then
        print_color "❌ Git 未安装。请先安装 Git。" "$RED"
        exit 1
    fi
    print_color "✅ Git 已安装" "$GREEN"
    
    # 检查 Claude Desktop (可选)
    if [ -d "$HOME/Library/Application Support/Claude" ]; then
        print_color "✅ 检测到 Claude Desktop" "$GREEN"
        CLAUDE_INSTALLED=true
    else
        print_color "⚠️  未检测到 Claude Desktop（可选）" "$YELLOW"
        CLAUDE_INSTALLED=false
    fi
}

# 选择安装目录
select_install_dir() {
    print_color "\n📁 选择安装目录..." "$YELLOW"
    
    DEFAULT_DIR="$HOME/claude-code-cookbook"
    read -p "安装目录 (默认: $DEFAULT_DIR): " INSTALL_DIR
    INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_DIR}
    
    if [ -d "$INSTALL_DIR" ]; then
        print_color "⚠️  目录已存在: $INSTALL_DIR" "$YELLOW"
        read -p "是否覆盖? (y/n): " OVERWRITE
        if [ "$OVERWRITE" != "y" ]; then
            print_color "❌ 安装已取消" "$RED"
            exit 1
        fi
        rm -rf "$INSTALL_DIR"
    fi
    
    print_color "✅ 安装目录: $INSTALL_DIR" "$GREEN"
}

# 克隆仓库
clone_repository() {
    print_color "\n📥 克隆仓库..." "$YELLOW"
    
    git clone https://github.com/mustvlad/claude-code-cookbook.git "$INSTALL_DIR"
    
    if [ $? -eq 0 ]; then
        print_color "✅ 仓库克隆成功" "$GREEN"
    else
        print_color "❌ 克隆失败。请检查网络连接。" "$RED"
        exit 1
    fi
}

# 设置中文版本
setup_chinese_version() {
    print_color "\n🌏 配置中文版本..." "$YELLOW"
    
    cd "$INSTALL_DIR"
    
    # 创建中文版本的符号链接
    if [ -d "versions/zh" ]; then
        ln -sf versions/zh/commands commands_zh
        ln -sf versions/zh/agents agents_zh
        ln -sf versions/zh/scripts scripts_zh
        print_color "✅ 中文版本已配置" "$GREEN"
    else
        print_color "⚠️  中文版本目录不存在，将使用默认版本" "$YELLOW"
    fi
    
    # 创建配置文件
    cat > .cookbook-config <<EOF
# Claude Code Cookbook 配置文件
LANGUAGE=zh-CN
VERSION=1.0.0
INSTALL_DIR=$INSTALL_DIR
INSTALL_DATE=$(date +%Y-%m-%d)
EOF
    
    print_color "✅ 配置文件已创建" "$GREEN"
}

# 配置 Claude Desktop
configure_claude_desktop() {
    if [ "$CLAUDE_INSTALLED" = true ]; then
        print_color "\n⚙️  配置 Claude Desktop..." "$YELLOW"
        
        CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
        
        # 备份现有配置
        if [ -f "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" ]; then
            cp "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" "$CLAUDE_CONFIG_DIR/claude_desktop_config.json.backup"
            print_color "✅ 已备份现有配置" "$GREEN"
        fi
        
        # 创建 MCP 服务器配置
        cat > "$CLAUDE_CONFIG_DIR/mcp_cookbook_zh.json" <<EOF
{
  "mcpServers": {
    "claude-code-cookbook-zh": {
      "command": "node",
      "args": ["$INSTALL_DIR/versions/zh/.mcp.json"],
      "env": {
        "COOKBOOK_LANG": "zh-CN"
      }
    }
  }
}
EOF
        
        print_color "✅ Claude Desktop 配置完成" "$GREEN"
    fi
}

# 创建快捷命令
create_shortcuts() {
    print_color "\n🔗 创建快捷命令..." "$YELLOW"
    
    # 添加到 shell 配置文件
    SHELL_CONFIG=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    
    if [ -n "$SHELL_CONFIG" ]; then
        cat >> "$SHELL_CONFIG" <<EOF

# Claude Code Cookbook 中文版
export COOKBOOK_HOME="$INSTALL_DIR"
alias cookbook="cd \$COOKBOOK_HOME"
alias cookbook-update="cd \$COOKBOOK_HOME && git pull"
alias cookbook-help="cat \$COOKBOOK_HOME/versions/zh/README.md"
EOF
        
        print_color "✅ 快捷命令已添加到 $SHELL_CONFIG" "$GREEN"
        print_color "   请运行 'source $SHELL_CONFIG' 或重新打开终端以生效" "$YELLOW"
    fi
}

# 验证安装
verify_installation() {
    print_color "\n✨ 验证安装..." "$YELLOW"
    
    cd "$INSTALL_DIR"
    
    # 检查关键文件
    if [ -f "README.md" ] && [ -d "commands" ] && [ -d "agents" ]; then
        print_color "✅ 核心文件验证通过" "$GREEN"
    else
        print_color "⚠️  部分文件可能缺失" "$YELLOW"
    fi
    
    # 检查中文版本
    if [ -d "versions/zh" ]; then
        print_color "✅ 中文版本已就绪" "$GREEN"
    else
        print_color "⚠️  中文版本需要额外配置" "$YELLOW"
    fi
}

# 显示使用说明
show_usage() {
    print_color "\n📚 使用说明" "$BLUE"
    print_color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$BLUE"
    echo ""
    echo "1. 基本命令："
    echo "   cookbook         - 进入 Cookbook 目录"
    echo "   cookbook-update  - 更新到最新版本"
    echo "   cookbook-help    - 查看帮助文档"
    echo ""
    echo "2. 在 Claude 中使用："
    echo "   /commit-message  - 生成提交消息"
    echo "   /role architect  - 激活架构师角色"
    echo "   /smart-review    - 智能代码审查"
    echo ""
    echo "3. 查看更多命令："
    echo "   ls $INSTALL_DIR/versions/zh/commands/"
    echo ""
    print_color "详细文档: https://github.com/mustvlad/claude-code-cookbook" "$YELLOW"
}

# 主函数
main() {
    print_header
    check_dependencies
    select_install_dir
    clone_repository
    setup_chinese_version
    configure_claude_desktop
    create_shortcuts
    verify_installation
    
    print_color "\n🎉 安装成功！" "$GREEN"
    show_usage
    
    print_color "\n感谢使用 Claude Code Cookbook 中文版！" "$BLUE"
}

# 运行主函数
main
