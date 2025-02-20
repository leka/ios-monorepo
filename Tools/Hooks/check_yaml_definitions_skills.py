#!/usr/bin/python3
"""
Check skill definitions in YAML files.

Validates skill definition files against JTD schema and checks for:
- Schema compliance
- Unique skill IDs (including subskills)
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

from modules.definitions import find_duplicate_ids, sort_list_by_id, is_definition_list_valid
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml

# Constants
JTD_SCHEMA = "Specs/jtd/skills.jtd.json"
SKILLS_FILE = Path("Modules/ContentKit/Resources/Content/definitions/skills.yml")

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def get_all_skills() -> List[str]:
    """
    Get list of all skill IDs including subskills.

    Returns:
        List of skill IDs
    """
    try:
        skills = load_yaml(SKILLS_FILE)
        if not skills:
            return []

        ids: List[str] = []

        def find_skill_ids(data: List[Dict[str, Any]], ids: List[str]) -> None:
            for item in data:
                ids.append(item["id"])
                if "subskills" in item and item["subskills"]:
                    find_skill_ids(item["subskills"], ids)

        find_skill_ids(skills["list"], ids)
        return ids

    except Exception as e:
        logger.error(f"Error loading skills: {e}")
        return []


def check_skills_definitions(filename: str) -> bool:
    """
    Check skill definitions in a YAML file.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    try:
        file_is_valid = True

        # Check JTD schema compliance
        if not is_jtd_schema_compliant(filename, JTD_SCHEMA):
            logger.error(f"\n❌ Schema validation failed for {filename}")
            file_is_valid = False

        # Validate definition list (includes sha handling)
        if not is_definition_list_valid(filename):
            logger.error(f"\n❌ Definition list validation failed for {filename}")
            file_is_valid = False

        # Load and validate data
        data = load_yaml(filename)
        if not data:
            return False

        # Check for duplicate IDs recursively
        all_ids = get_all_skills()
        if duplicate_ids := find_duplicate_ids(all_ids):
            file_is_valid = False
            logger.error(f"\n❌ Found duplicate skill IDs in {filename}:")
            for duplicate_id in duplicate_ids:
                logger.error(f"   - {duplicate_id}")

        # Sort skills and subskills by ID if needed
        def sort_skills_recursive(skills: List[Dict[str, Any]]) -> bool:
            was_sorted = False
            if sorted_list := sort_list_by_id(skills):
                skills.clear()
                skills.extend(sorted_list)
                was_sorted = True

            for skill in skills:
                if "subskills" in skill and skill["subskills"]:
                    if sort_skills_recursive(skill["subskills"]):
                        was_sorted = True

            return was_sorted

        if sort_skills_recursive(data["list"]):
            dump_yaml(filename, data)
            logger.info(f"\n💡 Sorted skills and subskills by ID in {filename}")

        return file_is_valid

    except Exception as e:
        logger.error(f"Error processing {filename}: {e}")
        return False


def main() -> int:
    """Validate skill definition files"""
    files: List[str] = get_files()

    if not files:
        logger.info("\n✅ No skill definition files to check!")
        return 0

    logger.info(f"\nChecking {len(files)} skill definition files...")

    has_errors = False
    for file in files:
        if str(file) != str(SKILLS_FILE):
            continue

        if not check_skills_definitions(file):
            has_errors = True

    if has_errors:
        return 1

    logger.info("\n✅ All skill definition files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
