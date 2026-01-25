---
name: marp-export
description: Marpスライドを各種形式（PDF, PNG, PPTX, HTML）にエクスポートするスキル。「PDFに変換」「スライドを書き出し」「画像で出力」「PowerPointにエクスポート」などのリクエストに対応。
---

# Marp Export スキル

Marpスライドを様々な形式にエクスポートするためのスキルです。

## 使用タイミング

- 「PDFに変換したい」
- 「スライドをPNGで書き出したい」
- 「PowerPoint形式で出力したい」
- 「HTMLとして保存したい」
- 「印刷用に書き出したい」
- 「各スライドを画像にしたい」

## サポート形式

| 形式 | 拡張子 | 用途 |
|------|--------|------|
| PDF | `.pdf` | 配布・印刷用（最も一般的） |
| PNG | `.png` | 画像埋め込み、SNS共有、差分確認 |
| PPTX | `.pptx` | PowerPointでの編集・発表 |
| HTML | `.html` | Webブラウザでの閲覧・配布 |

## ワークフロー

1. **入力ファイル確認**
   - Markdownファイルのパスを確認
   - frontmatterに `marp: true` があるか確認

2. **出力形式の決定**
   - ユーザーの用途に応じて形式を選択
   - 配布用 → PDF
   - 画像埋め込み → PNG
   - 編集可能 → PPTX
   - Web公開 → HTML

3. **オプション設定**
   - テーマCSS（カスタムテーマ使用時）
   - 出力先ディレクトリ
   - 画像解像度（PNG時）
   - ページサイズ（PDF時）

4. **エクスポート実行**
   - `scripts/export.sh` を使用
   - または直接 `marp` コマンドを実行

5. **結果確認**
   - ファイル生成を確認
   - 必要に応じてプレビュー

## 基本コマンド

```bash
# PDF出力
marp slide.md -o slide.pdf

# PNG出力（各スライドを個別画像に）
marp slide.md -o slide.png

# PPTX出力
marp slide.md -o slide.pptx

# HTML出力
marp slide.md -o slide.html
```

## よく使うオプション

```bash
# カスタムテーマを使用
marp slide.md --theme ./theme.css -o slide.pdf

# テーマディレクトリを指定
marp slide.md --theme-set ./themes/ -o slide.pdf

# 画像を許可（外部画像読み込み時に必要）
marp slide.md --allow-local-files -o slide.pdf

# HTMLをスタンドアロン化（画像埋め込み）
marp slide.md --html -o slide.html
```

## 参照スキル

- [marp-knowledge](../marp-knowledge/SKILL.md) - Marpの基礎知識
- [marp-visual-fix](../marp-visual-fix/SKILL.md) - エクスポート時の表示問題修正

## 参照ドキュメント

- [export-options.md](./references/export-options.md) - 各形式の詳細オプション
- [troubleshooting.md](./references/troubleshooting.md) - よくある問題と解決策

## スクリプト

- [export.sh](./scripts/export.sh) - 統合エクスポートスクリプト
