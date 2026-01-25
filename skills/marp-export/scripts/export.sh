#!/bin/bash
# Marp Export Script
# 統合エクスポートスクリプト - 複数形式への書き出しを簡単に

set -e

# デフォルト設定
SCALE=1
THEME=""
THEME_SET=""
ALLOW_LOCAL=false
OUTPUT_DIR=""
FORMATS=()

# ヘルプ表示
show_help() {
    cat << EOF
Usage: $(basename "$0") <input.md> [options]

Marpスライドを各種形式にエクスポートします。

Options:
  -f, --format FORMAT   出力形式 (pdf, png, pptx, html)
                        複数指定可: -f pdf -f png
  --all                 全形式で出力 (pdf, png, pptx, html)
  -o, --output DIR      出力ディレクトリ (デフォルト: 入力ファイルと同じ)
  --theme FILE          カスタムテーマCSS
  --theme-set DIR       テーマディレクトリ
  --scale N             PNG出力時のスケール (デフォルト: 1)
  --allow-local-files   ローカルファイルアクセスを許可
  -h, --help            このヘルプを表示

Examples:
  # PDF出力
  $(basename "$0") slide.md -f pdf

  # 高解像度PNG出力
  $(basename "$0") slide.md -f png --scale 2

  # 全形式出力
  $(basename "$0") slide.md --all

  # カスタムテーマでPDF出力
  $(basename "$0") slide.md -f pdf --theme ./theme.css --allow-local-files

  # 出力先ディレクトリ指定
  $(basename "$0") slide.md --all -o ./output/
EOF
}

# 引数パース
INPUT_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--format)
            FORMATS+=("$2")
            shift 2
            ;;
        --all)
            FORMATS=("pdf" "png" "pptx" "html")
            shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --theme)
            THEME="$2"
            shift 2
            ;;
        --theme-set)
            THEME_SET="$2"
            shift 2
            ;;
        --scale)
            SCALE="$2"
            shift 2
            ;;
        --allow-local-files)
            ALLOW_LOCAL=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            show_help
            exit 1
            ;;
        *)
            if [[ -z "$INPUT_FILE" ]]; then
                INPUT_FILE="$1"
            else
                echo "Error: Multiple input files not supported" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# 入力ファイル確認
if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: Input file required" >&2
    show_help
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File not found: $INPUT_FILE" >&2
    exit 1
fi

# 形式指定がない場合はPDFをデフォルトに
if [[ ${#FORMATS[@]} -eq 0 ]]; then
    FORMATS=("pdf")
fi

# 出力ディレクトリ設定
if [[ -z "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR=$(dirname "$INPUT_FILE")
fi
mkdir -p "$OUTPUT_DIR"

# ベースファイル名取得
BASENAME=$(basename "$INPUT_FILE" .md)

# 共通オプション構築
COMMON_OPTS=()
if [[ -n "$THEME" ]]; then
    COMMON_OPTS+=("--theme" "$THEME")
fi
if [[ -n "$THEME_SET" ]]; then
    COMMON_OPTS+=("--theme-set" "$THEME_SET")
fi
if [[ "$ALLOW_LOCAL" == "true" ]]; then
    COMMON_OPTS+=("--allow-local-files")
fi

# marpコマンド確認
if ! command -v marp &> /dev/null; then
    echo "Error: marp command not found. Install with: npm install -g @marp-team/marp-cli" >&2
    exit 1
fi

# エクスポート実行
echo "Exporting: $INPUT_FILE"
echo "Formats: ${FORMATS[*]}"
echo "Output directory: $OUTPUT_DIR"
echo ""

for format in "${FORMATS[@]}"; do
    OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.$format"

    case $format in
        pdf)
            echo "  -> $OUTPUT_FILE"
            marp "$INPUT_FILE" "${COMMON_OPTS[@]}" -o "$OUTPUT_FILE"
            ;;
        png)
            echo "  -> $OUTPUT_FILE (scale: $SCALE)"
            marp "$INPUT_FILE" "${COMMON_OPTS[@]}" --image-scale "$SCALE" -o "$OUTPUT_FILE"
            ;;
        pptx)
            echo "  -> $OUTPUT_FILE"
            marp "$INPUT_FILE" "${COMMON_OPTS[@]}" -o "$OUTPUT_FILE"
            ;;
        html)
            echo "  -> $OUTPUT_FILE"
            marp "$INPUT_FILE" "${COMMON_OPTS[@]}" --html -o "$OUTPUT_FILE"
            ;;
        *)
            echo "  Warning: Unknown format '$format', skipping" >&2
            ;;
    esac
done

echo ""
echo "Export completed!"

# 生成ファイル一覧
echo ""
echo "Generated files:"
for format in "${FORMATS[@]}"; do
    case $format in
        png)
            # PNGは連番ファイルになる可能性
            ls -la "$OUTPUT_DIR/$BASENAME"*.png 2>/dev/null || true
            ;;
        *)
            if [[ -f "$OUTPUT_DIR/$BASENAME.$format" ]]; then
                ls -la "$OUTPUT_DIR/$BASENAME.$format"
            fi
            ;;
    esac
done
