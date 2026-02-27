# Marp テーマ GitHub Actions CI設定

## 目次

- [基本ワークフロー](#基本ワークフロー)
- [画像差分テストの詳細](#画像差分テストの詳細)
- [PRへのコメント追加](#prへのコメント追加)
- [マトリックスビルド](#マトリックスビルド)
- [キャッシュ設定](#キャッシュ設定)
- [条件付き実行](#条件付き実行)
- [Slack通知](#slack通知)
- [リリースワークフロー](#リリースワークフロー)

## 基本ワークフロー

```yaml
name: テーマビルドテスト

on:
  push:
    branches: [main]
  pull_request:
    types: [opened, synchronize, reopened]
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: リポジトリのチェックアウト
        uses: actions/checkout@v4

      - name: Node.jsセットアップ
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: sassインストール
        run: npm install -g sass

      - name: コミット済み画像をバックアップ
        run: |
          mkdir -p backup
          cp example/example.*.png backup/ 2>/dev/null || true

      - name: クリーンビルド
        run: make clean all

      - name: 画像差分チェック
        run: |
          for file in backup/*.png; do
            if [ -f "$file" ]; then
              name=$(basename "$file")
              result="$(composite -compose difference \
                "example/$name" \
                "$file" \
                - | \
                identify -format '%[mean]' -)"
              if (( $(echo "$result > 0.001 * 65535" | bc -l) )); then
                echo "差分検出: $name ($result)"
                exit 1
              fi
            fi
          done
          echo "すべての画像が一致しました"

      - name: ビルド結果をアーティファクトとして保存
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: example-slides
          path: example/
          retention-days: 7
```

## 画像差分テストの詳細

### ImageMagickを使用した差分検出

```yaml
- name: 画像差分チェック
  run: |
    THRESHOLD=0.001

    compare_images() {
      local orig="$1"
      local gen="$2"

      result="$(composite -compose difference "$gen" "$orig" - | \
        identify -format '%[mean]' -)"

      # 16bit画像の正規化
      normalized=$(echo "scale=10; $result / 65535" | bc)

      if (( $(echo "$normalized > $THRESHOLD" | bc -l) )); then
        echo "FAIL: $(basename $orig) - 差分: $normalized"
        return 1
      else
        echo "PASS: $(basename $orig) - 差分: $normalized"
        return 0
      fi
    }

    failed=0
    for backup_file in backup/*.png; do
      if [ -f "$backup_file" ]; then
        name=$(basename "$backup_file")
        if ! compare_images "$backup_file" "example/$name"; then
          failed=1
        fi
      fi
    done

    exit $failed
```

## PRへのコメント追加

```yaml
- name: PR にビルド結果を表示
  if: github.event_name == 'pull_request'
  uses: actions/github-script@v7
  with:
    script: |
      const fs = require('fs');
      const path = require('path');

      // 画像ファイルを探す
      const exampleDir = './example';
      const images = fs.readdirSync(exampleDir)
        .filter(f => f.endsWith('.png'))
        .sort();

      let body = '## スライドプレビュー\n\n';

      for (const img of images) {
        body += `### ${img}\n`;
        body += `見た目を確認してください。\n\n`;
      }

      body += '\n---\n*自動生成されたコメントです*';

      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: body
      });
```

## マトリックスビルド

```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        node: ['18', '20']

    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      # ...
```

## キャッシュ設定

```yaml
- name: npmキャッシュ
  uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
```

## 条件付き実行

```yaml
- name: テーマファイル変更時のみビルド
  if: |
    contains(github.event.head_commit.modified, 'marp-themes/') ||
    contains(github.event.head_commit.modified, 'example/')
  run: make all
```

## Slack通知

```yaml
- name: Slack通知（失敗時）
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "⚠️ Marpテーマビルド失敗: ${{ github.repository }}"
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## リリースワークフロー

```yaml
name: リリース

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: ビルド
        run: |
          npm install -g sass
          make all

      - name: リリースアセット作成
        run: |
          mkdir -p dist
          cp marp-themes/*.css dist/
          tar czf theme-${{ github.ref_name }}.tar.gz dist/

      - name: GitHubリリース作成
        uses: softprops/action-gh-release@v1
        with:
          files: theme-*.tar.gz
```
