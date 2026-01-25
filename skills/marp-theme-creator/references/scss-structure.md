# Marp テーマ SCSS構造ガイド

## 推奨ファイル構造

```
my-theme/
├── theme.scss         # メインテーマファイル
├── _variables.scss    # 変数定義
├── _mixins.scss       # ミックスイン
├── _base.scss         # ベーススタイル
├── _typography.scss   # タイポグラフィ
├── _components.scss   # コンポーネント（表、コード等）
└── _classes.scss      # スライドクラス
```

シンプルなテーマの場合は単一ファイルでも可。

## メインファイル構造

```scss
/*!
 * @theme my-theme
 * @auto-scaling true
 * @size 16:9 1280px 720px
 * @size 4:3 960px 720px
 */

// 1. 変数定義
$color-primary: #003981;
$color-secondary: #005ea5;
$color-background: #ffffff;
$color-text: #333333;
$font-family-base: 'Noto Sans JP', sans-serif;
$font-family-code: 'Roboto Mono', monospace;

// 2. フォント読み込み
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP&family=Roboto+Mono&display=swap');

// 3. ミックスイン定義
@mixin color-scheme($bg, $text, $highlight) {
  --color-background: #{$bg};
  --color-foreground: #{$text};
  --color-highlight: #{$highlight};
}

// 4. ベーススタイル
section {
  // ...
}

// 5. タイポグラフィ
h1, h2, h3, h4, h5, h6 {
  // ...
}

// 6. コンポーネント
table { /* ... */ }
pre { /* ... */ }
blockquote { /* ... */ }

// 7. スライドクラス
section.lead { /* ... */ }
section.cover { /* ... */ }
```

## 変数設計

### カラー変数

```scss
// プライマリカラー
$color-primary: #003981;
$color-primary-light: lighten($color-primary, 20%);
$color-primary-dark: darken($color-primary, 10%);

// セカンダリカラー
$color-secondary: #005ea5;

// テキストカラー
$color-text: #333333;
$color-text-light: #666666;
$color-text-muted: #999999;

// 背景カラー
$color-background: #ffffff;
$color-background-alt: #f5f5f5;

// アクセントカラー
$color-highlight: #0288d1;
$color-success: #28a745;
$color-warning: #ffc107;
$color-danger: #dc3545;
```

### タイポグラフィ変数

```scss
// フォントファミリー
$font-family-base: 'Noto Sans JP', 'Helvetica Neue', sans-serif;
$font-family-heading: 'Noto Sans JP', sans-serif;
$font-family-code: 'Roboto Mono', 'Consolas', monospace;

// フォントサイズ
$font-size-base: 28px;
$font-size-small: 0.85em;
$font-size-large: 1.2em;

// 見出しサイズ
$font-size-h1: 1.6em;
$font-size-h2: 1.3em;
$font-size-h3: 1.1em;
$font-size-h4: 1em;

// 行間
$line-height-base: 1.4;
$line-height-heading: 1.2;
```

### スペーシング変数

```scss
// 基本単位
$spacing-unit: 8px;

// パディング
$padding-slide: 40px 50px;
$padding-code: 0.5em;

// マージン
$margin-heading: 0 0 0.5em 0;
$margin-paragraph: 0.8em 0;
$margin-list-item: 0.2em 0;
```

## ミックスイン

### カラースキーム

```scss
@mixin color-scheme($bg, $text, $highlight) {
  --color-background: #{$bg};
  --color-foreground: #{$text};
  --color-highlight: #{$highlight};
  --color-dimmed: #{mix($text, $bg, 70%)};
  --color-background-stripe: #{rgba($text, 0.05)};
}
```

### Flexレイアウト

```scss
@mixin flex-center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

@mixin flex-split {
  display: flex;
  flex-direction: row;

  > * {
    flex: 1;
    padding: 0 1em;
  }
}
```

### テキストスタイル

```scss
@mixin text-shadow-light {
  text-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

@mixin text-truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

## ベストプラクティス

1. **CSS変数を活用**: テーマ内で一貫した値を使用
2. **ネストは3階層まで**: 深いネストは避ける
3. **コメントを付ける**: 各セクションの役割を明記
4. **モジュール化**: 大きなテーマは分割
5. **フォールバック**: Webフォントが読み込めない場合の代替
