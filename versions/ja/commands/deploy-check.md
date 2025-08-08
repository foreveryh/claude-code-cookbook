## Deploy Check

デプロイ前の安全確認とリリース可否判定を行う意図定義コマンドです。ターゲット環境に対して安全に出せる状態かをチェックします。

### Usage

```bash
/deploy-check [--env <staging|production|custom>] [--smoke-url <url>] [--migrations] [--strict]
```

### Options

- `--env <staging|production|custom>` : 対象環境（必須チェックの内容や閾値に影響）
- `--smoke-url <url>` : デプロイ後のヘルス/スモーク確認エンドポイント（ある場合）
- `--migrations` : DB マイグレーションの準備状況確認（dry-run/plan）を含める
- `--strict` : より厳格なゲート（脆弱性 0、TODO/FIXME なし、カバレッジ閾値など）
- `--template` : 標準的な Markdown チェックリストのテンプレートを出力（CI 産物や手動レビュー用）

### Basic Examples

```bash
# 標準チェックリストのテンプレートを出力（CI アーティファクトやチケット用）
/deploy-check --template
"Markdown のチェックリストを出力してください。"
```

```bash
# ステージング向けの事前チェック
/deploy-check --env staging --smoke-url https://staging.example.com/health
"下記の build/test/audit 出力や環境変数を用いて準備完了か判定し、ブロッカーと対処を列挙してください。"

# 本番向け（マイグレーション含む）
/deploy-check --env production --migrations --strict
"無停止/最小停止を前提とし、ロールバック戦略と設定ドリフトも確認してください。"
```

### Claude Integration

```bash
# 1) ブランチと作業ツリーの状態
 git branch --show-current && git status --porcelain

# 2) main との同期状況（結果を貼り付け）
 git fetch origin && git rev-parse --short HEAD && git rev-parse --short origin/main && git log --oneline -5

# 3) lint/test/build/audit の要約（簡潔なログを貼り付け）
# --- LINT OUTPUT START ---
# ...
# --- TEST OUTPUT START ---
# ...
# --- BUILD OUTPUT START ---
# ...
# --- AUDIT OUTPUT START ---
# ...

# 4) 対象環境で必須の環境変数（秘匿情報はマスク）
# API_URL=...
# DATABASE_URL=...
# SECRET_KEY=...

# 5) マイグレーションが必要なら dry-run/plan を貼る
# --- MIGRATION PLAN START ---
# ...
# --- MIGRATION PLAN END ---

# 6) 任意：現在のインフラ/設定の概要（IaC ドリフト、イメージタグ、replica 数）
# --- INFRA SUMMARY START ---
# ...
# --- INFRA SUMMARY END ---

# 7) 実行
/deploy-check --env production --migrations --strict
"各ゲートの PASS/FAIL を一覧化。FAIL には具体的な修正手順/コマンドを提示。リスク評価、ロールバック手順、デプロイ後のスモーク（curl <url> / ログ確認）も記載。"
```

### 仕組み（Mechanism）

このコマンドは「意図定義」です。デプロイを実行せず、以下を行います：
- デプロイ前ゲート（ブランチ/作業ツリー、main 同期、テスト/ビルド/audit、必須環境変数、マイグレーション準備、設定/インフラ、スモーク準備）を一つのチェックリストに集約
- ユーザーが提示するログや差分、環境情報を用いて PASS/FAIL を判断
- 出力：
  - 各ゲートの PASS/FAIL 一覧
  - FAIL に対する具体的な是正手順/コマンド
  - 最小限のスモーク計画とロールバック方針

### テンプレート（出力例）

```
# デプロイ準備チェックリスト

- [ ] ブランチがクリーン（未コミット変更なし）
- [ ] main と同期（HEAD == origin/main または合理的な説明）
- [ ] Lint 合格
- [ ] 型チェック合格（該当する場合）
- [ ] 単体テスト合格
- [ ] E2E テスト合格（またはスコープと説明）
- [ ] ビルド成功
- [ ] セキュリティ監査：重大/高リスク 0（ある場合は緩和策を列挙）
- [ ] 必須環境変数：API_URL、DATABASE_URL、SECRET_KEY
- [ ] マイグレーション確認済み（dry-run/plan 添付）
- [ ] インフラ/設定のドリフト確認（IaC、イメージタグ、replica 数）
- [ ] ロールバック計画の記載
- [ ] デプロイ後のスモーク：curl <SMOKE_URL> とログ確認
```

### Considerations

- Prerequisites: プロジェクトに標準スクリプト（lint/test/build）があること。セキュリティ/audit ツールが利用可能であること。
- Limitations: 判断は貼り付けられたログや環境情報の正確性に依存します。
- Recommendations: CI アーティファクトでコンテキストの自動生成を推奨。本番ではリスクの高い操作に明示的な人手確認を必須化。

### Related Commands (Optional)

- `/pr-check` : PR 前の品質ゲート
- `/test-e2e-local` : ローカル E2E 検証
- `/check-github-ci` : CI ステータスの追跡
