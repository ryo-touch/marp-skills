# Marp テーマ Makefile構成パターン

## 目次

- [基本構造](#基本構造)
- [依存関係](#依存関係)
- [変数設計](#変数設計)
- [ターゲットパターン](#ターゲットパターン)
- [ヘルプの追加](#ヘルプの追加)
- [CI向け設定](#ci向け設定)
- [エラーハンドリング](#エラーハンドリング)

## 基本構造

```makefile
# パス定義
CSS_PATH      = ./marp-themes/theme.css
SCSS_PATH     = ./marp-themes/theme.scss
SRC_PATH      = ./example/example.md
DST_BASE_PATH = ./example/example.png
DST_PATH      = ./example/example.001.png ./example/example.002.png

# デフォルトターゲット
all: $(DST_PATH)

# 初期化
init:
	git config core.hooksPath .githooks
	npm install -g sass

# 画像生成（CSSとMDに依存）
$(DST_PATH): $(CSS_PATH) $(SRC_PATH)
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --output $(DST_BASE_PATH) \
	  --theme-set $(CSS_PATH) \
	  --images png

# CSSコンパイル（SCSSに依存）
$(CSS_PATH): $(SCSS_PATH)
	sass $(SCSS_PATH) $(CSS_PATH)

# ウォッチモード
csswatch:
	sass --watch $(SCSS_PATH) $(CSS_PATH)

marpwatch:
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --watch \
	  --output $(DST_BASE_PATH) \
	  --theme-set $(CSS_PATH) \
	  --images png

# クリーン
clean:
	rm -f $(CSS_PATH) $(DST_PATH)

.PHONY: all init csswatch marpwatch clean
```

## 依存関係

```
SCSS ──────> CSS ──────> PNG画像
  │           │            │
  │           │            │
  └───────────┴────────────┘
              │
           make all
```

## 変数設計

### 複数テーマ対応

```makefile
THEMES = theme1 theme2 theme3
CSS_FILES = $(patsubst %,marp-themes/%.css,$(THEMES))
SCSS_FILES = $(patsubst %,marp-themes/%.scss,$(THEMES))

all: $(CSS_FILES) images

marp-themes/%.css: marp-themes/%.scss
	sass $< $@
```

### 環境変数対応

```makefile
SASS_CMD ?= sass
MARP_CMD ?= npx @marp-team/marp-cli@latest

$(CSS_PATH): $(SCSS_PATH)
	$(SASS_CMD) $(SCSS_PATH) $(CSS_PATH)
```

## ターゲットパターン

### 初期化ターゲット

```makefile
init:
	@echo "プロジェクト初期化中..."
	git config core.hooksPath .githooks
	npm install -g sass
	@echo "完了"
```

### ビルドターゲット

```makefile
build: css images
	@echo "ビルド完了"

css: $(CSS_PATH)

images: $(DST_PATH)
```

### 開発用ターゲット

```makefile
dev:
	@echo "開発モード開始 (Ctrl+C で終了)"
	@make csswatch & make marpwatch

serve:
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --theme-set $(CSS_PATH) \
	  --server
```

### テストターゲット

```makefile
test: clean build
	@echo "ビルドテスト完了"

lint:
	npx stylelint "marp-themes/**/*.scss"
```

### クリーンターゲット

```makefile
clean:
	rm -f $(CSS_PATH) $(CSS_PATH).map
	rm -f example/example.*.png

distclean: clean
	rm -rf node_modules
```

## ヘルプの追加

```makefile
.DEFAULT_GOAL := help

help:
	@echo "使用可能なターゲット:"
	@echo "  make init      - 初期セットアップ"
	@echo "  make           - ビルド実行"
	@echo "  make csswatch  - SCSS監視モード"
	@echo "  make marpwatch - スライド監視モード"
	@echo "  make clean     - 生成ファイル削除"
```

## CI向け設定

```makefile
CI ?= false

ifeq ($(CI),true)
MARP_FLAGS = --allow-local-files
else
MARP_FLAGS =
endif

$(DST_PATH): $(CSS_PATH) $(SRC_PATH)
	npx @marp-team/marp-cli@latest \
	  $(SRC_PATH) \
	  --output $(DST_BASE_PATH) \
	  --theme-set $(CSS_PATH) \
	  --images png \
	  $(MARP_FLAGS)
```

## エラーハンドリング

```makefile
$(CSS_PATH): $(SCSS_PATH)
	@if ! command -v sass > /dev/null; then \
		echo "sassがインストールされていません。make init を実行してください。"; \
		exit 1; \
	fi
	sass $(SCSS_PATH) $(CSS_PATH)
```
