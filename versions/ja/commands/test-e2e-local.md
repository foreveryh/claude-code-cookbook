## Test E2E Local

ローカルで E2E 環境を立ち上げ、重要なユーザーフローを検証します。

### Usage

```bash
/test-e2e-local [--headless]
```

### Options

- `--headless` : テストランナーが対応していればヘッドレスモードで実行

### Basic Examples

```bash
# ローカルアプリを起動して E2E を実行
/test-e2e-local
"プロジェクト標準の start:test と test:e2e を用い、失敗時も確実にクリーンアップすること。"

# ヘッドレスモード
/test-e2e-local --headless
"可能であればヘッドレスモードを優先。"
```

### Claude Integration

```bash
# スクリプトと環境情報を提示
cat package.json | jq '.scripts'

# 任意：.env.test を貼り付け（秘匿情報はマスク）
# --- ENV TEST START ---
# ...
# --- ENV TEST END ---

# 実行
/test-e2e-local
"計画：1) テストサーバ起動、2) レディネス待機、3) e2e 実行、4) アーティファクト収集、5) シャットダウン。スクリプトが異なる場合は代替手順を提示。"
```

### Considerations

- Prerequisites: `start:test` と `test:e2e` の定義（または代替スクリプトの提示）。
- Limitations: ローカルの不安定さは CI と異なる可能性あり。アーティファクトを残してデバッグ容易性を確保。
- Recommendations: テストの決定性を高め、ヘルスチェックを入れ、正しい後始末を行う。

### Related Commands (Optional)

- `/pr-check` : PR 前の品質ゲート
- `/pr-create-smart` : 変更内容から PR 本文ドラフトを作成
