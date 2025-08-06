## Explain Code

Provide detailed explanations of code functionality and design decisions.

### Usage

```bash
# Display file content and request Claude to explain
cat <file>
"Explain how this code works"
```

### Basic Examples

```bash
# Understanding Rust ownership
cat main.rs
"Explain this from the perspective of Rust ownership and lifetimes"

# Algorithm explanation
grep -A 50 "quicksort" sort.rs
"Explain how this sorting algorithm works and its computational complexity"

# Design pattern description
cat factory.rs
"Describe the design patterns used and their benefits"
```

### Claude Integration

```bash
# Beginner-friendly explanation
cat complex_function.py
"Explain this code line by line in a way that beginners can understand"

# Performance analysis
cat algorithm.rs
"Identify performance issues in this code and suggest improvements"

# Illustrated explanation
cat state_machine.js
"Explain the flow of this code with ASCII art diagrams"

# Security review
cat auth_handler.go
"Point out security concerns in this code"
```

### Detailed Examples

```bash
# Complex logic explanation
cat recursive_parser.rs
"Explain how this recursive parser works from the following perspectives:
1. Overall processing flow
2. Role and responsibility of each function
3. Edge case handling
4. Areas for improvement"

# Asynchronous processing explanation
cat async_handler.ts
"Explain this asynchronous processing covering:
1. Promise chain flow
2. Error handling mechanisms
3. Presence of concurrent processing
4. Potential for deadlocks"

# Architecture description
ls -la src/ && cat src/main.rs src/lib.rs
"Explain this project's architecture and module structure"
```

### Important Notes

Code explanations should not merely describe what the code does, but also provide deep insights into why it's implemented that way, what benefits it offers, and what potential issues exist.
