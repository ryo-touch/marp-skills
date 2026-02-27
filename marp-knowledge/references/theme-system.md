# Marp テーマシステム

## 目次

- [概要](#概要)
- [テーマメタデータ](#テーマメタデータ)
- [スライドサイズ](#スライドサイズ)
- [セクション（スライド）スタイリング](#セクションスライドスタイリング)
- [スライドクラス](#スライドクラス)
- [ヘッダー・フッター](#ヘッダーフッター)
- [ページ番号](#ページ番号)
- [CSS変数](#css変数)
- [自動スケーリング](#自動スケーリング)
- [テーマの継承](#テーマの継承)
- [Webフォントの使用](#webフォントの使用)
- [SCSSでの開発](#scssでの開発)

## 概要

MarpのテーマはCSSで定義されます。カスタムテーマを作成する際には、特別なメタデータコメントとCSS変数を使用します。

## テーマメタデータ

テーマファイルの先頭にコメントで記述します。

```css
/*!
 * @theme my-theme
 * @auto-scaling true
 * @size 16:9 1280px 720px
 * @size 4:3 960px 720px
 */
```

### メタデータ一覧

| メタデータ | 説明 | 例 |
|-----------|------|-----|
| `@theme` | テーマ名（必須） | `@theme custom-theme` |
| `@auto-scaling` | テキスト自動スケーリング | `@auto-scaling true` |
| `@size` | スライドサイズ定義 | `@size 16:9 1280px 720px` |

## スライドサイズ

複数のサイズを定義できます。

```css
/*!
 * @theme my-theme
 * @size 16:9 1280px 720px
 * @size 4:3 960px 720px
 * @size A4 794px 1123px
 * @size A4-landscape 1123px 794px
 */
```

## セクション（スライド）スタイリング

`section`セレクタでスライド全体をスタイリングします。

```css
section {
  width: 1280px;
  height: 720px;
  padding: 40px;
  background-color: white;
  color: #333;
  font-family: sans-serif;
  font-size: 28px;
}
```

## スライドクラス

`_class`ディレクティブで適用されるクラスを定義します。

```css
/* 通常スライド */
section {
  background: white;
  color: #333;
}

/* セクションタイトル用 */
section.lead {
  display: flex;
  flex-direction: column;
  justify-content: center;
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

/* 表紙用 */
section.cover {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: #1a1a2e;
  color: white;
}

/* 反転テーマ */
section.invert {
  background: #333;
  color: white;
}
```

## ヘッダー・フッター

```css
header {
  position: absolute;
  top: 20px;
  left: 40px;
  right: 40px;
  font-size: 18px;
  color: #666;
}

footer {
  position: absolute;
  bottom: 20px;
  left: 40px;
  right: 40px;
  font-size: 14px;
  color: #999;
  text-align: right;
}
```

## ページ番号

```css
section::after {
  /* ページ番号のスタイル */
  position: absolute;
  right: 40px;
  bottom: 20px;
  font-size: 18px;
  color: #999;
}
```

## CSS変数

テーマで使用できる組み込みCSS変数。

```css
section {
  --color-background: white;
  --color-foreground: #333;
  --color-highlight: #0288d1;
  --color-dimmed: #666;
}
```

## 自動スケーリング

`@auto-scaling`を有効にすると、テキストがスライドに収まるよう自動調整されます。

```css
/*!
 * @auto-scaling true
 */

/* フィッティング用SVGのスタイル調整 */
svg[data-marp-fitting="svg"] {
  max-height: 580px;
}
```

## テーマの継承

既存テーマを継承して拡張できます。

```css
/*!
 * @theme my-extended-theme
 */

@import 'default';

/* カスタマイズ */
section {
  font-family: 'Noto Sans JP', sans-serif;
}
```

## Webフォントの使用

Google Fontsなどを使用する場合。

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP&display=swap');

section {
  font-family: 'Noto Sans JP', sans-serif;
}
```

## SCSSでの開発

複雑なテーマはSCSSで開発し、CSSにコンパイルします。

```scss
// 変数定義
$color-primary: #003981;
$color-secondary: #005ea5;

// ミックスイン
@mixin color-scheme($bg, $text, $highlight) {
  --color-background: #{$bg};
  --color-foreground: #{$text};
  --color-highlight: #{$highlight};
}

section {
  @include color-scheme(white, $color-primary, $color-secondary);
}

section.lead {
  @include color-scheme($color-primary, white, lighten($color-secondary, 30%));
}
```
