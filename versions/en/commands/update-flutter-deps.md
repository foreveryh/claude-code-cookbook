## Update Flutter Deps

Update Flutter dependencies safely.

### Usage

```bash
# dependencies 状態 確認して Claude  依頼
flutter pub deps --style=compact
"pubspec.yaml  dependencies latestバージョン updateして"
```

### Basic Examples

```bash
# currentdependencies 確認
cat pubspec.yaml
"この Flutter project dependencies analyzeしてupdate可能なパッケージを教えて"

# アップグレード後 確認
flutter pub upgrade --dry-run
"こ アップグレード予定のcontentから破壊的changes あるか確認して"
```

### Claude Integration with Claude

```bash
# 包括的なdependenciesupdate
cat pubspec.yaml
"Flutter  dependencies analyzeし、以下を実行して：
1. 各パッケージ latestバージョン 調査
2. 破壊的changes 有無 確認
3. 危険度 evaluate（安全・注意・危険）
4. 必要なcodechanges suggest
5. update版 pubspec.yaml  generate"

# 安全なsequentialupdate
flutter pub outdated
"メジャーバージョンアップ 避けて、safelyアップデート可能なパッケージ みupdateして"

# identifyパッケージ update影響analyze
"provider  latestバージョン updateした場合 影響と必要なchangesを教えて"
```

### Detailed Examples

```bash
# Release Notes  含む詳細analyze
cat pubspec.yaml && flutter pub outdated
"dependencies analyzeし、各パッケージ ついて：
1. 現在 → latestバージョン
2. 危険度evaluate（安全・注意・危険）
3. 主なchanges点（CHANGELOG から）
4. 必要なcode修正
 テーブル形式 提示して"

# Null Safety 移行 analyze
cat pubspec.yaml
"Null Safety  対応していないパッケージ identifyし、移行planを立てて"
```

### 危険度 基準

```
安全（🟢）：
- パッチバージョンアップ（1.2.3 → 1.2.4）
- バグ修正 み
- 後方compatibility保証

注意（🟡）：
- マイナーバージョンアップ（1.2.3 → 1.3.0）
- 新Features追加
- 非推奨警告あり

危険（🔴）：
- メジャーバージョンアップ（1.2.3 → 2.0.0）
- 破壊的changes
- API  削除・changes
```

### update 実行

```bash
# バックアップ作成
cp pubspec.yaml pubspec.yaml.backup
cp pubspec.lock pubspec.lock.backup

# update実行
flutter pub upgrade

# update後 確認
flutter analyze
flutter test
flutter pub deps --style=compact
```

### Important Notes

update後 必ず動作確認 実施please。problem 発生した場合 以下 復元：

```bash
cp pubspec.yaml.backup pubspec.yaml
cp pubspec.lock.backup pubspec.lock
flutter pub get
```
