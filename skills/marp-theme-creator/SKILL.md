---
name: marp-theme-creator
description: Marp用カスタムテーマの新規作成。SCSS/CSSでのテーマ設計、カラーパレット定義、タイポグラフィ設定、スライドクラス実装を支援。「新しいMarpテーマを作りたい」などのリクエスト時に使用。
---

# Marp Theme Creator スキル

Marp用のカスタムテーマを新規作成するスキル。

## 使用タイミング

- 「新しいMarpテーマを作りたい」
- 「会社用のテーマを作成」
- 「カスタムテーマを設計」
- 「スライドのデザインを統一したい」

## ワークフロー

1. **要件確認**: ブランドカラー、フォント、用途を確認
2. **設計**: カラーパレット、タイポグラフィ、レイアウトを設計
3. **SCSS作成**: テーマのSCSSを記述
4. **スライドクラス実装**: lead, cover等のクラスを実装
5. **サンプルテスト**: サンプルスライドで確認

## 参照スキル

- **marp-knowledge**: テーマシステム仕様、CSS変数
- **marp-theme-builder**: ビルド環境構築（作成後）

## リファレンス

- [scss-structure.md](references/scss-structure.md) - SCSS構造ガイド
- [css-variables.md](references/css-variables.md) - CSS変数一覧
- [slide-classes.md](references/slide-classes.md) - スライドクラス実装

## アセット

- [theme-template.scss](assets/theme-template.scss) - テーマテンプレート
- [color-scheme-mixin.scss](assets/color-scheme-mixin.scss) - 配色mixin

## テーマ作成チェックリスト

### 必須項目

- [ ] `@theme`メタデータ
- [ ] `@size`メタデータ（16:9, 4:3）
- [ ] 基本セクションスタイル
- [ ] 見出し（h1-h6）スタイル
- [ ] 箇条書きスタイル
- [ ] コードブロックスタイル
- [ ] テーブルスタイル

### 推奨項目

- [ ] `lead`クラス（セクション区切り用）
- [ ] `cover`クラス（表紙用）
- [ ] ヘッダー/フッタースタイル
- [ ] ページ番号スタイル
- [ ] リンクスタイル
- [ ] 引用スタイル

### オプション

- [ ] `invert`クラス（反転テーマ）
- [ ] カスタムクラス
- [ ] ロゴ配置
- [ ] 背景装飾

## デザイン原則

1. **可読性優先**: コントラスト比4.5:1以上
2. **一貫性**: 色・フォントの統一
3. **シンプル**: 装飾は控えめに
4. **プロフェッショナル**: ビジネスに適したデザイン
