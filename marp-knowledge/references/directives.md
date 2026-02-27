# Marp ディレクティブ

## 目次

- [概要](#概要)
- [Frontmatter（YAML形式）](#frontmatteryaml形式)
- [グローバルディレクティブ](#グローバルディレクティブ)
- [ローカルディレクティブ](#ローカルディレクティブ)
- [スポットディレクティブ](#スポットディレクティブ)
- [複数クラスの指定](#複数クラスの指定)
- [例：表紙スライド](#例表紙スライド)

## 概要

Marpのディレクティブは、スライドの見た目や動作を制御するための特別な設定です。グローバルディレクティブとローカルディレクティブの2種類があります。

## Frontmatter（YAML形式）

ファイルの先頭にYAML形式で記述します。

```yaml
---
marp: true
theme: default
paginate: true
header: 'ヘッダーテキスト'
footer: 'フッターテキスト'
---
```

## グローバルディレクティブ

すべてのスライドに適用される設定です。

| ディレクティブ | 説明 | 例 |
|---------------|------|-----|
| `marp` | Marpを有効化 | `marp: true` |
| `theme` | テーマを指定 | `theme: default` / `theme: gaia` / `theme: uncover` |
| `paginate` | ページ番号表示 | `paginate: true` |
| `header` | ヘッダーテキスト | `header: 'タイトル'` |
| `footer` | フッターテキスト | `footer: '© 2024'` |
| `size` | スライドサイズ | `size: 16:9` / `size: 4:3` / `size: A4` |
| `style` | カスタムCSS | `style: \| section { background: #f5f5f5; }` |
| `headingDivider` | 見出しでの自動ページ分割 | `headingDivider: 2` |
| `math` | 数式エンジン | `math: mathjax` / `math: katex` |

## ローカルディレクティブ

特定のスライドにのみ適用される設定です。HTMLコメント形式で記述します。

### 基本構文

```markdown
---
スライド内容

<!--
_class: lead
_backgroundColor: #000
_color: #fff
-->
```

### 利用可能なローカルディレクティブ

| ディレクティブ | 説明 | 例 |
|---------------|------|-----|
| `_class` | CSSクラスを適用 | `_class: lead` |
| `_backgroundColor` | 背景色 | `_backgroundColor: #f0f0f0` |
| `_backgroundImage` | 背景画像 | `_backgroundImage: url('image.jpg')` |
| `_backgroundPosition` | 背景位置 | `_backgroundPosition: center` |
| `_backgroundRepeat` | 背景繰り返し | `_backgroundRepeat: no-repeat` |
| `_backgroundSize` | 背景サイズ | `_backgroundSize: cover` |
| `_color` | テキスト色 | `_color: #333` |
| `_header` | ヘッダー上書き | `_header: ''` （非表示） |
| `_footer` | フッター上書き | `_footer: ''` （非表示） |
| `_paginate` | ページ番号上書き | `_paginate: false` |

### アンダースコアなしディレクティブ

アンダースコアを付けない場合、そのスライド以降すべてに適用されます。

```markdown
<!--
class: invert
-->
このスライド以降すべてinvertクラスが適用される
```

## スポットディレクティブ

Marp CLI / VS Code拡張機能で使用できる追加ディレクティブ。

```html
<!-- fit -->
# タイトルをスライド幅に合わせてフィット
```

## 複数クラスの指定

スペース区切りで複数のクラスを指定できます。

```html
<!--
_class: lead invert
-->
```

## 例：表紙スライド

```markdown
---
marp: true
theme: default
paginate: true
---

<!--
_class: lead
_paginate: false
_header: ''
_footer: ''
-->

# プレゼンテーションタイトル

発表者名
2024年1月1日
```
