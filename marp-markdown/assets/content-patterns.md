# Marp スライドコンテンツパターン集

よくあるスライドパターンと記述例。

## 表紙パターン

### シンプルな表紙

```markdown
<!--
_class: lead
_paginate: false
-->

# タイトル

発表者名
2024年1月1日
```

### 会社ロゴ付き表紙

```markdown
<!--
_class: cover
_paginate: false
-->

# タイトル

![bg right:30% w:200](logo.png)

チーム名
2024年1月1日
```

## 目次パターン

### シンプルな目次

```markdown
# 目次

1. はじめに
2. 背景
3. 提案
4. まとめ
```

### 時間付き目次

```markdown
# アジェンダ

| セクション | 時間 |
|-----------|------|
| はじめに | 5分 |
| 背景説明 | 10分 |
| 提案内容 | 15分 |
| 質疑応答 | 10分 |
```

## セクション区切り

```markdown
<!--
_class: lead
-->

# セクション名
```

## 箇条書きパターン

### 基本

```markdown
# ポイント

- ポイント1
- ポイント2
- ポイント3
```

### 階層付き

```markdown
# 詳細説明

- 大項目1
    - 詳細A
    - 詳細B
- 大項目2
    - 詳細C
    - 詳細D
```

### 番号付き

```markdown
# 手順

1. ステップ1
2. ステップ2
3. ステップ3
```

## 比較パターン

### テーブル比較

```markdown
# 比較表

| 項目 | 案A | 案B |
|------|-----|-----|
| コスト | 低 | 高 |
| 速度 | 中 | 高 |
| 品質 | 高 | 高 |
```

### 左右分割

```markdown
# Before / After

![bg left:50%](before.png)
![bg right:50%](after.png)
```

## 画像配置パターン

### 中央配置

```markdown
# アーキテクチャ

![w:800](architecture.png)
```

### 右側配置

```markdown
![bg right:40%](image.png)

# タイトル

- テキストは左側
- 画像は右側40%
```

### 複数画像

```markdown
# スクリーンショット

![bg](screenshot1.png)
![bg](screenshot2.png)
![bg](screenshot3.png)
```

## 引用パターン

```markdown
# ユーザーの声

> この機能のおかげで作業時間が半分になりました。
> — 開発チームAさん
```

## コードパターン

### 基本

````markdown
# 実装例

```javascript
function greet(name) {
    return `Hello, ${name}!`;
}
```
````

### 複数言語

````markdown
# 多言語対応

**JavaScript**
```javascript
console.log("Hello");
```

**Python**
```python
print("Hello")
```
````

## 数値・データパターン

### KPI表示

```markdown
# 成果

## 導入効果

- **50%** 作業時間削減
- **30%** コスト削減
- **99.9%** 可用性達成
```

### グラフの代替

```markdown
# 推移

| 月 | 売上 |
|----|------|
| 1月 | ████████ 80 |
| 2月 | ██████████ 100 |
| 3月 | ████████████ 120 |
```

## まとめパターン

### 箇条書きまとめ

```markdown
# まとめ

- **ポイント1**: 説明
- **ポイント2**: 説明
- **ポイント3**: 説明
```

### アクションアイテム

```markdown
# Next Actions

| 項目 | 担当 | 期限 |
|------|------|------|
| タスク1 | 田中 | 1/15 |
| タスク2 | 鈴木 | 1/20 |
```

## 終了スライド

```markdown
<!--
_class: lead
-->

# ご清聴ありがとうございました

質疑応答・ディスカッション
```

## 連絡先

```markdown
<!--
_class: lead
-->

# Thank You!

📧 email@example.com
🔗 github.com/username
```
