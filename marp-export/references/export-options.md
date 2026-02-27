# エクスポートオプション詳細

## 目次

- [共通オプション](#共通オプション)
- [PDF エクスポート](#pdf-エクスポート)
- [PNG エクスポート](#png-エクスポート)
- [PPTX エクスポート](#pptx-エクスポート)
- [HTML エクスポート](#html-エクスポート)
- [一括エクスポート](#一括エクスポート)
- [設定ファイル](#設定ファイル)

各出力形式で使用できるオプションの詳細リファレンスです。

## 共通オプション

| オプション | 説明 | 例 |
|------------|------|-----|
| `-o, --output` | 出力ファイル名 | `-o slide.pdf` |
| `--theme` | カスタムテーマCSS | `--theme ./custom.css` |
| `--theme-set` | テーマディレクトリ | `--theme-set ./themes/` |
| `--allow-local-files` | ローカルファイルアクセス許可 | （フラグのみ） |
| `--html` | HTML タグを有効化 | （フラグのみ） |

## PDF エクスポート

### 基本コマンド

```bash
marp slide.md -o slide.pdf
```

### PDF固有オプション

| オプション | 説明 | デフォルト |
|------------|------|------------|
| `--pdf-notes` | 発表者ノートを含める | false |
| `--pdf-outlines` | アウトライン（しおり）追加 | true |
| `--pdf-outlines.pages` | 各ページをアウトラインに | true |
| `--pdf-outlines.headings` | 見出しをアウトラインに | true |

### 使用例

```bash
# 発表者ノート付きPDF
marp slide.md --pdf-notes -o slide.pdf

# アウトラインなしPDF
marp slide.md --pdf-outlines false -o slide.pdf

# カスタムテーマでPDF出力
marp slide.md --theme ./theme.css --allow-local-files -o slide.pdf
```

### PDFサイズ指定

frontmatterでサイズを指定:

```yaml
---
marp: true
size: 16:9  # 標準ワイド（デフォルト）
---
```

利用可能なサイズ:
- `16:9` - 1280x720px（ワイドスクリーン）
- `4:3` - 960x720px（標準）
- `A4` - 210x297mm（縦向き印刷用）
- `A4-landscape` - 297x210mm（横向き印刷用）

## PNG エクスポート

### 基本コマンド

```bash
marp slide.md -o slide.png
```

複数スライドの場合、自動的に連番が付与:
- `slide.001.png`
- `slide.002.png`
- ...

### PNG固有オプション

| オプション | 説明 | デフォルト |
|------------|------|------------|
| `--image-scale` | 画像スケール（解像度） | 1 |
| `--images` | 画像形式指定 | png |

### 使用例

```bash
# 高解像度PNG（2倍スケール）
marp slide.md --image-scale 2 -o slide.png

# JPEG形式で出力
marp slide.md --images jpeg -o slide.jpg

# 特定スライドのみ（1ページ目）
marp slide.md --images png -o slide.png
# → slide.001.png のみ必要な場合は他を削除
```

### 解像度の目安

| スケール | 解像度（16:9） | 用途 |
|----------|---------------|------|
| 1 | 1280x720 | 画面表示、プレビュー |
| 2 | 2560x1440 | 高解像度ディスプレイ |
| 3 | 3840x2160 | 印刷、4K |

## PPTX エクスポート

### 基本コマンド

```bash
marp slide.md -o slide.pptx
```

### 注意事項

- **画像としてエクスポート**: 各スライドは編集不可の画像として埋め込まれる
- **アニメーション非対応**: Marpのアニメーション機能は静止画になる
- **フォント**: 埋め込まれないため、閲覧環境でフォントが変わる可能性あり

### 使用例

```bash
# 基本的なPPTXエクスポート
marp slide.md -o slide.pptx

# ローカル画像を含むスライド
marp slide.md --allow-local-files -o slide.pptx
```

### PPTXの用途

- PowerPointで発表する場合
- 他のPowerPointスライドと組み合わせる場合
- PowerPointしか受け付けない環境での配布

## HTML エクスポート

### 基本コマンド

```bash
marp slide.md -o slide.html
```

### HTMLの種類

1. **通常HTML**（外部リソース参照）
   ```bash
   marp slide.md -o slide.html
   ```

2. **スタンドアロンHTML**（リソース埋め込み）
   ```bash
   marp slide.md --html -o slide.html
   ```

### HTML固有オプション

| オプション | 説明 |
|------------|------|
| `--bespoke.transition` | スライド切替アニメーション |
| `--bespoke.progress` | 進捗バー表示 |
| `--watch` | ファイル監視（開発用） |
| `--server` | ローカルサーバー起動 |

### 使用例

```bash
# プレゼンテーションモード（進捗バー付き）
marp slide.md --bespoke.progress -o slide.html

# 開発サーバー起動（ライブリロード）
marp slide.md --server --watch

# スタンドアロンHTML（配布用）
marp slide.md --html --allow-local-files -o slide.html
```

### HTMLプレゼン操作

生成されたHTMLの操作方法:
- `→` / `Space` : 次のスライド
- `←` : 前のスライド
- `f` : フルスクリーン
- `o` : スライド一覧
- `p` : プレゼンターモード

## 一括エクスポート

複数形式を一度に出力する場合:

```bash
# 全形式出力
marp slide.md -o slide.pdf && \
marp slide.md -o slide.png && \
marp slide.md -o slide.pptx && \
marp slide.md -o slide.html
```

または `scripts/export.sh` を使用:

```bash
./scripts/export.sh slide.md --all
```

## 設定ファイル

`.marprc.yml` でデフォルト設定を定義:

```yaml
allowLocalFiles: true
html: true
theme: ./themes/custom.css
pdf:
  outlines: true
  notes: false
```

プロジェクトルートに配置すると自動適用されます。
