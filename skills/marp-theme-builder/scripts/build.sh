#!/bin/bash
#
# Marp テーマビルドスクリプト
#
# SCSS→CSSコンパイルとサンプル画像生成を実行
#
# 使用方法:
#   ./build.sh [--watch]
#
# オプション:
#   --watch  ファイル変更を監視して自動リビルド

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}/.."

# デフォルトパス（プロジェクトルートからの相対パス）
SCSS_PATH="${SCSS_PATH:-marp-themes/theme.scss}"
CSS_PATH="${CSS_PATH:-marp-themes/theme.css}"
SRC_PATH="${SRC_PATH:-example/example.md}"
DST_PATH="${DST_PATH:-example/example.png}"

cd "$PROJECT_DIR"

# コマンド存在確認
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "エラー: $1 がインストールされていません"
        echo "インストール: $2"
        exit 1
    fi
}

check_command "sass" "npm install -g sass"
check_command "npx" "Node.jsをインストールしてください"

# SCSSコンパイル
compile_scss() {
    echo "SCSS コンパイル中: $SCSS_PATH -> $CSS_PATH"
    sass "$SCSS_PATH" "$CSS_PATH"
    echo "完了"
}

# サンプル画像生成
generate_images() {
    echo "サンプル画像生成中: $SRC_PATH -> $DST_PATH"
    npx @marp-team/marp-cli@latest \
        "$SRC_PATH" \
        --output "$DST_PATH" \
        --theme-set "$CSS_PATH" \
        --images png
    echo "完了"
}

# ウォッチモード
watch_mode() {
    echo "ウォッチモード開始 (Ctrl+C で終了)"
    echo ""

    # バックグラウンドでSCSSをウォッチ
    sass --watch "$SCSS_PATH" "$CSS_PATH" &
    SASS_PID=$!

    # Marpをウォッチ
    npx @marp-team/marp-cli@latest \
        "$SRC_PATH" \
        --watch \
        --output "$DST_PATH" \
        --theme-set "$CSS_PATH" \
        --images png &
    MARP_PID=$!

    # 終了シグナルをトラップ
    trap "kill $SASS_PID $MARP_PID 2>/dev/null; exit" INT TERM

    # 待機
    wait
}

# メイン処理
main() {
    if [ "${1:-}" = "--watch" ]; then
        watch_mode
    else
        compile_scss
        echo ""
        generate_images
        echo ""
        echo "ビルド完了"
        echo "生成ファイル:"
        ls -la "$CSS_PATH" 2>/dev/null || true
        ls -la "${DST_PATH%.png}".*.png 2>/dev/null || true
    fi
}

main "$@"
