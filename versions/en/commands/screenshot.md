## Screenshot

Analyze and describe screenshot content.

### Usage

```bash
/screenshot [Options]
```

### Options

- None: Window selection (Claude confirms options)
- `--window`: Capture specific window
- `--full`: Capture entire screen
- `--crop`: Capture selected area

### Basic Examples

```bash
# Capture and analyze window
/screenshot --window
"Analyze the captured screen"

# Analyze selected area
/screenshot --crop
"Describe the content of the selected area"

# Capture and analyze full screen
/screenshot --full
"Analyze the overall screen composition"
```

### Claude Integration

```bash
# Analyze without specific issue - situation analysis
/screenshot --crop
(Claude automatically analyzes screen content and describes elements and composition)

# UI/UX issue analysis
/screenshot --window
"Identify UI issues and suggest improvements"

# Error analysis
/screenshot --window
"Explain the cause of this error message and how to solve it"

# Design review
/screenshot --full
"Evaluate this design from a UX perspective"

# Code analysis
/screenshot --crop
"Point out issues in this code"

# Data visualization analysis
/screenshot --crop
"Analyze the trends visible in this graph"
```

### Detailed Examples

```bash
# Analyze from multiple perspectives
/screenshot --window
"Analyze this screen for:
1. UI consistency
2. Accessibility issues
3. Improvement suggestions"

# Multiple captures for comparison
/screenshot --window
# (Save before image)
# Make changes
/screenshot --window
# (Save after image)
"Compare before and after images, analyze changes and improvement effects"

# Focus on specific elements
/screenshot --crop
"Evaluate whether the selected button design harmonizes with other elements"
```

### Prohibited Actions

- **Do not claim to have "taken a screenshot" when none was taken**
- **Do not attempt to analyze non-existent image files**
- **The `/screenshot` command does not actually capture screenshots**

### Important Notes

- When no options are specified, present the following choices:

  ```
  "Which screenshot method?
  1. Window selection (--window) → screencapture -W
  2. Full screen (--full) → screencapture -x
  3. Select area (--crop) → screencapture -i"
  ```

- Begin image analysis after user executes the screencapture command
- Specifying concrete issues or perspectives enables more focused analysis
