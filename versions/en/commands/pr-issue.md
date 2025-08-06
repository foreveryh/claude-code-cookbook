## PR Issue

Link pull requests to issues and manage relationships.

### Usage

```bash
# Claude  依頼
"オープン Issue list 優先順位付き displayして"
```

### Basic Examples

```bash
# リポジトリinformation 取得
gh repo view --json nameWithOwner | jq -r '.nameWithOwner'

# オープン Issue information 取得して Claude  依頼
gh issue list --state open --json number,title,author,createdAt,updatedAt,labels,assignees,comments --limit 30

"上記の Issue  優先度別 整理して、各 Issue の 2 行Overviewも含めてdisplayして。URL  上記 取得したリポジトリ名 usageしてgenerateして"
```

### display形式

```
オープン Issue list（優先順位順）

### 高優先度
#番号 タイトル [ラベル] | 作者 | オープンから経過時間 | コメント数 | 担当者
      ├─ Overview 1 行目
      └─ Overview 2 行目
      https://github.com/owner/repo/issues/番号

### 中優先度
（同様 形式）

### 低優先度
（同様 形式）
```

### 優先度 判定基準

**高優先度**

- `bug` ラベル 付いている Issue
- `critical` や `urgent` ラベル 付いている Issue
- `security` ラベル 付いている Issue

**中優先度**

- `enhancement` ラベル 付いている Issue
- `feature` ラベル 付いている Issue
- 担当者 configurationされている Issue

**低優先度**

- `documentation` ラベル 付いている Issue
- `good first issue` ラベル 付いている Issue
- `wontfix` や `duplicate` ラベル 付いている Issue

### ラベル よるフィルタリング

```bash
# identify ラベルの Issue  み取得
gh issue list --state open --label "bug" --json number,title,author,createdAt,labels,comments --limit 30

# 複数ラベル フィルタリング（AND 条件）
gh issue list --state open --label "bug,high-priority" --json number,title,author,createdAt,labels,comments --limit 30
```

### Important Notes

- GitHub CLI (`gh`)  required
- オープン状態の Issue  みdisplay
- 最大 30 件の Issue  display
- 経過時間は Issue  オープンされてから 時間 す
- Issue の URL  実際 リポジトリ名から自動generateされます
