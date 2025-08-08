## PR Create Smart

コミット履歴と差分から、高品質な PR 説明文のドラフトを生成します（目的・変更点・テスト・関連 Issue など）。

### Usage

```bash
/pr-create-smart [--assignees <users>] [--labels <labels>]
```

### Options

- `--assignees <users>` : カンマ区切りの GitHub ユーザー名
- `--labels <labels>` : カンマ区切りのラベル（例: enhancement,needs-review）

### Basic Examples

```bash
# 現在のブランチに対して PR 文面のドラフトを作成
/pr-create-smart
"origin/main 以降のコミットログと diff 統計を用いて PR 本文を作成してください。"

# メタ情報付き
/pr-create-smart --assignees @me --labels enhancement
"目的・変更点・テスト・（必要なら）スクリーンショット・関連 Issue を含む簡潔な PR 本文を用意してください。"
```

### Claude Integration

```bash
# diff 統計とコミットログを文脈として提供
changes=$(git diff --stat origin/main..HEAD)
commits=$(git log origin/main..HEAD --oneline)

# コマンド実行
/pr-create-smart --labels enhancement
"以下の構成で PR 本文を生成：
- 目的（why）
- 変更点（what）
- テスト（検証方法）
- リスク/緩和策
- チェックリスト
- 関連 Issue（本文中の #123 形式があれば解釈）
箇条書きを主体に、全体で 400-600 語程度に抑えてください。"
```

### Considerations

- Prerequisites: `git` の履歴は整えておくこと（必要であれば squash）。
- Limitations: 本コマンドは本文ドラフトを生成するのみ。PR の作成は gh/GUI 等で行ってください。
- Recommendations: スコープを小さく保つ。UI 変更にはスクリーンショットを付けると効果的。

### Related Commands (Optional)

- `/pr-check` : PR 前の品質・安全チェック
- `/pr-review` : レビュー運用とフィードバック対応
