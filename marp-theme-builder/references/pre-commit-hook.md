# Marp テーマ Git pre-commit hook設定

## 概要

pre-commitフックを使用して、コミット前にビルドが成功することを確認します。
これにより、壊れたテーマや古い生成画像がコミットされることを防ぎます。

## 基本設定

### 1. hooksディレクトリ作成

```bash
mkdir -p .githooks
```

### 2. pre-commitスクリプト作成

`.githooks/pre-commit`:

```bash
#!/bin/sh

# ビルド実行
echo "pre-commit: ビルドチェック中..."
build_result=$(make 2>&1)
build_rc=$?

if [ $build_rc -ne 0 ]; then
    echo "====================================="
    echo "pre-commit: ビルド失敗"
    echo "====================================="
    echo "$build_result"
    echo ""
    echo "修正してから再度コミットしてください。"
    exit 1
fi

echo "pre-commit: ビルド成功"
exit 0
```

### 3. 実行権限付与

```bash
chmod +x .githooks/pre-commit
```

### 4. Gitに設定

```bash
git config core.hooksPath .githooks
```

## 発展的なパターン

### 生成ファイルの自動ステージング

```bash
#!/bin/sh

echo "pre-commit: ビルド実行中..."

# ビルド実行
if ! make; then
    echo "pre-commit: ビルド失敗"
    exit 1
fi

# 生成ファイルをステージに追加
git add marp-themes/*.css
git add example/example.*.png

echo "pre-commit: 完了"
exit 0
```

### 変更ファイルのみチェック

```bash
#!/bin/sh

# SCSSまたはMDが変更された場合のみビルド
changed_files=$(git diff --cached --name-only)

if echo "$changed_files" | grep -qE '\.(scss|md)$'; then
    echo "pre-commit: テーマ関連ファイルが変更されました。ビルド実行..."

    if ! make; then
        echo "pre-commit: ビルド失敗"
        exit 1
    fi

    # 生成ファイルを自動追加
    git add marp-themes/*.css example/example.*.png
fi

exit 0
```

### 画像差分チェック

```bash
#!/bin/sh

echo "pre-commit: ビルドと画像チェック中..."

# 現在の画像をバックアップ
mkdir -p /tmp/marp-backup
cp example/example.*.png /tmp/marp-backup/ 2>/dev/null || true

# ビルド実行
if ! make clean all; then
    echo "pre-commit: ビルド失敗"
    exit 1
fi

# 画像差分チェック（オプション）
if command -v composite &> /dev/null; then
    for backup in /tmp/marp-backup/*.png; do
        if [ -f "$backup" ]; then
            name=$(basename "$backup")
            if [ -f "example/$name" ]; then
                diff=$(composite -compose difference \
                    "example/$name" "$backup" - | \
                    identify -format '%[mean]' -)

                if [ "$(echo "$diff > 0.001" | bc)" -eq 1 ]; then
                    echo "警告: 画像に差分があります: $name"
                fi
            fi
        fi
    done
fi

rm -rf /tmp/marp-backup

echo "pre-commit: 完了"
exit 0
```

## Makefile統合

`make init` で自動設定:

```makefile
init:
	@echo "Git hooksを設定中..."
	git config core.hooksPath .githooks
	@echo "sassをインストール中..."
	npm install -g sass
	@echo "初期化完了"
```

## トラブルシューティング

### hookが実行されない

```bash
# 設定確認
git config --get core.hooksPath

# 権限確認
ls -la .githooks/pre-commit

# 手動実行テスト
./.githooks/pre-commit
```

### hookをスキップしたい場合

```bash
# 一時的にスキップ（非推奨）
git commit --no-verify -m "緊急修正"
```

### hookを無効化

```bash
# hooksPathをデフォルトに戻す
git config --unset core.hooksPath
```

## ベストプラクティス

1. **高速に保つ**: hookは数秒以内に完了するべき
2. **エラーメッセージを明確に**: 何が問題かわかるように
3. **スキップ不可にしない**: 緊急時用に`--no-verify`を許容
4. **CI と併用**: hookは開発者向け、CIは最終防衛線
5. **チームで共有**: `.githooks/`をリポジトリにコミット
