#!/usr/bin/python3
"""
Check for duplicated asset files in the ContentKit module.
Prevents asset duplication by detecting files with the same base name but different extensions.

The script will:
- Scan for image files in the ContentKit directory
- Exclude files in .xcassets directories
- Report duplicates based on file base names
- Exit with status 1 if duplicates are found
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Set

# Constants
CONTENT_DIR = Path("Modules/ContentKit")
ALLOWED_EXTENSIONS: Set[str] = {'png', 'jpg', 'jpeg', 'svg'}
EXCLUDED_PATHS = {'.xcassets', '.imageset'}

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def get_files() -> List[Path]:
    """
    Get list of image files from ContentKit directory.

    Returns:
        List[Path]: List of image file paths
    """
    if not CONTENT_DIR.exists():
        logger.error(f"Directory not found: {CONTENT_DIR}")
        return []

    files: List[Path] = []

    try:
        for ext in ALLOWED_EXTENSIONS:
            found_files = CONTENT_DIR.rglob(f"*.{ext}")
            files.extend([
                f for f in found_files
                if not any(excluded in str(f) for excluded in EXCLUDED_PATHS)
            ])
    except (OSError, IOError) as e:
        logger.error(f"Error scanning files: {e}")
        return []

    return files


def find_duplicates(files: List[Path]) -> Dict[str, List[Path]]:
    """
    Find files with duplicate base names.

    Args:
        files: List of file paths to check

    Returns:
        Dict mapping base names to lists of duplicate file paths
    """
    file_count: Dict[str, List[Path]] = defaultdict(list)

    for file in files:
        base_name = file.stem
        file_count[base_name].append(file)

    return {
        name: paths
        for name, paths in file_count.items()
        if len(paths) > 1
    }


def main() -> int:
    """Main entry point"""
    logger.info(f"Scanning directory: {CONTENT_DIR}")

    assets = get_files()
    if not assets:
        logger.error("No files found to check")
        return 1

    logger.info(f"Found {len(assets)} files to check")

    duplicates = find_duplicates(assets)

    if duplicates:
        logger.error(f"\n❌ Found {len(duplicates)} duplicate base names:")
        for base_name, paths in duplicates.items():
            logger.error(f"\n   - \"{base_name}\":")
            for path in paths:
                logger.error(f"      {path.relative_to(Path.cwd())}")
        return 1

    logger.info("\n✅ No duplicate files found!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
