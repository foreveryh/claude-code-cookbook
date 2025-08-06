## Update Rust Deps

Update Rust dependencies and manage Cargo.toml.

### Usage

```bash
# dependencies 状態 確認して Claude  依頼
cargo tree
"Cargo.toml  dependencies latestバージョン updateして"
```

### Basic Examples

```bash
# currentdependencies 確認
cat Cargo.toml
"この Rust project dependencies analyzeしてupdate可能なクレートを教えて"

# update可能なlist 確認
cargo update --dry-run
"これら クレートのupdate おける危険度 analyzeして"
```

### Claude Integration with Claude

```bash
# 包括的なdependenciesupdate
cat Cargo.toml
"Rust  dependencies analyzeし、以下を実行して：
1. 各クレート latestバージョン 調査
2. 破壊的changes 有無 確認
3. 危険度 evaluate（安全・注意・危険）
4. 必要なcodechanges suggest
5. update版 Cargo.toml  generate"

# 安全なsequentialupdate
cargo tree
"メジャーバージョンアップ 避けて、safelyアップデート可能なクレート みupdateして"

# identifyクレート update影響analyze
"tokio  latestバージョン updateした場合 影響と必要なchangesを教えて"
```

### Detailed Examples

```bash
# Release Notes  含む詳細analyze
cat Cargo.toml && cargo tree
"dependencies analyzeし、各クレート ついて：
1. 現在 → latestバージョン
2. 危険度evaluate（安全・注意・危険）
3. 主なchanges点（CHANGELOG から）
4. トレイト境界 changes
5. 必要なcode修正
 テーブル形式 提示して"

# 非同期ランタイム 移行analyze
cat Cargo.toml src/main.rs
"async-std から tokio へ 移行、または tokio  メジャーバージョンアップ 必要なchanges すべて提示して"
```

### 危険度 基準

```
安全（🟢）：
- パッチバージョンアップ（0.1.2 → 0.1.3）
- バグ修正 み
- 後方compatibility保証

注意（🟡）：
- マイナーバージョンアップ（0.1.0 → 0.2.0）
- 新Features追加
- 非推奨警告あり

危険（🔴）：
- メジャーバージョンアップ（0.x.y → 1.0.0、1.x.y → 2.0.0）
- 破壊的changes
- API  削除・changes
- トレイト境界 changes
```

### update 実行

```bash
# バックアップ作成
cp Cargo.toml Cargo.toml.backup
cp Cargo.lock Cargo.lock.backup

# update実行
cargo update

# update後 確認
cargo check
cargo test
cargo clippy
```

### Important Notes

update後 必ず動作確認 実施please。problem 発生した場合 以下 復元：

```bash
cp Cargo.toml.backup Cargo.toml
cp Cargo.lock.backup Cargo.lock
cargo build
```
