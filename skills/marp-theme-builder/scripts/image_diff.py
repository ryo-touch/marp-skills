#!/usr/bin/env python3
"""
Marp テーマの画像差分検出スクリプト

CIで使用し、コミット済みの画像とビルド結果を比較して
視覚的なリグレッションを検出します。

使用方法:
    python image_diff.py <original_dir> <generated_dir> [threshold]

例:
    python image_diff.py backup/ example/ 0.001

依存:
    - ImageMagick (composite, identify コマンド)
"""

import subprocess
import sys
from pathlib import Path
from typing import List, Tuple


def find_image_pairs(original_dir: Path, generated_dir: Path) -> List[Tuple[Path, Path]]:
    """
    比較対象の画像ペアを見つけます。

    Args:
        original_dir: オリジナル画像のディレクトリ
        generated_dir: 生成された画像のディレクトリ

    Returns:
        (オリジナル, 生成) のパスのタプルのリスト
    """
    pairs = []

    for orig_file in sorted(original_dir.glob("*.png")):
        gen_file = generated_dir / orig_file.name
        if gen_file.exists():
            pairs.append((orig_file, gen_file))

    return pairs


def compare_images(original: Path, generated: Path, threshold: float = 0.001) -> dict:
    """
    2つの画像を比較し、差分の度合いを返します。

    Args:
        original: オリジナル画像のパス
        generated: 生成された画像のパス
        threshold: 許容する差分の閾値

    Returns:
        比較結果を含む辞書
    """
    try:
        # ImageMagickで差分を計算
        composite_result = subprocess.run(
            [
                "composite",
                "-compose", "difference",
                str(original),
                str(generated),
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
            input=composite_result.stdout,
            capture_output=True,
            check=True
        )

        mean_diff = float(identify_result.stdout.decode().strip())
        # 16bit画像の場合は65535で正規化
        normalized_diff = mean_diff / 65535.0

        return {
            "original": str(original),
            "generated": str(generated),
            "difference": normalized_diff,
            "threshold": threshold,
            "passed": normalized_diff < threshold,
        }

    except subprocess.CalledProcessError as e:
        return {
            "original": str(original),
            "generated": str(generated),
            "error": f"ImageMagick実行エラー: {e}",
            "passed": False,
        }
    except FileNotFoundError:
        return {
            "original": str(original),
            "generated": str(generated),
            "error": "ImageMagickがインストールされていません",
            "passed": False,
        }


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    original_dir = Path(sys.argv[1])
    generated_dir = Path(sys.argv[2])
    threshold = float(sys.argv[3]) if len(sys.argv) > 3 else 0.001

    if not original_dir.exists():
        print(f"エラー: ディレクトリが見つかりません: {original_dir}")
        sys.exit(1)

    if not generated_dir.exists():
        print(f"エラー: ディレクトリが見つかりません: {generated_dir}")
        sys.exit(1)

    pairs = find_image_pairs(original_dir, generated_dir)

    if not pairs:
        print("比較対象の画像が見つかりませんでした")
        sys.exit(0)

    print(f"画像差分チェック (閾値: {threshold})")
    print("=" * 60)

    all_passed = True
    for original, generated in pairs:
        result = compare_images(original, generated, threshold)

        if "error" in result:
            status = "✗ エラー"
            detail = result["error"]
            all_passed = False
        elif result["passed"]:
            status = "✓ OK"
            detail = f"差分: {result['difference']:.6f}"
        else:
            status = "✗ 差分検出"
            detail = f"差分: {result['difference']:.6f} (閾値: {threshold})"
            all_passed = False

        print(f"{status} {original.name}")
        print(f"       {detail}")
        print()

    print("=" * 60)
    if all_passed:
        print("結果: すべての画像が一致しました")
        sys.exit(0)
    else:
        print("結果: 差分が検出されました")
        sys.exit(1)


if __name__ == "__main__":
    main()
