## Gemini Web Search

Execute web searches using Gemini CLI to retrieve the latest information.

### Usage

```bash
# Web search via Gemini CLI (required)
gemini --prompt "WebSearch: <search query>"
```

### Basic Examples

```bash
# Using Gemini CLI
gemini --prompt "WebSearch: React 19 new features"
gemini --prompt "WebSearch: TypeError Cannot read property of undefined solution"
```

### Integration with Claude

```bash
# Document search and summarization
gemini --prompt "WebSearch: Next.js 14 App Router official documentation"
"Summarize the search results and explain the main features"

# Error investigation
cat error.log
gemini --prompt "WebSearch: [error message] solution"
"Suggest the most appropriate solution from the search results"

# Technology comparison
gemini --prompt "WebSearch: Rust vs Go performance benchmark 2024"
"Summarize the performance differences from the search results"
```

### Detailed Examples

```bash
# Gathering information from multiple sources
gemini --prompt "WebSearch: GraphQL best practices 2024 multiple sources"
"Compile information from multiple reliable sources in the search results"

# Investigating changes over time
gemini --prompt "WebSearch: JavaScript ES2015 ES2016 ES2017 ES2018 ES2019 ES2020 ES2021 ES2022 ES2023 ES2024 features"
"Summarize the major changes for each version chronologically"

# Domain-specific search
gemini --prompt "WebSearch: site:github.com Rust WebAssembly projects stars:>1000"
"List 10 projects sorted by star count"

# Latest security information
gemini --prompt "WebSearch: CVE-2024 Node.js vulnerabilities"
"Summarize the impacts and countermeasures for the vulnerabilities found"
```

### Restrictions

- **Use of Claude's built-in WebSearch tool is prohibited**
- When web search is needed, always use `gemini --prompt "WebSearch: ..."`

### Important Notes

- **When Gemini CLI is available, always use `gemini --prompt "WebSearch: ..."`**
- Web search results may not always be up-to-date
- It's recommended to verify important information with official documentation or reliable sources
