#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
批量翻译日语角色文件到中文
"""

import os
import json
import re

# 角色翻译映射
ROLE_TRANSLATIONS = {
    "frontend": {
        "name": "frontend",
        "description": "前端开发专家。React、Vue、性能优化、用户体验设计。",
        "title": "前端开发者角色"
    },
    "mobile": {
        "name": "mobile", 
        "description": "移动开发专家。iOS、Android、Flutter、React Native、性能优化。",
        "title": "移动开发者角色"
    },
    "performance": {
        "name": "performance",
        "description": "性能优化专家。瓶颈分析、缓存策略、负载优化、响应时间改进。",
        "title": "性能优化专家角色"
    },
    "qa": {
        "name": "qa",
        "description": "质量保证专家。测试策略、自动化测试、质量度量、缺陷预防。",
        "title": "质量保证角色"
    },
    "reviewer": {
        "name": "reviewer",
        "description": "代码审查专家。最佳实践、设计模式、代码质量、重构建议。",
        "title": "代码审查者角色"
    },
    "security": {
        "name": "security",
        "description": "安全专家。漏洞评估、安全最佳实践、威胁建模、合规性检查。",
        "title": "安全专家角色"
    }
}

# 通用术语翻译
TERM_TRANSLATIONS = {
    # 日语到中文的常见术语映射
    "目的": "目的",
    "重点チェック項目": "重点检查项目",
    "振る舞い": "行为模式",
    "自動実行": "自动执行",
    "分析手法": "分析方法",
    "報告形式": "报告格式",
    "使用ツールの優先順位": "使用工具优先级",
    "制約事項": "约束条件",
    "トリガーフレーズ": "触发短语",
    "追加ガイドライン": "附加指南",
    "統合機能": "集成功能",
    "議論特性": "讨论特性",
    "議論スタンス": "讨论立场",
    "典型的論点": "典型论点",
    "論拠ソース": "论据来源",
    "議論での強み": "讨论优势",
    "注意すべき偏見": "需要注意的偏见",
    
    # 技术术语
    "コードレビュー": "代码审查",
    "セキュリティ": "安全性",
    "パフォーマンス": "性能",
    "フロントエンド": "前端",
    "モバイル": "移动端",
    "品質保証": "质量保证",
    "最適化": "优化",
    "設計パターン": "设计模式",
    "リファクタリング": "重构",
    "脆弱性": "漏洞",
    "アーキテクチャ": "架构",
    "テスト": "测试",
    "バグ": "缺陷",
    "メトリクス": "度量",
    "ベストプラクティス": "最佳实践",
    
    # 评估级别
    "優": "优",
    "良": "良",
    "可": "可",
    "要改善": "需改进",
    "高": "高",
    "中": "中",
    "低": "低"
}

def translate_content(content, role_name):
    """
    翻译文件内容（简化版本，实际使用时应调用翻译API）
    """
    # 这里应该调用实际的翻译API
    # 为了演示，只做基本的术语替换
    
    result = content
    
    # 替换已知术语
    for ja_term, zh_term in TERM_TRANSLATIONS.items():
        result = result.replace(ja_term, zh_term)
    
    # 如果有特定角色的翻译信息
    if role_name in ROLE_TRANSLATIONS:
        role_info = ROLE_TRANSLATIONS[role_name]
        # 更新描述和标题
        result = re.sub(
            r'description: ".*?"',
            f'description: "{role_info["description"]}"',
            result
        )
    
    return result

def process_role_file(source_path, target_path, role_name):
    """
    处理单个角色文件
    """
    print(f"处理: {role_name}.md")
    
    try:
        with open(source_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 翻译内容
        translated = translate_content(content, role_name)
        
        # 保存翻译后的文件
        with open(target_path, 'w', encoding='utf-8') as f:
            f.write(translated)
        
        print(f"  ✓ 已保存到: {target_path}")
        return True
        
    except Exception as e:
        print(f"  ✗ 处理失败: {str(e)}")
        return False

def main():
    """
    主函数
    """
    source_dir = "versions/ja/agents/roles"
    target_dir = "versions/zh/agents/roles"
    
    # 确保目标目录存在
    os.makedirs(target_dir, exist_ok=True)
    
    # 获取所有需要处理的角色文件
    roles = ["frontend", "mobile", "performance", "qa", "reviewer", "security"]
    
    success_count = 0
    total_count = len(roles)
    
    print("=" * 50)
    print("开始批量翻译角色文件")
    print("=" * 50)
    
    for role in roles:
        source_file = os.path.join(source_dir, f"{role}.md")
        target_file = os.path.join(target_dir, f"{role}.md")
        
        if os.path.exists(source_file):
            if process_role_file(source_file, target_file, role):
                success_count += 1
        else:
            print(f"警告: 源文件不存在 - {source_file}")
    
    print("=" * 50)
    print(f"处理完成: {success_count}/{total_count} 个文件成功")
    print("=" * 50)
    
    # 提示需要手动审核
    print("\n⚠️  注意：")
    print("1. 生成的文件包含基本术语翻译")
    print("2. 建议手动审核并优化翻译质量")
    print("3. 可以考虑使用专业翻译API进行完整翻译")

if __name__ == "__main__":
    main()
