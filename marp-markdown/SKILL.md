---
name: marp-markdown
description: Marp用Markdownプレゼンテーションファイルの作成・編集。スライドコンテンツの執筆、frontmatter設定、ディレクティブ適用を支援。「スライドを作りたい」「プレゼンを作成」などのリクエスト時に使用。
---

# Marp Markdown スキル

Marp用のMarkdownプレゼンテーションを作成・編集するスキル。

## 使用タイミング

- 「スライドを作りたい」
- 「プレゼンを作成」
- 「Marpでスライドを作って」
- 「プレゼンテーションを書いて」

## ワークフロー

1. **要件確認**: ユーザーからプレゼンの目的、対象者、内容を確認
2. **テーマ選択**: テーマ（default/gaia/uncover/custom）を決定
3. **構成作成**: スライドの構成案を作成
4. **Markdown作成**: 実際のスライドを記述
5. **プレビュー確認**: プレビュースクリプトで確認

## 参照スキル

- **marp-knowledge**: ディレクティブ、構文、画像などの詳細仕様

## テンプレート

- [basic-template.md](assets/basic-template.md) - 基本テンプレート
- [speee-template.md](assets/speee-template.md) - Speeeテーマ用テンプレート
- [content-patterns.md](assets/content-patterns.md) - よくあるスライドパターン

## スクリプト

- [preview.sh](scripts/preview.sh) - HTMLプレビュー生成

## 基本構造

```markdown
---
marp: true
theme: default
paginate: true
---

<!--
_class: lead
_paginate: false
-->

# プレゼンテーションタイトル

発表者名
2024年1月1日

---

# 目次

1. はじめに
2. 本題
3. まとめ

---

# 本題

内容をここに記述

---

# まとめ

- ポイント1
- ポイント2
- ポイント3
```

## ベストプラクティス

1. **1スライド1メッセージ**: 詰め込みすぎない
2. **見出しは簡潔に**: 長い見出しは避ける
3. **箇条書きは5項目以内**: 多すぎると読みにくい
4. **画像を活用**: テキストだけより視覚的に
5. **表紙・目次・まとめを必ず入れる**
