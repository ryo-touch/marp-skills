#!/bin/bash
#
# Marp スライドのHTMLプレビュー生成スクリプト
#
# 使用方法:
#   ./preview.sh <markdown_file> [theme_css]
#
# 例:
#   ./preview.sh slides.md
#   ./preview.sh slides.md custom-theme.css

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "使用方法: $0 <markdown_file> [theme_css]"
    exit 1
fi

MARKDOWN_FILE="$1"
THEME_CSS="${2:-}"

if [ ! -f "$MARKDOWN_FILE" ]; then
    echo "エラー: ファイルが見つかりません: $MARKDOWN_FILE"
    exit 1
fi

OUTPUT_FILE="${MARKDOWN_FILE%.md}.html"

if [ -n "$THEME_CSS" ]; then
    npx @marp-team/marp-cli@latest \
        "$MARKDOWN_FILE" \
        --output "$OUTPUT_FILE" \
        --theme-set "$THEME_CSS" \
        --html
else
    npx @marp-team/marp-cli@latest \
        "$MARKDOWN_FILE" \
        --output "$OUTPUT_FILE" \
        --html
fi

echo "プレビュー生成完了: $OUTPUT_FILE"

# ブラウザで開く（OS判定）
if command -v xdg-open &> /dev/null; then
    xdg-open "$OUTPUT_FILE"
elif command -v open &> /dev/null; then
    open "$OUTPUT_FILE"
else
    echo "ブラウザで $OUTPUT_FILE を開いてください"
fi
