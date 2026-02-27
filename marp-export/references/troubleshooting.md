# エクスポート時のトラブルシューティング

## 目次

- [PDF関連](#pdf関連)
- [PNG関連](#png関連)
- [PPTX関連](#pptx関連)
- [HTML関連](#html関連)
- [共通の問題](#共通の問題)
- [デバッグ方法](#デバッグ方法)

Marpエクスポートでよくある問題と解決策です。

## PDF関連

### 画像が表示されない

**症状**: PDFに画像が含まれない、または壊れて表示される

**原因と解決策**:

1. **ローカルファイルアクセス権限**
   ```bash
   # --allow-local-files オプションを追加
   marp slide.md --allow-local-files -o slide.pdf
   ```

2. **画像パスが相対パス**
   ```markdown
   <!-- NG: 絶対パスや存在しないパス -->
   ![](C:\Users\image.png)

   <!-- OK: Markdownファイルからの相対パス -->
   ![](./images/photo.png)
   ```

3. **外部URL画像**
   ```markdown
   <!-- 外部URLは許可が必要 -->
   ![](https://example.com/image.png)
   ```
   ```bash
   marp slide.md --allow-local-files -o slide.pdf
   ```

### フォントが変わる

**症状**: 編集時と異なるフォントでPDFが生成される

**解決策**:

1. **Google Fontsを使用**（推奨）
   ```yaml
   ---
   marp: true
   style: |
     @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP&display=swap');
     section {
       font-family: 'Noto Sans JP', sans-serif;
     }
   ---
   ```

2. **ローカルフォントの埋め込み**
   - システムにフォントがインストールされていることを確認
   - フォント名を正確に指定

### 日本語が文字化けする

**症状**: 日本語テキストが□や?で表示される

**解決策**:

```yaml
---
marp: true
style: |
  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap');
  section {
    font-family: 'Noto Sans JP', sans-serif;
  }
  code {
    font-family: 'Noto Sans Mono', monospace;
  }
---
```

### PDFが重い

**症状**: ファイルサイズが大きすぎる

**解決策**:

1. **画像を最適化**
   - PNG → JPEG（写真の場合）
   - 画像サイズを縮小（表示サイズに合わせる）

2. **埋め込みフォントを減らす**
   - 使用フォント数を最小限に
   - font-weight のバリエーションを絞る

## PNG関連

### 解像度が低い

**症状**: 画像がぼやける、ピクセルが見える

**解決策**:

```bash
# スケールを上げる（2倍、3倍）
marp slide.md --image-scale 2 -o slide.png
marp slide.md --image-scale 3 -o slide.png
```

### ファイル名がずれる

**症状**: `slide.001.png` から始まってほしいが `slide.png` になる

**解決策**:

複数スライドがある場合、自動的に連番になります。
単一スライドの場合は連番なしで出力されます。

```bash
# 複数スライド → slide.001.png, slide.002.png, ...
# 単一スライド → slide.png
```

### 背景が透明になる

**症状**: PNG背景が透明で意図しない表示になる

**解決策**:

```yaml
---
marp: true
style: |
   section {
     background-color: white;
   }
---
```

## PPTX関連

### テキストが編集できない

**症状**: PowerPointで開いてもテキストを編集できない

**原因**:
Marpの PPTX エクスポートは各スライドを**画像として埋め込む**ため、テキスト編集は不可能です。

**代替策**:

1. Markdown ソースを編集して再エクスポート
2. PowerPoint で画像の上にテキストボックスを追加

### スライドサイズが合わない

**症状**: PowerPointの標準サイズと合わない

**解決策**:

frontmatterでサイズを指定:

```yaml
---
marp: true
size: 16:9  # PowerPoint標準ワイドと同じ
---
```

## HTML関連

### 画像が表示されない（HTML）

**症状**: ブラウザで開くと画像が表示されない

**解決策**:

1. **スタンドアロンモード**で画像を埋め込む
   ```bash
   marp slide.md --html --allow-local-files -o slide.html
   ```

2. **相対パスを維持**
   - HTMLファイルと同じディレクトリ構造で画像を配置

### オフラインで動かない

**症状**: インターネット接続なしでHTMLが正しく表示されない

**原因**: 外部CDNからスタイルやフォントを読み込んでいる

**解決策**:

```bash
# スタンドアロンHTMLを生成
marp slide.md --html --allow-local-files -o slide.html
```

### スマホで見られない

**症状**: モバイルブラウザで正しく表示されない

**解決策**:

HTMLのviewport設定は自動で含まれますが、問題がある場合:

```yaml
---
marp: true
style: |
  section {
    font-size: 24px; /* モバイル向けに調整 */
  }
---
```

## 共通の問題

### marp コマンドが見つからない

**症状**: `marp: command not found`

**解決策**:

```bash
# グローバルインストール
npm install -g @marp-team/marp-cli

# または npx で実行
npx @marp-team/marp-cli slide.md -o slide.pdf
```

### Chromiumがインストールされていない

**症状**: PDF/PNG出力時にChromiumエラー

**解決策**:

```bash
# Puppeteer の Chromium をインストール
npx puppeteer browsers install chrome

# または環境変数でChromeパスを指定
export CHROME_PATH=/usr/bin/google-chrome
marp slide.md -o slide.pdf
```

### メモリ不足

**症状**: 大量のスライドでエクスポートが失敗する

**解決策**:

1. **スライドを分割**してエクスポート
2. **画像サイズを縮小**
3. **Node.jsのメモリ上限を増やす**
   ```bash
   NODE_OPTIONS=--max-old-space-size=4096 marp slide.md -o slide.pdf
   ```

### エクスポートが途中で止まる

**症状**: 進行中にハングする

**解決策**:

```bash
# タイムアウトを延長
marp slide.md --timeout 120000 -o slide.pdf  # 120秒

# または分割してエクスポート
```

## デバッグ方法

### 詳細ログを出力

```bash
# 環境変数でデバッグモード
DEBUG=marp* marp slide.md -o slide.pdf
```

### HTMLで先にテスト

PDF/PNG で問題がある場合、先にHTMLで確認:

```bash
# HTMLで確認
marp slide.md -o slide.html
# ブラウザで開いて表示確認

# 問題なければPDFに
marp slide.md -o slide.pdf
```

### バージョン確認

```bash
marp --version
# 最新版でない場合はアップデート
npm update -g @marp-team/marp-cli
```
