#!/bin/bash
#
# Marp スライドをPNG画像にエクスポートするスクリプト
#
# 使用方法:
#   ./export_png.sh <markdown_file> [theme_css] [output_dir]
#
# 例:
#   ./export_png.sh slides.md
#   ./export_png.sh slides.md custom-theme.css
#   ./export_png.sh slides.md custom-theme.css ./output

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "使用方法: $0 <markdown_file> [theme_css] [output_dir]"
    exit 1
fi

MARKDOWN_FILE="$1"
THEME_CSS="${2:-}"
OUTPUT_DIR="${3:-.}"

if [ ! -f "$MARKDOWN_FILE" ]; then
    echo "エラー: ファイルが見つかりません: $MARKDOWN_FILE"
    exit 1
fi

BASENAME=$(basename "$MARKDOWN_FILE" .md)
OUTPUT_FILE="$OUTPUT_DIR/${BASENAME}.png"

mkdir -p "$OUTPUT_DIR"

echo "エクスポート中: $MARKDOWN_FILE -> $OUTPUT_FILE"

if [ -n "$THEME_CSS" ]; then
    npx @marp-team/marp-cli@latest \
        "$MARKDOWN_FILE" \
        --output "$OUTPUT_FILE" \
        --theme-set "$THEME_CSS" \
        --images png
else
    npx @marp-team/marp-cli@latest \
        "$MARKDOWN_FILE" \
        --output "$OUTPUT_FILE" \
        --images png
fi

echo "エクスポート完了"
echo "生成されたファイル:"
ls -la "$OUTPUT_DIR/${BASENAME}".*.png 2>/dev/null || ls -la "$OUTPUT_FILE"
