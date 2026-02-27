# Marp スライドクラス実装パターン

## 目次

- [概要](#概要)
- [標準クラス](#標準クラス)
- [カスタムクラス例](#カスタムクラス例)
- [複数クラスの組み合わせ](#複数クラスの組み合わせ)
- [クラス設計のベストプラクティス](#クラス設計のベストプラクティス)
- [クラス一覧テンプレート](#クラス一覧テンプレート)

## 概要

`_class`ディレクティブで適用されるスライドクラスの実装パターン。

## 標準クラス

### lead（セクション区切り）

セクションの区切りや見出しスライドに使用。

```scss
section.lead {
  // 中央揃えレイアウト
  display: flex;
  flex-direction: column;
  justify-content: center;

  // 背景色変更
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;

  // 見出しスタイル
  h1, h2 {
    text-align: center;
    font-size: 2em;
  }

  // ページ番号非表示
  &::after {
    display: none;
  }
}
```

使用例:
```markdown
<!--
_class: lead
-->

# セクションタイトル
```

### cover（表紙）

プレゼンテーションの表紙に使用。

```scss
section.cover {
  // 中央揃え
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;

  // 背景
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  color: white;

  // 大きなタイトル
  h1 {
    font-size: 2.5em;
    margin-bottom: 0.5em;
  }

  // 日付・著者名
  p {
    font-size: 1.2em;
    color: rgba(255,255,255,0.8);
  }

  // ページ番号・ヘッダー・フッター非表示
  &::after { display: none; }
}
```

### invert（反転）

通常テーマの色を反転。

```scss
section.invert {
  @include color-scheme(
    #333333,  // 背景: 暗い
    #ffffff,  // テキスト: 白
    #6eb5ff   // ハイライト: 明るい青
  );

  // コードブロック調整
  pre > code {
    background: #1e1e1e;
  }
}
```

### center（中央揃え）

コンテンツを中央に配置。

```scss
section.center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;

  h1, h2, h3, p, ul, ol {
    text-align: center;
  }

  ul, ol {
    display: inline-block;
    text-align: left;
  }
}
```

## カスタムクラス例

### split（左右分割）

```scss
section.split {
  display: flex;
  flex-direction: row;
  padding: 40px;

  > .left, > .right {
    flex: 1;
    padding: 0 20px;
  }

  > .left {
    border-right: 1px solid rgba(0,0,0,0.1);
  }
}
```

※HTMLでの使用が必要:
```markdown
<!--
_class: split
-->

<div class="left">

# 左側
- 内容

</div>
<div class="right">

# 右側
- 内容

</div>
```

### emphasis（強調）

```scss
section.emphasis {
  background: #fff3cd;
  border-left: 8px solid #ffc107;

  h1 {
    color: #856404;
  }
}
```

### quote（引用メイン）

```scss
section.quote {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 80px;

  blockquote {
    font-size: 1.5em;
    font-style: italic;
    border: none;

    &::before {
      content: '"';
      font-size: 3em;
      color: rgba(0,0,0,0.2);
    }
  }
}
```

### code-focus（コードメイン）

```scss
section.code-focus {
  pre {
    font-size: 0.9em;
    max-height: none;
  }

  h1 {
    font-size: 1.2em;
    margin-bottom: 0.3em;
  }
}
```

## 複数クラスの組み合わせ

```markdown
<!--
_class: lead invert
-->
```

```scss
// lead + invertの組み合わせ
section.lead.invert {
  background: #1a1a1a;
  color: white;
}
```

## クラス設計のベストプラクティス

1. **最小限のクラス**: 3-5種類に抑える
2. **命名規則**: 目的がわかる名前
3. **組み合わせ対応**: 複数クラスの共存を考慮
4. **ドキュメント**: 使用方法を明記
5. **サンプル提供**: 各クラスの使用例を用意

## クラス一覧テンプレート

README等に記載する一覧:

```markdown
## スライドクラス

| クラス | 用途 | 背景 |
|--------|------|------|
| (なし) | 通常スライド | 白 |
| `lead` | セクション区切り | グラデーション |
| `cover` | 表紙 | ダーク |
| `invert` | 反転テーマ | 暗い |
| `center` | 中央揃え | 白 |
```
