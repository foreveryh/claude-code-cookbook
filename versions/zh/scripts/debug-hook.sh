#!/bin/bash

# Hook 调试脚本
echo "Hook executed at $(date)" >>/tmp/claude-hook-debug.log
echo "Input data:" >>/tmp/claude-hook-debug.log
cat >>/tmp/claude-hook-debug.log
echo "---" >>/tmp/claude-hook-debug.log
