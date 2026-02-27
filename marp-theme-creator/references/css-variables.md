# Marp CSS変数一覧

## 目次

- [Marp組み込み変数](#marp組み込み変数)
- [推奨カスタム変数](#推奨カスタム変数)
- [変数の継承](#変数の継承)
- [SCSSでの変数活用](#scssでの変数活用)
- [calc()との組み合わせ](#calcとの組み合わせ)
- [メディアクエリでの変更](#メディアクエリでの変更)
- [ダークモード対応](#ダークモード対応)
- [一覧表](#一覧表)

## Marp組み込み変数

Marpが内部で使用する変数。テーマで定義することで動作をカスタマイズ可能。

### スライドサイズ

```css
section {
  /* スライドの幅と高さ（@sizeメタデータで設定） */
  width: 1280px;
  height: 720px;
}
```

### 自動スケーリング

```css
/* フィッティング用SVGの最大高さ */
svg[data-marp-fitting="svg"] {
  max-height: 580px;  /* スライド高さ - パディング */
}
```

## 推奨カスタム変数

テーマで定義すると便利な変数。

### 色

```css
section {
  /* 基本色 */
  --color-background: #ffffff;
  --color-foreground: #333333;

  /* アクセント色 */
  --color-highlight: #0288d1;
  --color-dimmed: #666666;

  /* 背景パターン用 */
  --color-background-stripe: rgba(0,0,0,0.05);

  /* ボーダー色 */
  --color-border: #cccccc;
}
```

### 使用例

```css
section {
  background-color: var(--color-background);
  color: var(--color-foreground);
}

section a {
  color: var(--color-highlight);
}

section table th,
section table td {
  border-color: var(--color-border);
}
```

## 変数の継承

CSS変数はカスケードするため、クラスごとに上書き可能。

```css
/* 通常スライド */
section {
  --color-background: white;
  --color-foreground: #333;
}

/* 反転スライド */
section.invert {
  --color-background: #333;
  --color-foreground: white;
}

/* leadスライド */
section.lead {
  --color-background: linear-gradient(135deg, #667eea, #764ba2);
  --color-foreground: white;
}
```

## SCSSでの変数活用

SCSSの変数とCSS変数を組み合わせて使用。

```scss
// SCSS変数（コンパイル時に解決）
$primary-color: #003981;
$secondary-color: #005ea5;

// CSS変数としてエクスポート
section {
  --color-primary: #{$primary-color};
  --color-secondary: #{$secondary-color};
  --color-background: white;
  --color-foreground: #{$primary-color};
}
```

## calc()との組み合わせ

```css
section {
  --slide-padding: 40px;
  --content-max-height: calc(720px - var(--slide-padding) * 2);

  padding: var(--slide-padding);
}

svg[data-marp-fitting="svg"] {
  max-height: var(--content-max-height);
}
```

## メディアクエリでの変更

```css
/* 4:3 スライドサイズ */
@media (aspect-ratio: 4/3) {
  section {
    --slide-padding: 30px;
    --font-size-base: 24px;
  }
}

/* 16:9 スライドサイズ */
@media (aspect-ratio: 16/9) {
  section {
    --slide-padding: 40px;
    --font-size-base: 28px;
  }
}
```

## ダークモード対応

```css
/* ライトモード（デフォルト） */
section {
  --color-background: #ffffff;
  --color-foreground: #333333;
  --color-highlight: #0066cc;
}

/* ダークモード */
section.dark {
  --color-background: #1a1a2e;
  --color-foreground: #e0e0e0;
  --color-highlight: #6eb5ff;
}
```

## 一覧表

| 変数名 | 用途 | 例 |
|--------|------|-----|
| `--color-background` | 背景色 | `#ffffff` |
| `--color-foreground` | テキスト色 | `#333333` |
| `--color-highlight` | リンク・強調色 | `#0288d1` |
| `--color-dimmed` | 薄い色（フッター等） | `#666666` |
| `--color-border` | ボーダー色 | `#cccccc` |
| `--color-background-stripe` | テーブル縞模様 | `rgba(0,0,0,0.05)` |
| `--slide-padding` | スライドパディング | `40px` |
| `--font-size-base` | ベースフォントサイズ | `28px` |
