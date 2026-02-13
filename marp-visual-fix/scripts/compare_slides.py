#!/usr/bin/env python3
"""
Marp スライド画像の比較スクリプト

修正前後の画像を比較し、差分を検出します。
ImageMagickのcompositeコマンドを使用します。

使用方法:
    python compare_slides.py <before_image> <after_image> [threshold]

例:
    python compare_slides.py before.001.png after.001.png
    python compare_slides.py before.001.png after.001.png 0.01
"""

import subprocess
import sys
from pathlib import Path


def compare_images(before_path: str, after_path: str, threshold: float = 0.001) -> dict:
    """
    2つの画像を比較し、差分の度合いを返します。

    Args:
        before_path: 比較元画像のパス
        after_path: 比較先画像のパス
        threshold: 許容する差分の閾値（0.0-1.0）

    Returns:
        比較結果を含む辞書
    """
    before = Path(before_path)
    after = Path(after_path)

    if not before.exists():
        return {"error": f"ファイルが見つかりません: {before}"}
    if not after.exists():
        return {"error": f"ファイルが見つかりません: {after}"}

    try:
        # ImageMagickで差分を計算
        result = subprocess.run(
            [
                "composite",
                "-compose", "difference",
                str(before),
                str(after),
                "-"
            ],
            capture_output=True,
            check=True
        )

        # 差分画像から平均値を取得
        identify_result = subprocess.run(
            [
                "identify",
                "-format", "%[mean]",
                "-"
            ],
            input=result.stdout,
            capture_output=True,
            check=True
        )

        mean_diff = float(identify_result.stdout.decode().strip())

        # 差分をパーセンテージに正規化（16bit = 65535）
        normalized_diff = mean_diff / 65535.0

        return {
            "before": str(before),
            "after": str(after),
            "difference": normalized_diff,
            "threshold": threshold,
            "passed": normalized_diff < threshold,
            "message": "差分なし" if normalized_diff < threshold else f"差分検出: {normalized_diff:.6f}"
        }

    except subprocess.CalledProcessError as e:
        return {"error": f"ImageMagick実行エラー: {e}"}
    except FileNotFoundError:
        return {"error": "ImageMagickがインストールされていません。 'apt install imagemagick' を実行してください。"}


def compare_slide_sets(before_pattern: str, after_pattern: str, threshold: float = 0.001) -> list:
    """
    複数のスライド画像を比較します。

    Args:
        before_pattern: 比較元のファイルパターン（例: before.*.png）
        after_pattern: 比較先のファイルパターン（例: after.*.png）
        threshold: 許容する差分の閾値

    Returns:
        各スライドの比較結果のリスト
    """
    before_dir = Path(before_pattern).parent
    before_glob = Path(before_pattern).name

    before_files = sorted(before_dir.glob(before_glob))
    results = []

    for before_file in before_files:
        # 対応するafterファイルを探す
        after_file = Path(after_pattern.replace("*", before_file.stem.split(".")[-1]))

        if after_file.exists():
            result = compare_images(str(before_file), str(after_file), threshold)
            results.append(result)
        else:
            results.append({
                "before": str(before_file),
                "after": str(after_file),
                "error": "対応するファイルが見つかりません"
            })

    return results


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    before_path = sys.argv[1]
    after_path = sys.argv[2]
    threshold = float(sys.argv[3]) if len(sys.argv) > 3 else 0.001

    result = compare_images(before_path, after_path, threshold)

    if "error" in result:
        print(f"エラー: {result['error']}")
        sys.exit(1)

    print(f"比較元: {result['before']}")
    print(f"比較先: {result['after']}")
    print(f"差分: {result['difference']:.6f}")
    print(f"閾値: {result['threshold']}")
    print(f"結果: {'✓ 合格' if result['passed'] else '✗ 不合格'}")

    sys.exit(0 if result['passed'] else 1)


if __name__ == "__main__":
    main()
