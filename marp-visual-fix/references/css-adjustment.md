# Marp CSS調整テクニック

## 目次

- [styleディレクティブの使用](#styleディレクティブの使用)
- [特定スライドのみスタイル変更](#特定スライドのみスタイル変更)
- [よく使うCSS調整](#よく使うcss調整)
- [Flexboxレイアウト](#flexboxレイアウト)
- [レスポンシブ対応（サイズ別）](#レスポンシブ対応サイズ別)
- [デバッグ用](#デバッグ用)

## styleディレクティブの使用

frontmatterでカスタムCSSを追加できます。

```yaml
---
marp: true
style: |
  section {
    font-size: 24px;
  }
  h1 {
    color: navy;
  }
---
```

## 特定スライドのみスタイル変更

### scopedスタイル

HTMLタグでスライドごとにスタイルを適用。

```markdown
---

<style scoped>
h1 { color: red; }
</style>

# このスライドだけ赤い見出し

---

# このスライドは通常の色
```

## よく使うCSS調整

### フォントサイズ

```css
/* 全体のベースサイズ */
section {
  font-size: 26px;
}

/* 見出しサイズ */
section h1 { font-size: 1.6em; }
section h2 { font-size: 1.3em; }
section h3 { font-size: 1.1em; }

/* コードサイズ */
section pre code {
  font-size: 0.65em;
}

/* 箇条書きサイズ */
section ul, section ol {
  font-size: 0.95em;
}
```

### 余白・パディング

```css
/* スライド全体の余白 */
section {
  padding: 40px 50px;
}

/* 見出し後の余白 */
section h1 {
  margin-bottom: 0.5em;
}

/* 箇条書きの間隔 */
section li {
  margin: 0.2em 0;
}

/* 段落の間隔 */
section p {
  margin: 0.8em 0;
}
```

### 行間

```css
section {
  line-height: 1.4;  /* 1.35-1.5が読みやすい */
}

section li {
  line-height: 1.3;
}

section pre code {
  line-height: 1.2;
}
```

### 色

```css
/* 文字色 */
section {
  color: #333;
}

/* 見出し色 */
section h1, section h2, section h3 {
  color: #003981;
}

/* リンク色 */
section a {
  color: #0066cc;
}

/* 背景色 */
section {
  background-color: #fafafa;
}
```

### テーブル

```css
/* テーブル全体 */
section table {
  width: 100%;
  font-size: 0.85em;
  border-collapse: collapse;
}

/* セル */
section th, section td {
  padding: 0.4em 0.6em;
  border: 1px solid #ccc;
}

/* ヘッダー行 */
section thead th {
  background: #003981;
  color: white;
}

/* 交互の行色 */
section tbody tr:nth-child(even) {
  background: #f5f5f5;
}
```

### 画像

```css
/* 画像のデフォルトスタイル */
section img {
  max-width: 100%;
  height: auto;
}

/* 画像に影 */
section img:not([alt*="bg"]) {
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  border-radius: 4px;
}
```

### コードブロック

```css
/* コードブロック全体 */
section pre {
  background: #2d2d2d;
  border-radius: 8px;
  padding: 1em;
}

/* インラインコード */
section code:not(pre code) {
  background: #f0f0f0;
  padding: 0.1em 0.3em;
  border-radius: 3px;
  font-size: 0.9em;
}
```

### 引用

```css
section blockquote {
  border-left: 4px solid #003981;
  padding-left: 1em;
  margin-left: 0;
  color: #555;
  font-style: italic;
}
```

## Flexboxレイアウト

### 中央揃え

```css
section.center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
```

### 左右分割

```css
section.split {
  display: flex;
  flex-direction: row;
}

section.split > * {
  flex: 1;
  padding: 0 1em;
}
```

## レスポンシブ対応（サイズ別）

```css
/* 16:9 */
@media (aspect-ratio: 16/9) {
  section {
    font-size: 28px;
  }
}

/* 4:3 */
@media (aspect-ratio: 4/3) {
  section {
    font-size: 24px;
  }
}
```

## デバッグ用

```css
/* 要素の境界を可視化 */
section * {
  outline: 1px solid rgba(255,0,0,0.2);
}

/* 背景色で領域確認 */
section header { background: rgba(255,0,0,0.1); }
section footer { background: rgba(0,255,0,0.1); }
```
