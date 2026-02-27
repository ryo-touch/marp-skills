# Marp 画像構文

## 目次

- [基本構文](#基本構文)
- [サイズ指定](#サイズ指定)
- [画像フィルター](#画像フィルター)
- [背景画像](#背景画像)
- [分割背景（Split Background）](#分割背景split-background)
- [複数の背景画像](#複数の背景画像)
- [背景色](#背景色)
- [画像の配置（Markdown内）](#画像の配置markdown内)
- [外部画像](#外部画像)
- [画像のアスペクト比維持](#画像のアスペクト比維持)
- [注意事項](#注意事項)

## 基本構文

Markdown標準の画像構文を使用します。

```markdown
![代替テキスト](image.png)
```

## サイズ指定

### 幅指定

```markdown
![width:300px](image.png)
![w:300px](image.png)
![w:50%](image.png)
```

### 高さ指定

```markdown
![height:200px](image.png)
![h:200px](image.png)
```

### 幅と高さ両方

```markdown
![width:300px height:200px](image.png)
![w:300 h:200](image.png)
```

## 画像フィルター

CSSフィルターを適用できます。

```markdown
![blur:5px](image.png)
![brightness:1.5](image.png)
![contrast:200%](image.png)
![drop-shadow:0,5px,10px,rgba(0,0,0,.4)](image.png)
![grayscale:100%](image.png)
![hue-rotate:180deg](image.png)
![invert:100%](image.png)
![opacity:50%](image.png)
![saturate:200%](image.png)
![sepia:100%](image.png)
```

## 背景画像

`bg`キーワードで背景画像として設定します。

### 基本的な背景

```markdown
![bg](background.jpg)
```

### サイズ指定

```markdown
![bg contain](image.png)    /* 全体が収まるように */
![bg cover](image.png)      /* 全体を覆うように */
![bg fit](image.png)        /* containと同じ */
![bg auto](image.png)       /* 元のサイズ */
![bg 50%](image.png)        /* パーセンテージ */
```

### 位置指定

```markdown
![bg left](image.png)
![bg right](image.png)
![bg top](image.png)
![bg bottom](image.png)
![bg center](image.png)
```

### 複合指定

```markdown
![bg right:30%](image.png)     /* 右側30%に配置 */
![bg left:40% contain](image.png)
```

## 分割背景（Split Background）

画面を分割して画像を配置します。

```markdown
![bg left](image.png)

# タイトル

テキストは右側に表示されます。
```

```markdown
![bg right:40%](image.png)

# タイトル

テキストは左側60%に表示されます。
```

## 複数の背景画像

複数の`![bg]`を使用すると、画像が並んで表示されます。

```markdown
![bg](image1.png)
![bg](image2.png)
![bg](image3.png)
```

### 縦方向に並べる

```markdown
![bg vertical](image1.png)
![bg](image2.png)
```

## 背景色

CSSで指定するか、ディレクティブを使用します。

```markdown
<!--
_backgroundColor: #f5f5f5
-->
```

## 画像の配置（Markdown内）

### 中央揃え

画像を段落として配置すると自動的に中央揃えになります。

```markdown
テキスト

![w:400](image.png)

次のテキスト
```

### インライン画像

```markdown
テキスト内に ![h:20](icon.png) アイコンを配置
```

## 外部画像

URL指定で外部画像を使用できます。

```markdown
![bg](https://example.com/image.jpg)
```

## 画像のアスペクト比維持

デフォルトでアスペクト比は維持されます。強制的に変形させる場合はCSSで。

```css
section img {
  object-fit: fill;
}
```

## 注意事項

1. **ローカルパスはスライドファイルからの相対パス**
2. **PDFエクスポート時は外部画像がダウンロードされる**
3. **大きな画像はビルド時間に影響する**
4. **GitHubのraw URLを使う場合は`raw.githubusercontent.com`を使用**
