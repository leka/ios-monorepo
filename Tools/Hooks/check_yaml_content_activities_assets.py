#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import glob
from collections import defaultdict
from pathlib import Path


def get_files():
    """Get list of files ending with .activity.asset.{png,jpg,svg}"""
    extensions = ['png', 'jpg', 'svg']
    files = []

    for ext in extensions:
        found_files = glob.glob(f'**/*.activity.asset.{ext}', recursive=True)  # Search in subdirectories
        files.extend(found_files)

    return files


def find_duplicates(files):
    """Find and return duplicates as a dictionary with base names and their corresponding file paths"""
    file_count = defaultdict(list)
    duplicates = {}

    for file in files:
        base_name = Path(file).stem.split('.activity.asset')[0]
        file_count[base_name].append(file)

    # Only keep base names that have more than one file
    for base_name, paths in file_count.items():
        if len(paths) > 1:
            duplicates[base_name] = paths

    return duplicates


def main():
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

    return 0


if __name__ == "__main__":
    sys.exit(main())
