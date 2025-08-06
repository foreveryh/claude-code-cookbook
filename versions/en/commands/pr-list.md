## PR List

List and manage pull requests efficiently.

### Usage

```bash
# Claude  依頼
"オープン PR list 優先順位付き displayして"
```

### Basic Examples

```bash
# リポジトリinformation 取得
gh repo view --json nameWithOwner | jq -r '.nameWithOwner'

# オープン PR information 取得して Claude  依頼
gh pr list --state open --draft=false --json number,title,author,createdAt,additions,deletions,reviews --limit 30

"上記の PR  優先度別 整理して、各 PR の 2 行Overviewも含めてdisplayして。URL  上記 取得したリポジトリ名 usageしてgenerateして"
```

### display形式

```
オープン PR list（優先順位順）

### 高優先度
#番号 タイトル [Draft/DNM] | 作者 | オープンから経過時間 | Approved 数 | +追加/-削除
      ├─ Overview 1 行目
      └─ Overview 2 行目
      https://github.com/owner/repo/pull/番号

### 中優先度
（同様 形式）

### 低優先度
（同様 形式）
```

### 優先度 判定基準

**高優先度**

- `fix:` バグ修正
- `release:` リリース作業

**中優先度**

- `feat:` 新Features
- `update:` Features改善
- そ 他通常の PR

**低優先度**

- DO NOT MERGE  含む PR
- Draft で `test:`、`build:`、`perf:` の PR

### Important Notes

- GitHub CLI (`gh`)  required
- オープン状態の PR  みdisplay（Draft  除外）
- 最大 30 件の PR  display
- 経過時間は PR  オープンされてから 時間 す
- PR の URL  実際 リポジトリ名から自動generateされます
