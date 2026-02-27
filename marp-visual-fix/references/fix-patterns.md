# Marp 問題別修正パターン

## 目次

- [テキストはみ出し修正](#テキストはみ出し修正)
- [画像問題修正](#画像問題修正)
- [レイアウト修正](#レイアウト修正)
- [テーブル修正](#テーブル修正)
- [コードブロック修正](#コードブロック修正)
- [PDF出力修正](#pdf出力修正)

## テキストはみ出し修正

### パターン1: フォントサイズ調整

**適用場面**: 全体的にテキストが多い

```css
/* テーマまたはstyleディレクティブで */
section {
  font-size: 24px;  /* デフォルト28-30pxから縮小 */
}
```

### パターン2: 箇条書き間隔調整

**適用場面**: 箇条書きが多くて縦にあふれる

```css
section ul > li,
section ol > li {
  margin: 0.1em 0;  /* デフォルトより狭く */
  line-height: 1.2;
}
```

### パターン3: スライド分割

**適用場面**: 1スライドの内容が多すぎる

```markdown
# トピック（前半）

- 項目1
- 項目2
- 項目3

---

# トピック（後半）

- 項目4
- 項目5
```

## 画像問題修正

### パターン1: サイズ明示指定

**適用場面**: 画像サイズが不安定

```markdown
<!-- Before -->
![](image.png)

<!-- After -->
![w:600](image.png)
```

### パターン2: 背景画像の調整

**適用場面**: 背景画像が切れる/歪む

```markdown
<!-- Before -->
![bg](image.png)

<!-- After - 全体を表示 -->
![bg contain](image.png)

<!-- After - 全面を覆う -->
![bg cover](image.png)
```

### パターン3: 画像とテキストの分離

**適用場面**: 画像とテキストが重なる

```markdown
<!-- Before - 重なる -->
![bg](image.png)
# タイトル

<!-- After - 分割配置 -->
![bg left:40%](image.png)
# タイトル
テキストは右側に配置
```

## レイアウト修正

### パターン1: 中央揃え

**適用場面**: コンテンツを中央に配置したい

```css
section.center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}
```

```markdown
<!--
_class: center
-->
# 中央に配置されるコンテンツ
```

### パターン2: 余白調整

**適用場面**: 端に寄りすぎ/離れすぎ

```css
section {
  padding: 50px 60px;  /* 上下50px 左右60px */
}
```

### パターン3: ヘッダー/フッター非表示

**適用場面**: 特定スライドでヘッダー/フッターが不要

```markdown
<!--
_header: ''
_footer: ''
-->
```

## テーブル修正

### パターン1: テーブル幅制限

**適用場面**: テーブルがはみ出す

```css
section table {
  font-size: 0.8em;
  width: 100%;
  table-layout: fixed;
}

section table td,
section table th {
  word-wrap: break-word;
}
```

### パターン2: テーブル簡略化

**適用場面**: 列が多すぎる

```markdown
<!-- Before - 列が多い -->
| A | B | C | D | E | F |
|---|---|---|---|---|---|
| 1 | 2 | 3 | 4 | 5 | 6 |

<!-- After - 重要な列のみ -->
| A | C | E |
|---|---|---|
| 1 | 3 | 5 |
```

## コードブロック修正

### パターン1: フォントサイズ縮小

**適用場面**: コードが長い

```css
section pre code {
  font-size: 0.6em;  /* デフォルト0.7-0.8emから縮小 */
}
```

### パターン2: コード抜粋

**適用場面**: 全コードは不要で要点のみ示したい

```markdown
<!-- Before - 全コード -->
```python
def function():
    # たくさんのコード
    pass
```

<!-- After - 抜粋とコメント -->
```python
def function():
    # ... 初期化処理 ...
    result = important_operation()  # ← ここが重要
    # ... 後処理 ...
```
```

## PDF出力修正

### パターン1: ローカル画像使用

**適用場面**: 外部URLの画像がPDFで消える

```markdown
<!-- Before -->
![](https://example.com/image.png)

<!-- After - ローカルにダウンロードして使用 -->
![](./images/image.png)
```

### パターン2: Webフォント確認

**適用場面**: フォントが置き換わる

```css
/* フォントが読み込まれるまで待機 */
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP&display=swap');

section {
  font-family: 'Noto Sans JP', sans-serif;
}
```
