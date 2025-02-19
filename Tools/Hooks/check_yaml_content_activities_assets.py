#!/usr/bin/python3
"""
Check for duplicated image files in the Modules/ContentKit directory.
Helps prevent duplicate assets by detecting files with the same name but different extensions.
Excludes files in .xcassets directories.
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from collections import defaultdict
from pathlib import Path
from typing import List, Dict

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'svg'}


def get_files() -> List[Path]:
    """Get list of image files from Modules/ContentKit directory, excluding .xcasset directories"""
    files: List[Path] = []

    for ext in ALLOWED_EXTENSIONS:
        found_files = Path().glob(f'Modules/ContentKit/**/*.{ext}')
        files.extend([f for f in found_files if '.xcassets' not in str(f)])

    return files


def find_duplicates(files: List[Path]) -> Dict[str, List[Path]]:
    """Find and return duplicates as a dictionary with base names
    and their corresponding file paths"""
    file_count = defaultdict(list)
    duplicates: Dict[str, List[Path]] = {}

    for file in files:
        base_name = file.stem
        file_count[base_name].append(file)

    # Only keep base names that have more than one file
    duplicates = {name: paths for name, paths in file_count.items() if len(paths) > 1}

    return duplicates


def main() -> int:
    """Main function"""
    assets = get_files()
    duplicates = find_duplicates(assets)
    print("pwd:", Path.cwd())
    print("Number of files:", len(assets))

    if duplicates:
        print(f"\n❌ Duplicate files found: {len(duplicates)} base names")
        for base_name, paths in duplicates.items():
            print(f"   - \"{base_name}\":")
            for path in paths:
                print(f"        {path}")
        return 1

    print("\n✅ No duplicate files found!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
