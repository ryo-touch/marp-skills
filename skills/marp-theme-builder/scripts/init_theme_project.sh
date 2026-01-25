#!/bin/bash
#
# Marp テーマプロジェクト初期化スクリプト
#
# 使用方法:
#   ./init_theme_project.sh <project_name> [theme_name]
#
# 例:
#   ./init_theme_project.sh my-company-theme
#   ./init_theme_project.sh my-company-theme company

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "使用方法: $0 <project_name> [theme_name]"
    exit 1
fi

PROJECT_NAME="$1"
THEME_NAME="${2:-${PROJECT_NAME}}"

echo "プロジェクト作成中: $PROJECT_NAME (テーマ名: $THEME_NAME)"

# ディレクトリ作成
mkdir -p "$PROJECT_NAME"/{.github/workflows,.githooks,marp-themes,example}
cd "$PROJECT_NAME"

# Git初期化
git init

# README作成
cat > README.md << EOF
# $PROJECT_NAME

Marpプレゼンテーションテーマ。

## セットアップ

\`\`\`bash
make init
\`\`\`

## ビルド

\`\`\`bash
make
\`\`\`

## 開発

\`\`\`bash
# SCSSの変更を監視
make csswatch

# スライド画像の自動再生成（別ターミナルで）
make marpwatch
\`\`\`

## テーマ使用方法

Markdownのfrontmatterで指定:

\`\`\`yaml
---
marp: true
theme: $THEME_NAME
---
\`\`\`
EOF

# Makefile作成
cat > Makefile << 'EOF'
CSS_PATH      = ./marp-themes/theme.css
SCSS_PATH     = ./marp-themes/theme.scss
SRC_PATH      = ./example/example.md
DST_BASE_PATH = ./example/example.png
DST_PATH      = ./example/example.001.png

all: $(DST_PATH)

init:
	git config core.hooksPath .githooks
	npm install -g sass

$(DST_PATH): $(CSS_PATH) $(SRC_PATH)
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --output $(DST_BASE_PATH) \
	  --theme-set $(CSS_PATH) \
	  --images png

marpwatch:
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --watch \
	  --output $(DST_BASE_PATH) \
	  --theme-set $(CSS_PATH) \
	  --images png

$(CSS_PATH): $(SCSS_PATH)
	sass $(SCSS_PATH) $(CSS_PATH)

csswatch:
	sass --watch $(SCSS_PATH) $(CSS_PATH)

clean:
	rm -f $(CSS_PATH) $(DST_PATH)

.PHONY: all init marpwatch csswatch clean
EOF

# 最小限のテーマSCSS
cat > marp-themes/theme.scss << EOF
/*!
 * @theme $THEME_NAME
 * @auto-scaling true
 * @size 16:9 1280px 720px
 * @size 4:3 960px 720px
 */

@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP&display=swap');

section {
  background-color: white;
  color: #333;
  font-family: 'Noto Sans JP', sans-serif;
  font-size: 28px;
  padding: 40px 50px;
  width: 1280px;
  height: 720px;
}

h1, h2, h3 {
  color: #003981;
}

section.lead {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: linear-gradient(135deg, #003981, #005ea5);
  color: white;

  h1 { color: white; text-align: center; }
}
EOF

# サンプルスライド
cat > example/example.md << EOF
---
marp: true
theme: $THEME_NAME
paginate: true
---

<!--
_class: lead
-->

# $THEME_NAME テーマ

サンプルプレゼンテーション

---

# 見出しサンプル

## h2見出し
### h3見出し

通常のテキストです。

---

# 箇条書き

- 項目1
- 項目2
- 項目3

1. 番号付き1
2. 番号付き2
EOF

# pre-commitフック
cat > .githooks/pre-commit << 'EOF'
#!/bin/sh

build_result=$(make)
build_rc=$?
if [ $build_rc -ne 0 ] ; then
    echo "git pre-commit check failed: build failed."
    exit 1
fi
EOF
chmod +x .githooks/pre-commit

# GitHub Actions
cat > .github/workflows/test.yml << 'EOF'
name: テーマビルドテスト

on:
  push:
    branches: [main]
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: sassインストール
        run: npm install -g sass
      - name: 画像バックアップ
        run: mkdir backup && mv example/example.*.png backup/ 2>/dev/null || true
      - name: ビルド
        run: make clean all
      - name: 画像差分チェック
        run: |
          if [ -f backup/example.001.png ]; then
            result="$(composite -compose difference example/example.001.png backup/example.001.png - | identify -format '%[mean]' -)"
            (( $(echo "0.001 > $result" | bc -l) )) || exit 1
          fi
      - name: アーティファクト保存
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: example-slides
          path: example/
EOF

# .gitignore
cat > .gitignore << 'EOF'
*.css.map
node_modules/
.DS_Store
EOF

echo ""
echo "プロジェクト作成完了: $PROJECT_NAME"
echo ""
echo "次のステップ:"
echo "  cd $PROJECT_NAME"
echo "  make init"
echo "  make"
