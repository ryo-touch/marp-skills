# Marp Skills

Claude Code用のMarpプレゼンテーションスキル集。

## スキル一覧

| スキル名 | 説明 |
|----------|------|
| [marp-knowledge](skills/marp-knowledge/) | Marpの包括的な知識ベース（他スキルの参照元） |
| [marp-markdown](skills/marp-markdown/) | Markdownスライド作成支援 |
| [marp-visual-fix](skills/marp-visual-fix/) | 表示崩れ・レイアウト問題の修正 |
| [marp-export](skills/marp-export/) | PDF/PNG/PPTX/HTMLへのエクスポート |
| [marp-theme-creator](skills/marp-theme-creator/) | カスタムテーマの新規作成 |
| [marp-theme-builder](skills/marp-theme-builder/) | ビルドパイプライン構築 |

## 依存関係

```
                    marp-knowledge (知識ベース)
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
   marp-markdown   marp-visual-fix   marp-theme-creator
                         │               │
                         ▼               ▼
                    marp-export    marp-theme-builder
```

## インストール

Claude Codeの設定でこのリポジトリをスキルとして追加してください。

## ライセンス

MIT License
