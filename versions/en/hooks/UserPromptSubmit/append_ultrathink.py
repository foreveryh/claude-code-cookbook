#!/usr/bin/env python3
"""
Append an 'ultrathink' instruction when the user prompt ends with -u
自动在以 -u 结尾的提示词后追加 ultrathink 指令
"""
import json
import sys

def main():
    try:
        # 从 stdin 读取 Claude Code 传入的事件数据
        data = json.load(sys.stdin)
        prompt = data.get("prompt", "")
        
        # 调试信息（可选，输出到 stderr 不会影响结果）
        # print(f"Debug: Processing prompt: {prompt[:50]}...", file=sys.stderr)
        
        # 检查提示词是否以 -u 结尾
        if prompt.rstrip().endswith("-u"):
            # 输出到 stdout 的内容会作为额外上下文传给 Claude
            print("\n[System Instruction: Ultrathink Mode Activated]")
            print("Use the maximum amount of ultrathink. Take all the time you need.")
            print("It's much better if you do too much research and thinking than not enough.")
            print("Break down the problem systematically and explore multiple approaches.")
            
        # 也可以根据其他后缀添加不同的指令
        elif prompt.rstrip().endswith("-q"):
            print("\n[Quick Mode: Provide a concise, direct answer without extensive analysis]")
            
        elif prompt.rstrip().endswith("-d"):
            print("\n[Debug Mode: Show detailed reasoning and intermediate steps]")
            
    except json.JSONDecodeError as e:
        print(f"append_ultrathink hook: JSON parsing error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"append_ultrathink hook: Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
