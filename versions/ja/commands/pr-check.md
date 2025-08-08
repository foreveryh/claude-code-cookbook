## PR Check

PR 作成前の標準チェック。コード品質、テスト、ビルド、安全ゲートを網羅的に確認します。

### Usage

```bash
/pr-check [--strict]
```

### Options

- `--strict` : より厳格な基準（例: 変更ファイルの高いカバレッジ、audit 警告の不許可）

### Basic Examples

```bash
# 標準チェック
/pr-check
"以下の staged diff とローカル出力を解析し、ブロッカーを列挙して具体的な修正提案を提示してください。"

# 厳格モード
/pr-check --strict
"より高い基準を適用：変更ファイルのカバレッジ >90%、audit 警告は不可。"
```

### Claude Integration

```bash
# 文脈を提示してからコマンドを実行
# 1) 現在のブランチ、ステージング状態、スクリプト
git branch --show-current  git status --porcelain  cat package.json

# 2) 直近の lint/test/build 出力を貼り付け（以下はプレースホルダー）
# --- LINT OUTPUT START ---
# ...
# --- LINT OUTPUT END ---
# --- TEST OUTPUT START ---
# ...
# --- TEST OUTPUT END ---
# --- BUILD OUTPUT START ---
# ...
# --- BUILD OUTPUT END ---

# 3) コマンド実行
/pr-check --strict
"ゲート（lint、type-check、unit、必要に応じて e2e、build、機密スキャン、audit）ごとの合否と、未達成項目の具体的修正コマンド/差分を出してください。"
```

### Considerations

- Prerequisites: プロジェクトに lint/test/build/type-check 等のスクリプトが定義されていること。
- Limitations: 提供されたログ/差分に依存します。簡潔かつ十分な情報を提示してください。
- Recommendations: PR を小さく保つ。ローカルで通してから本コマンドを使うと効率的です。

### Related Commands (Optional)

- `/pr-create-smart` : コミット履歴と差分に基づく PR 説明のドラフト生成
- `/test-e2e-local` : ローカルでの E2E 立ち上げと重要フロー検証
