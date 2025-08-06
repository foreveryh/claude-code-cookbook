## Check Fact

Perform fact-checking and verify information accuracy.

### Usage

```bash
# Basic usage
/check-fact "The Flutter app uses Riverpod"

# Check multiple facts at once
/check-fact "This project uses GraphQL and manages routing with auto_route"

# Verify specific technical specifications
/check-fact "Authentication uses JWT and does not use Firebase Auth"
```

### Verification Process

1. **Information Source Priority**
   - Codebase (most reliable)
   - README.md, documentation in docs/
   - Configuration files like package.json, pubspec.yaml
   - Discussion history in Issues and Pull Requests

2. **Result Classification**
   - `✅ Correct` - Information fully matches codebase
   - `❌ Incorrect` - Information is clearly wrong
   - `⚠️ Partially correct` - Partially accurate but incomplete
   - `❓ Cannot determine` - Insufficient information for verification

3. **Evidence Specification**
   - File name and line number
   - Relevant code snippets
   - Relevant documentation sections

### Report Format

```
## Fact-Checking Results

### Verification Target
"[User-provided information]"

### Conclusion
[✅/❌/⚠️/❓] [Judgment result]

### Evidence
- **File**: `path/to/file.dart:123`
- **Content**: [Relevant code/text]
- **Note**: [Additional description]

### Detailed Description
[If incorrect, present correct information]
[If partially correct, point out inaccurate parts]
[If cannot determine, describe missing information]
```

### Basic Examples

```bash
# Verify project tech stack
/check-fact "This app is built with Flutter + Riverpod + GraphQL"

# Check implementation status  
/check-fact "Dark mode feature is implemented and can be toggled from user settings"

# Verify architecture
/check-fact "All state management is done with Riverpod, not using BLoC"

# Verify security implementation
/check-fact "Authentication tokens are encrypted and stored in secure storage"
```

### Claude Integration

```bash
# Verify after analyzing entire codebase
ls -la && find . -name "pubspec.yaml" -exec cat {} \;
/check-fact "The main dependencies used in this project are..."

# Check specific feature implementation status
grep -r "authentication" . --include="*.dart"
/check-fact "Authentication is custom implemented, not using third-party auth"

# Verify consistency with documentation
cat README.md
/check-fact "All features listed in README are fully implemented"
```

### Use Cases

- Technical specification writing: Verify content accuracy
- Project handover: Confirm understanding of existing implementation
- Before client reporting: Fact verification of implementation status
- Technical blog writing: Verify article content accuracy
- Interview/presentation preparation: Confirm project overview accuracy

### Important Notes

- Codebase is the most reliable information source
- Implementation takes priority when documentation is outdated
- Honestly report "Cannot determine" when information is insufficient
- Be especially careful when verifying security-related information
