#!/usr/bin/env python3
"""
Claude Code Cookbook Translation Tool
智能翻译工具 - 支持命令、角色和文档的多语言翻译
"""

import os
import sys
import json
import argparse
import hashlib
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import re

# 语言配置
LANGUAGE_CONFIG = {
    'en': {'name': 'English', 'code': 'en'},
    'zh': {'name': '中文', 'code': 'zh-CN'},
    'ja': {'name': '日本語', 'code': 'ja'},
    'fr': {'name': 'Français', 'code': 'fr'},
    'ko': {'name': '한국어', 'code': 'ko'}
}

# 翻译模板
TRANSLATION_PROMPTS = {
    'command': """请将以下 Claude Code Cookbook 命令文档翻译成{target_lang}。

要求：
1. 保持 Markdown 格式不变
2. 保持代码块和命令语法不变
3. 翻译描述性文本，保持技术术语的准确性
4. 保持专业的技术文档风格

原文：
{content}

请提供{target_lang}翻译：""",

    'agent': """请将以下 Claude Code Cookbook 专家角色定义翻译成{target_lang}。

要求：
1. 保持 Markdown 格式不变
2. 准确翻译角色描述和专业技能
3. 保持技术术语的专业性
4. 确保角色定位清晰准确

原文：
{content}

请提供{target_lang}翻译：""",

    'doc': """请将以下 Claude Code Cookbook 文档翻译成{target_lang}。

要求：
1. 保持 Markdown 格式和链接不变
2. 翻译所有描述性内容
3. 保持技术准确性
4. 适应目标语言的表达习惯

原文：
{content}

请提供{target_lang}翻译："""
}

class TranslationManager:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.cache_file = self.project_root / '.translation_cache.json'
        self.cache = self.load_cache()
    
    def load_cache(self) -> Dict:
        """加载翻译缓存"""
        if self.cache_file.exists():
            try:
                with open(self.cache_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                pass
        return {}
    
    def save_cache(self):
        """保存翻译缓存"""
        with open(self.cache_file, 'w', encoding='utf-8') as f:
            json.dump(self.cache, f, ensure_ascii=False, indent=2)
    
    def get_content_hash(self, content: str) -> str:
        """获取内容哈希值"""
        return hashlib.md5(content.encode('utf-8')).hexdigest()
    
    def is_translation_needed(self, source_file: Path, target_file: Path) -> bool:
        """检查是否需要翻译"""
        if not target_file.exists():
            return True
        
        # 检查文件修改时间
        if source_file.stat().st_mtime > target_file.stat().st_mtime:
            return True
        
        # 检查内容哈希
        source_content = source_file.read_text(encoding='utf-8')
        source_hash = self.get_content_hash(source_content)
        
        cache_key = f"{source_file}:{target_file}"
        if cache_key in self.cache:
            return self.cache[cache_key]['source_hash'] != source_hash
        
        return True
    
    def detect_content_type(self, file_path: Path) -> str:
        """检测内容类型"""
        if 'commands' in str(file_path):
            return 'command'
        elif 'agents' in str(file_path) or 'roles' in str(file_path):
            return 'agent'
        else:
            return 'doc'
    
    def generate_translation_prompt(self, content: str, target_lang: str, content_type: str) -> str:
        """生成翻译提示"""
        lang_name = LANGUAGE_CONFIG[target_lang]['name']
        template = TRANSLATION_PROMPTS[content_type]
        return template.format(target_lang=lang_name, content=content)
    
    def translate_file(self, source_file: Path, target_file: Path, target_lang: str) -> bool:
        """翻译单个文件"""
        if not self.is_translation_needed(source_file, target_file):
            print(f"✓ {target_file.relative_to(self.project_root)} (up to date)")
            return True
        
        print(f"🔄 Translating {source_file.relative_to(self.project_root)} -> {target_file.relative_to(self.project_root)}")
        
        # 读取源文件
        source_content = source_file.read_text(encoding='utf-8')
        content_type = self.detect_content_type(source_file)
        
        # 生成翻译提示
        prompt = self.generate_translation_prompt(source_content, target_lang, content_type)
        
        # 这里可以集成实际的翻译服务
        # 目前输出翻译提示，供手动翻译或集成翻译API
        print(f"📝 Translation prompt for {target_lang}:")
        print("=" * 50)
        print(prompt)
        print("=" * 50)
        print()
        
        # 创建目标目录
        target_file.parent.mkdir(parents=True, exist_ok=True)
        
        # 暂时复制源文件作为占位符（实际应该是翻译后的内容）
        if not target_file.exists():
            target_file.write_text(source_content, encoding='utf-8')
            print(f"⚠️  Created placeholder for {target_file.relative_to(self.project_root)}")
        
        # 更新缓存
        cache_key = f"{source_file}:{target_file}"
        self.cache[cache_key] = {
            'source_hash': self.get_content_hash(source_content),
            'translated_at': str(Path.ctime(target_file)) if target_file.exists() else None
        }
        
        return True
    
    def scan_translation_needs(self) -> Dict[str, List[Tuple[Path, Path]]]:
        """扫描需要翻译的文件"""
        needs_translation = {}
        
        en_version = self.project_root / 'versions' / 'en'
        if not en_version.exists():
            print("❌ English version not found")
            return needs_translation
        
        for lang in LANGUAGE_CONFIG.keys():
            if lang == 'en':
                continue
            
            lang_needs = []
            lang_version = self.project_root / 'versions' / lang
            
            # 扫描命令文件
            en_commands = en_version / 'commands'
            if en_commands.exists():
                for en_file in en_commands.glob('*.md'):
                    target_file = lang_version / 'commands' / en_file.name
                    if self.is_translation_needed(en_file, target_file):
                        lang_needs.append((en_file, target_file))
            
            # 扫描角色文件
            en_agents = en_version / 'agents' / 'roles'
            if en_agents.exists():
                for en_file in en_agents.glob('*.md'):
                    target_file = lang_version / 'agents' / 'roles' / en_file.name
                    if self.is_translation_needed(en_file, target_file):
                        lang_needs.append((en_file, target_file))
            
            # 扫描文档文件
            en_claude = en_version / 'Claude.md'
            if en_claude.exists():
                target_claude = lang_version / 'Claude.md'
                if self.is_translation_needed(en_claude, target_claude):
                    lang_needs.append((en_claude, target_claude))
            
            if lang_needs:
                needs_translation[lang] = lang_needs
        
        return needs_translation
    
    def translate_language(self, target_lang: str) -> bool:
        """翻译指定语言的所有内容"""
        if target_lang not in LANGUAGE_CONFIG:
            print(f"❌ Unsupported language: {target_lang}")
            return False
        
        print(f"🌍 Translating to {LANGUAGE_CONFIG[target_lang]['name']} ({target_lang})")
        
        needs_translation = self.scan_translation_needs()
        if target_lang not in needs_translation:
            print(f"✅ {LANGUAGE_CONFIG[target_lang]['name']} is up to date")
            return True
        
        files_to_translate = needs_translation[target_lang]
        print(f"📋 Found {len(files_to_translate)} files to translate")
        
        success_count = 0
        for source_file, target_file in files_to_translate:
            if self.translate_file(source_file, target_file, target_lang):
                success_count += 1
        
        self.save_cache()
        
        print(f"✅ Translated {success_count}/{len(files_to_translate)} files for {target_lang}")
        return success_count == len(files_to_translate)
    
    def validate_completeness(self) -> Dict[str, Dict[str, int]]:
        """验证各语言版本的完整性"""
        stats = {}
        
        en_version = self.project_root / 'versions' / 'en'
        if not en_version.exists():
            return stats
        
        # 统计英语版本
        en_commands = len(list((en_version / 'commands').glob('*.md'))) if (en_version / 'commands').exists() else 0
        en_agents = len(list((en_version / 'agents' / 'roles').glob('*.md'))) if (en_version / 'agents' / 'roles').exists() else 0
        
        stats['en'] = {'commands': en_commands, 'agents': en_agents, 'complete': True}
        
        # 统计其他语言版本
        for lang in LANGUAGE_CONFIG.keys():
            if lang == 'en':
                continue
            
            lang_version = self.project_root / 'versions' / lang
            if not lang_version.exists():
                stats[lang] = {'commands': 0, 'agents': 0, 'complete': False}
                continue
            
            lang_commands = len(list((lang_version / 'commands').glob('*.md'))) if (lang_version / 'commands').exists() else 0
            lang_agents = len(list((lang_version / 'agents' / 'roles').glob('*.md'))) if (lang_version / 'agents' / 'roles').exists() else 0
            
            complete = (lang_commands >= en_commands) and (lang_agents >= en_agents)
            stats[lang] = {'commands': lang_commands, 'agents': lang_agents, 'complete': complete}
        
        return stats
    
    def print_status_report(self):
        """打印状态报告"""
        print("📊 Translation Status Report")
        print("=" * 50)
        
        stats = self.validate_completeness()
        needs_translation = self.scan_translation_needs()
        
        for lang, data in stats.items():
            lang_name = LANGUAGE_CONFIG[lang]['name']
            status = "✅" if data['complete'] else "⚠️"
            pending = len(needs_translation.get(lang, []))
            
            print(f"{status} {lang_name} ({lang}): {data['commands']} commands, {data['agents']} agents")
            if pending > 0:
                print(f"   📝 {pending} files need translation")
        
        print()

def main():
    parser = argparse.ArgumentParser(description='Claude Code Cookbook Translation Tool')
    parser.add_argument('command', choices=['scan', 'translate', 'validate', 'status'], 
                       help='Command to execute')
    parser.add_argument('--lang', help='Target language (zh, ja, fr, ko)')
    parser.add_argument('--project-root', default='.', help='Project root directory')
    
    args = parser.parse_args()
    
    # 获取项目根目录
    if args.project_root == '.':
        # 从脚本位置推断项目根目录
        script_dir = Path(__file__).parent
        project_root = script_dir.parent
    else:
        project_root = Path(args.project_root)
    
    translator = TranslationManager(str(project_root))
    
    if args.command == 'scan':
        needs_translation = translator.scan_translation_needs()
        if not needs_translation:
            print("✅ All translations are up to date")
        else:
            for lang, files in needs_translation.items():
                lang_name = LANGUAGE_CONFIG[lang]['name']
                print(f"📋 {lang_name} ({lang}): {len(files)} files need translation")
    
    elif args.command == 'translate':
        if not args.lang:
            print("❌ --lang parameter required for translate command")
            sys.exit(1)
        
        success = translator.translate_language(args.lang)
        sys.exit(0 if success else 1)
    
    elif args.command == 'validate':
        stats = translator.validate_completeness()
        all_complete = all(data['complete'] for data in stats.values())
        
        for lang, data in stats.items():
            lang_name = LANGUAGE_CONFIG[lang]['name']
            status = "✅" if data['complete'] else "❌"
            print(f"{status} {lang_name}: {data['commands']} commands, {data['agents']} agents")
        
        sys.exit(0 if all_complete else 1)
    
    elif args.command == 'status':
        translator.print_status_report()

if __name__ == '__main__':
    main()