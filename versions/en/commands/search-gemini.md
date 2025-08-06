## Search Gemini

Search using Gemini AI capabilities.

### Usage

```bash
# Gemini CLI 経由で Web search（必須）
gemini --prompt "WebSearch: <searchクエリ>"
```

### Basic Examples

```bash
# Gemini CLI  usage
gemini --prompt "WebSearch: React 19 新Features"
gemini --prompt "WebSearch: TypeError Cannot read property of undefined solving方法"
```

### Claude Integration with Claude

```bash
# documentationsearchと要約
gemini --prompt "WebSearch: Next.js 14 App Router 公式documentation"
"search結果 要約して主要なFeaturesをDescriptionして"

# エラー調査
cat error.log
gemini --prompt "WebSearch: [エラーメッセージ] solving方法"
"search結果から最もappropriatesolving方法 suggestして"

# 技術比較
gemini --prompt "WebSearch: Rust vs Go performance benchmark 2024"
"search結果からperformance 違い まとめて"
```

### Detailed Examples

```bash
# 複数ソースから information収集
gemini --prompt "WebSearch: GraphQL best practices 2024 multiple sources"
"search結果から複数 信頼 きるソースのinformation まとめて"

# 時系列で 変化 調査
gemini --prompt "WebSearch: JavaScript ES2015 ES2016 ES2017 ES2018 ES2019 ES2020 ES2021 ES2022 ES2023 ES2024 features"
"各バージョン 主要なchanges点 時系列 まとめて"

# identifyドメイン 絞ったsearch
gemini --prompt "WebSearch: site:github.com Rust WebAssembly projects stars:>1000"
"スター数 多い順に 10 個 project リストアップして"

# latest セキュリティinformation
gemini --prompt "WebSearch: CVE-2024 Node.js vulnerabilities"
"見つかった脆弱性 影響と対策 まとめて"
```

### 禁止事項

- **Claude  組み込み WebSearch ツール usage 禁止**
- Web search 必要な場合 、必ず `gemini --prompt "WebSearch: ..."`  usageすること

### Important Notes

- **Gemini CLI  利用可能な場合 、必ず `gemini --prompt "WebSearch: ..."`  usageplease**
- Web search結果 常 latestと 限りません
- 重要なinformation 公式documentationや信頼 きるソースで確認すること お勧め
