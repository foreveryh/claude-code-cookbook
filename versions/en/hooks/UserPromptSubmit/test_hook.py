#!/usr/bin/env python3
"""
Test script for UserPromptSubmit hook
测试 UserPromptSubmit Hook 功能
"""
import json
import sys
import subprocess

def test_hook():
    """测试 Hook 脚本的各种场景"""
    
    test_cases = [
        {
            "name": "带 -u 后缀",
            "input": {"prompt": "解释量子计算 -u"},
            "expected": "Ultrathink Mode Activated"
        },
        {
            "name": "带 -q 后缀",
            "input": {"prompt": "什么是 Python -q"},
            "expected": "Quick Mode"
        },
        {
            "name": "带 -d 后缀",
            "input": {"prompt": "调试这段代码 -d"},
            "expected": "Debug Mode"
        },
        {
            "name": "无特殊后缀",
            "input": {"prompt": "普通的问题"},
            "expected": ""
        },
        {
            "name": "后缀在中间",
            "input": {"prompt": "这是 -u 但不在结尾"},
            "expected": ""
        }
    ]
    
    print("=" * 50)
    print("UserPromptSubmit Hook 测试")
    print("=" * 50)
    
    for test in test_cases:
        print(f"\n测试: {test['name']}")
        print(f"输入: {test['input']['prompt']}")
        
        # 运行 Hook 脚本
        process = subprocess.Popen(
            ["python3", "append_ultrathink.py"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        stdout, stderr = process.communicate(input=json.dumps(test['input']))
        
        # 检查结果
        if test['expected']:
            if test['expected'] in stdout:
                print(f"✅ 通过 - 找到预期输出")
            else:
                print(f"❌ 失败 - 未找到预期输出")
                print(f"   预期: {test['expected']}")
                print(f"   实际: {stdout[:100]}...")
        else:
            if stdout.strip():
                print(f"❌ 失败 - 不应有输出")
                print(f"   实际: {stdout[:100]}...")
            else:
                print(f"✅ 通过 - 无输出（符合预期）")
        
        if stderr:
            print(f"   stderr: {stderr}")
    
    print("\n" + "=" * 50)
    print("测试完成")
    print("=" * 50)

if __name__ == "__main__":
    test_hook()
