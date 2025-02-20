#!/usr/bin/python3
"""
Check tag definitions in YAML files.

Validates tag definition files against JTD schema and checks for:
- Schema compliance
- Unique tag IDs (including subtags)
- Required fields
- Proper sorting by ID
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from pathlib import Path
from typing import Dict, List, Any

from modules.definitions import find_duplicate_ids, sort_list_by_id
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml

# Constants
JTD_SCHEMA = "Specs/jtd/tags.jtd.json"
TAGS_FILE = Path("Modules/ContentKit/Resources/Content/definitions/tags.yml")

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def get_all_tags() -> List[str]:
    """
    Get list of all tag IDs including subtags.

    Returns:
        List of tag IDs
    """
    try:
        tags = load_yaml(TAGS_FILE)
        if not tags:
            return []

        ids: List[str] = []

        def find_tag_ids(data: List[Dict[str, Any]], ids: List[str]) -> None:
            for item in data:
                ids.append(item["id"])
                if "subtags" in item and item["subtags"]:
                    find_tag_ids(item["subtags"], ids)

        find_tag_ids(tags["list"], ids)
        return ids

    except (OSError, IOError) as e:
        logger.error(f"Error loading tags: {e}")
        return []


def check_tags_definitions(filename: str) -> bool:
    """
    Check tag definitions in a YAML file.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    try:
        file_is_valid = True

        if not is_jtd_schema_compliant(filename, JTD_SCHEMA):
            logger.error(f"\n❌ Schema validation failed for {filename}")
            file_is_valid = False

        data = load_yaml(filename)
        if not data:
            return False

        # Sort tags and subtags by ID if needed
        def sort_tags_recursive(tags: List[Dict[str, Any]]) -> bool:
            was_sorted = False
            if sorted_list := sort_list_by_id(tags):
                tags.clear()
                tags.extend(sorted_list)
                was_sorted = True

            for tag in tags:
                if "subtags" in tag and tag["subtags"]:
                    if sort_tags_recursive(tag["subtags"]):
                        was_sorted = True

            return was_sorted

        if sort_tags_recursive(data["list"]):
            dump_yaml(filename, data)
            logger.info(f"\n💡 Sorted tags and subtags by ID in {filename}")

        # Check for duplicate IDs
        if duplicate_ids := find_duplicate_ids(get_all_tags()):
            file_is_valid = False
            logger.error(f"\n❌ Found duplicate tag IDs in {filename}:")
            for duplicate_id in duplicate_ids:
                logger.error(f"   - {duplicate_id}")

        return file_is_valid

    except (OSError, IOError) as e:
        logger.error(f"Error processing {filename}: {e}")
        return False


def main() -> int:
    """Validate tag definition files"""
    files: List[str] = get_files()

    if not files:
        logger.info("\n✅ No tag definition files to check!")
        return 0

    logger.info(f"\nChecking {len(files)} tag definition files...")

    has_errors = False
    for file in files:
        if str(file) != str(TAGS_FILE):
            continue

        if not check_tags_definitions(file):
            has_errors = True

    if has_errors:
        return 1

    logger.info("\n✅ All tag definition files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
