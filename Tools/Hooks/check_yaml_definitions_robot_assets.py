#!/usr/bin/python3
"""
Check robot asset definitions in YAML files.

Validates robot asset definition files against JTD schema and checks for:
- Schema compliance
- Unique IDs across all assets
- Name uniqueness
- Proper sorting by ID
"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from pathlib import Path
from typing import List

from modules.definitions import find_duplicate_ids, sort_list_by_id
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml

# Constants
JTD_SCHEMA = "Specs/jtd/robot_assets.jtd.json"
ROBOT_ASSETS_FILE = Path("Modules/ContentKit/Resources/Content/definitions/robot_assets.yml")

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def get_all_robot_assets_ids() -> List[str]:
    """
    Get list of all robot asset IDs from robot_assets.yml.

    Returns:
        List of robot asset IDs
    """
    try:
        robot_assets = load_yaml(ROBOT_ASSETS_FILE)
        if not robot_assets:
            return []

        ids: List[str] = []
        for item in robot_assets["list"]:
            ids.append(item["id"])
        return ids

    except (OSError, IOError) as e:
        logger.error(f"Error loading robot assets: {e}")
        return []


def get_all_robot_assets_names() -> List[str]:
    """
    Get list of all robot asset names from robot_assets.yml.

    Returns:
        List of robot asset names
    """
    try:
        robot_assets = load_yaml(ROBOT_ASSETS_FILE)
        if not robot_assets:
            return []

        names: List[str] = []
        for item in robot_assets["list"]:
            names.append(item["name"])
        return names

    except (OSError, IOError) as e:
        logger.error(f"Error loading robot assets: {e}")
        return []


def check_robot_assets_definitions(filename: str) -> bool:
    """
    Check robot assets definitions in a YAML file.

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

        # Sort list by ID if needed
        if sorted_list := sort_list_by_id(data["list"]):
            data["list"] = sorted_list
            dump_yaml(filename, data)
            logger.info(f"\n💡 Sorted assets by ID in {filename}")

        # Check for duplicate IDs
        if duplicate_ids := find_duplicate_ids(get_all_robot_assets_ids()):
            file_is_valid = False
            logger.error(f"\n❌ Found duplicate IDs in {filename}:")
            for duplicate_id in duplicate_ids:
                logger.error(f"   - {duplicate_id}")

        # Check for duplicate names
        if duplicate_names := find_duplicate_ids(get_all_robot_assets_names()):
            file_is_valid = False
            logger.error(f"\n❌ Found duplicate names in {filename}:")
            for duplicate_name in duplicate_names:
                logger.error(f"   - {duplicate_name}")

        return file_is_valid

    except (OSError, IOError) as e:
        logger.error(f"Error processing {filename}: {e}")
        return False


def main() -> int:
    """Validate robot asset definition files"""
    files: List[str] = get_files()

    if not files:
        logger.info("\n✅ No robot asset definition files to check!")
        return 0

    logger.info(f"\nChecking {len(files)} robot asset definition files...")

    has_errors = False
    for file in files:
        if not check_robot_assets_definitions(file):
            has_errors = True

    if has_errors:
        return 1

    logger.info("\n✅ All robot asset definition files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
