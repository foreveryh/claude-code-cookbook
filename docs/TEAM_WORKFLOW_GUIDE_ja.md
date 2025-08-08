# チームプロジェクト完全ワークフローガイド

リポジトリの取得から PR マージまで — Claude Code と本 Cookbook を活用した実践的なエンドツーエンド手順です。

## ワークフロー概要

```mermaid
flowchart LR
    A[1. 取得] --> B[2. 分析]
    B --> C[3. 計画/タスク]
    C --> D[4. ブランチ作成]
    D --> E[5. 実装]
    E --> F[6. ローカルテスト]
    F --> G[7. レビュー]
    G --> H[8. PR]
    H --> I[9. CI]
    I --> J[10. マージ]
```

---

## 1) 取得と初期化

```bash
# クローン or 更新
git clone https://github.com/team/project.git
cd project
# もしくは
git fetch origin && git pull origin main
```

プロジェクトコンテキスト（公式）：ルートの Claude.md をコンテキストの単一エントリとして簡潔に保つ。詳細ドキュメントは docs/context/ に配置し、Claude.md からリンク。

安全対策：.env、.claude/secrets/、*.key を .gitignore に追加。

---

## 2) Claude による分析

- /analyze-dependencies で構造・ホットスポットを把握
- /tech-debt でリスク・改善点を抽出
- /explain-code <path> で要点を深掘り

---

## 3) 仕様化とタスク分解

- /spec で requirements/design/tasks のたたきを生成
- Must/Should/Could で優先度付けし、時間見積り（レンジ）を付与

---

## 4) ブランチ作成

```bash
git checkout -b feature/meaningful-name
# 例: fix/login-bug-#123
```

---

## 5) 実装（Claude 支援）

- 実装詳細を相談し、プロジェクトのスタイルに従う
- /semantic-commit で小さな単位のセマンティックなコミット

---

## 6) ローカルテスト

- ユニットテスト：npm/yarn/pytest など
- E2E：/test-e2e-local（起動→E2E→クリーンアップ）
- カバレッジ：基準（例：80%）を満たす

---

## 7) PR 前チェックとレビュー

- /pr-check で lint/type/test/build/audit/機密スキャンのゲート確認
- /smart-review で品質・セキュリティ観点のレビュー

---

## 8) PR 作成

```bash
git push origin feature/...
/pr-create-smart  # 高品質な PR 本文をドラフト
```

ラベル・レビュアーを追加し、Issue をリンク。

---

## 9) CI/CD とデプロイ準備

- /check-github-ci で CI ステータスを追跡
- /deploy-check --env staging --smoke-url ... でリリース可否を判定（--template でチェックリスト出力可）

---

## 10) フィードバック対応とマージ

- /pr-feedback でレビュー対応
- すべてのゲート通過後にマージ

---

## セキュリティチェックリスト

- diff/log に機密を含めない
- 入力を検証し、パラメータ化クエリを使用
- 依存関係の監査と緩和策の提示

---

## コマンド早見表

- /pr-check — PR 前の品質・安全チェック
- /pr-create-smart — コミット/差分から PR 本文をドラフト
- /test-e2e-local — ローカル E2E 実行
- /deploy-check — デプロイ前の準備チェック
- /check-github-ci — CI 実行の追跡

---

## ベストプラクティス

- 小さなコミット、短命ブランチ
- Claude.md は簡潔に、詳細はリンクで誘導
- /pr-check /deploy-check 用のログ/アーティファクトは CI で自動化
