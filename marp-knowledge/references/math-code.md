# Marp 数式とコード

## 目次

- [数式](#数式)
- [コードブロック](#コードブロック)
- [インラインコード](#インラインコード)
- [コードハイライトテーマ](#コードハイライトテーマ)
- [コードの注釈](#コードの注釈)
- [数式とコードの共存](#数式とコードの共存)
- [注意事項](#注意事項)

## 数式

### 有効化

frontmatterで数式エンジンを指定します。

```yaml
---
marp: true
math: mathjax
---
```

または

```yaml
---
marp: true
math: katex
---
```

### インライン数式

```markdown
テキスト内の数式 $E = mc^2$ です。
```

### ブロック数式

```markdown
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

### 数式の例

```markdown
## 二次方程式の解の公式

$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

## 行列

$$
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
\begin{pmatrix}
x \\
y
\end{pmatrix}
=
\begin{pmatrix}
ax + by \\
cx + dy
\end{pmatrix}
$$

## 総和

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$
```

## コードブロック

### 基本構文

````markdown
```言語名
コード
```
````

### シンタックスハイライト

対応言語：javascript, python, ruby, go, rust, java, c, cpp, csharp, php, shell, bash, yaml, json, sql, html, css, markdown など

````markdown
```javascript
function hello(name) {
  return `Hello, ${name}!`;
}
```
````

### 行番号なしの設定

デフォルトでは行番号は表示されません。CSSでカスタマイズ可能です。

### コードブロックの自動フィッティング

`@auto-scaling`が有効な場合、長いコードは自動的に縮小されます。

```css
pre > code svg[data-marp-fitting="svg"] {
  max-height: calc(580px - 1em);
}
```

## インラインコード

```markdown
変数 `count` を使用します。
```

### インラインコードのスタイリング

```css
code {
  background: #f0f0f0;
  padding: 0.1em 0.3em;
  border-radius: 3px;
  font-family: 'Roboto Mono', monospace;
}
```

## コードハイライトテーマ

highlight.jsのテーマを使用できます。

```css
@import url('https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.2.0/styles/github.min.css');
```

人気のテーマ：
- `github.min.css` - GitHub風
- `monokai.min.css` - 暗めのテーマ
- `tomorrow-night-blue.min.css` - 青い背景
- `vs2015.min.css` - Visual Studio風
- `atom-one-dark.min.css` - Atom風

## コードの注釈

Marpではコード内にマーカーを入れる機能は標準では提供されていませんが、HTMLを使って実現できます。

```html
<pre><code>
function example() {
  <mark>重要な行</mark>
  return true;
}
</code></pre>
```

## 数式とコードの共存

```markdown
---
marp: true
math: katex
---

# アルゴリズム解説

計算量は $O(n \log n)$ です。

```python
def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)
```

再帰の深さは平均 $\log n$ です。
```

## 注意事項

1. **数式エンジンはMarp CLI/VS Code拡張機能で動作**
2. **KaTeXの方が高速、MathJaxの方が互換性が高い**
3. **コードブロックの言語名は小文字で指定**
4. **長いコードはスクロールではなく縮小される**
