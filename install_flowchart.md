# Claude Code Cookbook - Unified Installation Flowchart

## High-Level Installation Flow

```
┌─────────────────┐
│      START      │
└─────────────────┘
          │
          ▼
┌─────────────────┐
│ Parse Arguments │
└─────────────────┘
          │
          ▼
    ┌──────────┐      ┌─────────────┐      ┌──────────────┐
    │ --lang?  │ YES  │ Set Language│      │ Detect from  │
    │ provided ├─────▶│ from Flag   │      │ $LANG env    │
    └────┬─────┘      └─────────────┘      │ variable     │
         │ NO                              └──────┬───────┘
         └─────────────────────────────────────────┤
                                                   ▼
                                             ┌──────────┐      ┌──────────────┐
                                             │ Valid    │ NO   │ Interactive  │
                                             │ Language?├─────▶│ Menu (en/zh) │
                                             └────┬─────┘      └──────────────┘
                                                  │ YES
                                                  ▼
                                        ┌─────────────────┐
                                        │ Initialize i18n │
                                        │ Message System  │
                                        └─────────────────┘
                                                  │
                                                  ▼
                                        ┌─────────────────┐
                                        │ Show Banner &   │
                                        │ Dry-Run Notice  │
                                        └─────────────────┘
                                                  │
                                                  ▼
    ╔═════════════════════════════════════════════════════════════════════╗
    ║                        ENVIRONMENT CHECKS                           ║
    ╚═════════════════════════════════════════════════════════════════════╝
                                                  │
          ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
          │ Check Shell     │      │ Check Disk      │      │ Check Write     │
          │ Version (≥4.0)  │      │ Space (≥500MB)  │      │ Permissions     │
          └─────────────────┘      └─────────────────┘      └─────────────────┘
                    │                        │                        │
                    └────────────────────────┼────────────────────────┘
                                             ▼
                                   ┌─────────────────┐
                                   │ Check Required  │
                                   │ Dependencies    │
                                   │ (git, curl)     │
                                   └─────────────────┘
                                             │
                                             ▼
    ╔═════════════════════════════════════════════════════════════════════╗
    ║                       PREREQUISITES SETUP                          ║
    ╚═════════════════════════════════════════════════════════════════════╝
                                             │
                                        ┌────┴────┐
                                        │ Model?  │
                      ┌─────────────────┼─────────┼─────────────────┐
                      ▼                 ▼         ▼                 ▼
              ┌────────────┐    ┌────────────┐    ┌────────────┐    ┌─────────┐
              │ PPINFRA    │    │   Gemini   │    │   OpenAI   │    │  Local  │
              │ Setup      │    │   Setup    │    │   Setup    │    │ Models  │
              └────────────┘    └────────────┘    └────────────┘    └─────────┘
                      │                 │         │                 │
                      └─────────────────┼─────────┼─────────────────┘
                                        ▼
                                 ┌─────────────┐      ┌─────────────────┐
                                 │ Dry Run?    │ YES  │ Show Preview &  │
                                 │             ├─────▶│ Exit            │
                                 └─────┬───────┘      └─────────────────┘
                                       │ NO
                                       ▼
    ╔═════════════════════════════════════════════════════════════════════╗
    ║                        MODEL DOWNLOAD/SETUP                        ║
    ╚═════════════════════════════════════════════════════════════════════╝
                                       │
                                 ┌─────┴──────┐
                                 │ Existing   │
                                 │ Install?   │
                           ┌─────┼────────────┼─────┐
                           ▼     ▼            ▼     ▼
                    ┌───────────┐  ┌─────────┐  ┌──────┐
                    │    Auto   │  │ Prompt  │  │ Skip │
                    │   Backup  │  │  User   │  │      │
                    └───────────┘  └─────────┘  └──────┘
                           │           │           │
                           └───────────┼───────────┘
                                       ▼
                                 ┌─────────────┐
                                 │ Perform     │
                                 │ Installation│
                                 └─────────────┘
                                       │
                               ┌───────┴────────┐
                               ▼                ▼
                        ┌─────────────┐  ┌─────────────┐
                        │Install From │  │Install From │
                        │   Local     │  │   Remote    │
                        │ (versions/) │  │ (git clone) │
                        └─────────────┘  └─────────────┘
                               │                │
                               └────────┬───────┘
                                        ▼
                                ┌────────────────┐
                                │ Configure      │
                                │ Model Backend  │
                                └────────────────┘
                                        │
                                        ▼
                                ┌────────────────┐      ┌──────────────┐
                                │ Setup GPU      │      │ Auto-detect: │
                                │ Acceleration   │      │ CUDA/Metal/  │
                                └────────────────┘      │ None         │
                                        │               └──────────────┘
                                        ▼
    ╔═════════════════════════════════════════════════════════════════════╗
    ║                       POST-INSTALL TEST                            ║
    ╚═════════════════════════════════════════════════════════════════════╝
                                        │
                                 ┌──────┴───────┐
                                 │ Verification │ NO   ┌─────────────────┐
                                 │ Enabled?     ├─────▶│ Skip to Success │
                                 └──────┬───────┘      └─────────────────┘
                                        │ YES
                                        ▼
                              ┌─────────────────┐
                              │ Run Verification│
                              │ Tests           │
                              └─────────────────┘
                                        │
                                 ┌──────┴───────┐
                                 │ Tests Pass?  │ NO   ┌─────────────────┐
                                 │              ├─────▶│ Show Error &    │
                                 └──────┬───────┘      │ Cleanup Options │
                                        │ YES          └─────────────────┘
                                        ▼
                              ┌─────────────────┐
                              │ Show Success    │
                              │ Message &       │
                              │ Next Steps      │
                              └─────────────────┘
                                        │
                                        ▼
                              ┌─────────────────┐
                              │      END        │
                              └─────────────────┘
```

## Detailed Step Breakdown

### 1. Environment Checks Phase
- **Shell Compatibility**: Ensure bash 4.0+ for associative arrays
- **Disk Space**: Minimum 500MB free space verification
- **Permissions**: Write access to target directory
- **Dependencies**: git, curl, optional python3/node.js

### 2. Prerequisites Phase
- **Model-Specific Setup**: Configure based on --model flag
  - PPINFRA: OpenAI-compatible API with qwen/qwen3-235b-a22b-thinking-2507
  - Gemini: Google Gemini API integration
  - OpenAI: Standard OpenAI API setup
- **Network Connectivity**: Test for remote installations
- **GPU Detection**: Auto-detect CUDA/Metal capabilities

### 3. Model Download Phase
- **Source Selection**: Local versions/ directory or remote git clone
- **Backup Strategy**: Handle existing installations
- **Configuration**: Create .env files with API keys
- **GPU Acceleration**: Auto-configure based on hardware

### 4. Post-Install Test Phase
- **Directory Structure**: Verify commands/, agents/, scripts/ exist
- **Configuration Files**: Validate .env and settings files
- **API Connectivity**: Test model backend connections (optional)
- **Integration**: Verify Claude Desktop compatibility

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Success |
| 1    | General error |
| 2    | Missing dependencies |
| 3    | Permission denied |
| 4    | Insufficient disk space |
| 5    | Network error |
| 10   | Verification failed |

## Error Recovery

The installer includes automatic rollback capabilities:
- Failed installations restore backup automatically
- Partial installations can be cleaned up
- Configuration errors provide specific remediation steps
- Network failures include retry mechanisms

## Extensibility Points

1. **Languages**: Add new MESSAGES_XX arrays for additional languages
2. **Models**: Extend model configuration functions
3. **Platforms**: Add OS-specific environment checks
4. **Sources**: Support additional installation sources (docker, package managers)
5. **Verification**: Add custom verification tests

This flowchart represents the complete installation process with all decision points, error handling, and recovery mechanisms built into the unified installer.
