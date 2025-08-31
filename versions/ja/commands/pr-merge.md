## PR マージ

包括的な品質検証と承認後に Pull Request を自動的にマージします。

### 使い方

```bash
# 品質ゲートパス後の自動マージ
/pr-merge
"すべての品質ゲートを検証し、現在の PR を自動的にマージする"

# 特定の PR を検証してマージ
/pr-merge --pr 123
"すべてのチェックが通過した後、PR #123 を検証してマージする"

# マージ準備状況をチェックするドライラン
/pr-merge --dry-run
"実際にマージせずに PR がマージ準備完了かチェックする"
```

### 基本例

```bash
# 完全な品質検証とマージ
gh pr checks && gh pr view --json reviewDecision
"CI ステータスと承認ステータスを検証し、すべての条件が満たされていればマージを実行"

# セーフティチェック付き条件マージ
gh pr view --json isDraft,mergeable,reviewDecision
"マージ前にドラフト状態、マージ競合、レビュー承認をチェック"
```

### マージ前検証チェックリスト

#### 1. CI ステータスチェック
```bash
# すべての CI チェックが通過することを確認
gh pr checks --required
"すべての必須 CI チェックが緑色であることを確保"
```

#### 2. レビューステータスチェック
```bash
# 承認ステータスをチェック
gh pr view --json reviewDecision,reviews
"PR が必要な承認を得ており、保留中の変更要求がないことを確認"
```

#### 3. ブランチステータスチェック
```bash
# マージ競合をチェック
gh pr view --json mergeable,mergeableState
"マージ競合が存在しないことを確認"
```

#### 4. ドラフトステータスチェック
```bash
# PR がドラフトでないことを確認
gh pr view --json isDraft
"PR がレビュー準備完了としてマークされていることを確認"
```

### マージ戦略

#### デフォルト：スカッシュマージ
```bash
# スカッシュマージ（フィーチャーブランチ推奨）
gh pr merge --squash --delete-branch
"すべてのコミットを単一のコミットに結合し、フィーチャーブランチを削除"
```

#### 代替：マージコミット
```bash
# マージコミットを作成（リリースブランチ用）
gh pr merge --merge --delete-branch
"コミット履歴を保持する明示的なマージコミットを作成"
```

#### 代替：リベースマージ
```bash
# リベースマージ（線形履歴用）
gh pr merge --rebase --delete-branch
"ベースブランチの上にコミットを再実行"
```

### セーフティメカニズム

#### 1. 必須条件
- ✅ すべての必須 CI チェックが通過する必要がある
- ✅ コードオーナーからの少なくとも一つの承認
- ✅ 保留中の変更要求がない
- ✅ マージ競合がない
- ✅ PR がドラフト状態でない
- ✅ ブランチ保護ルールが満たされている

#### 2. オプション品質ゲート
- ⚠️ コードカバレッジ閾値が満たされている
- ⚠️ セキュリティスキャンが通過
- ⚠️ パフォーマンスベンチマークが許容範囲
- ⚠️ ドキュメントが更新されている

#### 3. 緊急バイパス（管理者のみ）
```bash
# 管理者権限で強制マージ（注意して使用）
/pr-merge --force --admin
"保護ルールを上書き（管理者権限が必要）"
```

### 実行フロー

```bash
#!/bin/bash

# 1. 現在の PR を検出
detect_current_pr() {
  local current_branch=$(git branch --show-current)
  gh pr list --head $current_branch --json number --jq '.[0].number'
}

# 2. 包括的検証
verify_merge_readiness() {
  local pr_number=$1
  
  # CI ステータスをチェック
  local ci_status=$(gh pr checks $pr_number --required --json state --jq '.[] | select(.state != "SUCCESS") | length')
  if [ $ci_status -gt 0 ]; then
    echo "❌ 必須 CI チェックが通過していません"
    return 1
  fi
  
  # レビューステータスをチェック
  local review_decision=$(gh pr view $pr_number --json reviewDecision --jq '.reviewDecision')
  if [ "$review_decision" != "APPROVED" ]; then
    echo "❌ PR が承認されていません（ステータス：$review_decision）"
    return 1
  fi
  
  # ドラフトステータスをチェック
  local is_draft=$(gh pr view $pr_number --json isDraft --jq '.isDraft')
  if [ "$is_draft" = "true" ]; then
    echo "❌ PR はまだドラフト状態です"
    return 1
  fi
  
  # マージ競合をチェック
  local mergeable=$(gh pr view $pr_number --json mergeable --jq '.mergeable')
  if [ "$mergeable" != "MERGEABLE" ]; then
    echo "❌ PR にマージ競合があります"
    return 1
  fi
  
  echo "✅ すべてのマージ条件が満たされています"
  return 0
}

# 3. マージを実行
execute_merge() {
  local pr_number=$1
  local strategy=${2:-"squash"}
  
  case $strategy in
    "squash")
      gh pr merge $pr_number --squash --delete-branch
      ;;
    "merge")
      gh pr merge $pr_number --merge --delete-branch
      ;;
    "rebase")
      gh pr merge $pr_number --rebase --delete-branch
      ;;
    *)
      echo "❌ 不明なマージ戦略：$strategy"
      return 1
      ;;
  esac
  
  echo "✅ PR $pr_number のマージが成功しました"
}

# メイン実行
main() {
  local pr_number=$(detect_current_pr)
  
  if [ -z "$pr_number" ]; then
    echo "❌ 現在のブランチの PR が見つかりません"
    exit 1
  fi
  
  echo "🔍 PR #$pr_number のマージ準備状況を検証中"
  
  if verify_merge_readiness $pr_number; then
    if [ "$DRY_RUN" = "true" ]; then
      echo "✅ [ドライラン] PR #$pr_number はマージ準備完了です"
    else
      echo "🚀 マージを実行中..."
      execute_merge $pr_number $MERGE_STRATEGY
    fi
  else
    echo "❌ PR #$pr_number はマージ準備ができていません"
    exit 1
  fi
}
```

### オプション

- `--pr <番号>` : PR 番号を指定（省略時は現在のブランチから自動検出）
- `--strategy <squash|merge|rebase>` : マージ戦略を選択（デフォルト：squash）
- `--dry-run` : 実際にマージせずにマージ準備状況をチェック
- `--force` : 保護ルールを上書き（管理者のみ）
- `--no-delete-branch` : マージ後にフィーチャーブランチを保持

### 既存ワークフローとの統合

```bash
# 完全自動化ワークフロー
/pr-check          # 品質検証
/pr-review         # 包括的レビュー
/pr-feedback       # 問題に対処
/pr-auto-update    # メタデータ更新
/pr-merge          # 準備完了時に自動マージ
```

### 一般的な使用例

#### 1. フィーチャーブランチ完了
```bash
# 開発完了後
/pr-merge --strategy squash
"すべてのフィーチャーコミットをクリーンな単一コミットにスカッシュ"
```

#### 2. ホットフィックス展開
```bash
# 即座にマージが必要な緊急修正
/pr-merge --strategy merge
"監査証跡のために正確なコミット履歴を保持"
```

#### 3. リリースブランチ統合
```bash
# 完全な履歴でリリースブランチをマージ
/pr-merge --strategy merge --no-delete-branch
"将来の参照用にブランチを保持しながらリリースを統合"
```

### トラブルシューティング

#### 一般的な問題
1. **PR が承認されていない**：コードオーナーにレビューを依頼
2. **CI チェックが失敗**：`/pr-feedback` を使用して分析・修正
3. **マージ競合**：競合を解決してブランチを更新
4. **ドラフト状態**：`gh pr ready` を使用してレビュー準備完了をマーク
5. **ブランチ保護が不足**：リポジトリ管理者に連絡

#### エラー回復
```bash
# マージが失敗した場合、問題を分析
gh pr view $PR_NUMBER --json mergeableState,statusCheckRollup
"詳細なマージ状態と CI 結果をチェック"

# 問題を修正して再試行
/pr-feedback && /pr-merge --dry-run
"問題に対処し、再試行前に検証"
```

### セキュリティ考慮事項

1. **権限検証**：ユーザーがマージ権限を持っていることを確認
2. **ブランチ保護**：設定されたすべての保護ルールを尊重
3. **監査証跡**：ユーザー帰属を含むすべてのマージアクションをログ記録
4. **ロールバック計画**：必要に応じてマージ取り消し手順を文書化

### 注意事項

- **GitHub CLI が必要**：`gh` が認証されている必要があります
- **ブランチ権限**：ユーザーはターゲットブランチへの書き込みアクセスが必要
- **保護ルール**：すべてのリポジトリ保護ルールが満たされている必要があります
- **通知**：チームメンバーは GitHub の標準マージ通知で通知されます