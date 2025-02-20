#!/usr/bin/python3
"""Check the content of YAML files for stories"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from multiprocessing import Pool, cpu_count
from typing import List

from modules.content import (
    is_created_at_present,
    is_last_edited_at_present,
    add_created_at,
    add_last_edited_at,
    update_last_edited_at,
    is_uuid_same_as_filename,
    is_name_same_as_filename,
    is_uuid_valid,
    find_missing_skills,
    find_missing_tags,
    find_missing_icons,
    find_string_values_starting_with_newline,
    find_empty_string_values,
)
from modules.utils import get_files, is_file_modified
from modules.yaml import create_yaml_object, is_jtd_schema_compliant

# Constants
JTD_SCHEMA = "Specs/jtd/story.jtd.json"

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def check_story(filename: str) -> bool:
    """
    Check the content of a YAML file for a story.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    yaml = create_yaml_object()
    file_is_valid = True

    try:
        if not is_jtd_schema_compliant(filename, JTD_SCHEMA):
            file_is_valid = False

        with open(filename, "r", encoding="utf8") as file:
            story = yaml.load(file)

        if differing_uuids := is_uuid_same_as_filename(story, filename):
            file_is_valid = False
            story_uuid, filename_uuid = differing_uuids
            logger.error(f"\n❌ Story uuid and filename uuid are not the same in {filename}")
            logger.error(f"uuid:     {story_uuid}")
            logger.error(f"filename: {filename_uuid}")

        if is_uuid_valid(story["uuid"]) is False:
            file_is_valid = False
            logger.error(f"\n❌ uuid not valid in {filename}")
            logger.error(f"uuid: {story['uuid']}")

        if differing_names := is_name_same_as_filename(story, filename):
            file_is_valid = False
            story_name, filename_name = differing_names
            logger.error(f"\n❌ Story name and filename name are not the same in {filename}")
            logger.error(f"name:     {story_name}")
            logger.error(f"filename: {filename_name}")

        if is_created_at_present(story) is False:
            file_is_valid = False
            logger.error(f"\n❌ Missing key created_at in {filename}")
            if timestamp := add_created_at(story):
                logger.error(f"Add created_at: {timestamp}")
                with open(filename, "w", encoding="utf8") as file:
                    yaml.dump(story, file)

        if is_last_edited_at_present(story) is False:
            file_is_valid = False
            logger.error(f"\n❌ Missing key last_edited_at in {filename}")
            if timestamp := add_last_edited_at(story):
                logger.error(f"Add last_edited_at: {timestamp}")
                with open(filename, "w", encoding="utf8") as file:
                    yaml.dump(story, file)

        if is_file_modified(filename) and (timestamp := update_last_edited_at(story)):
            file_is_valid = False
            logger.error(f"\n❌ last_edited_at  is not up to date in {filename}")
            logger.error(f"Update last_edited_at: {timestamp}")
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(story, file)

        if missing_skills := find_missing_skills(story["skills"]):
            file_is_valid = False
            logger.error(f"\n❌ Missing skills in {filename}:")
            for skill in missing_skills:
                logger.error(f"   - {skill}")

        if missing_tags := find_missing_tags(story["tags"]):
            file_is_valid = False
            logger.error(f"\n❌ Missing tags in {filename}:")
            for tag in missing_tags:
                logger.error(f"   - {tag}")

        if missing_icons := find_missing_icons(story, of_type="story"):
            file_is_valid = False
            logger.error(f"\n❌ Missing icons in {filename}:")
            for icon in missing_icons:
                logger.error(f"   - {icon}")

        if strings_with_newline := find_string_values_starting_with_newline(story):
            file_is_valid = False
            logger.error(f"\n❌ Found strings staring with newline in {filename}")
            for string in strings_with_newline:
                logger.error(f"  - {string}")

        if empty_string_value := find_empty_string_values(story):
            file_is_valid = False
            logger.error(f"\n❌ Found empty strings in {filename}")
            for string in empty_string_value:
                logger.error(f"  - {string}")

    except (OSError, IOError) as e:
        logger.error(f"Error processing {filename}: {e}")
        return False

    return file_is_valid


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    story_files: List[str] = get_files()

    if not story_files:
        logger.info("\n✅ No story files to check!")
        return 0

    workers = max(1, cpu_count() - 1)
    logger.info(f"\nChecking {len(story_files)} files using {workers} workers...")

    with Pool(processes=workers) as pool:
        results = pool.map(check_story, story_files)

    has_errors = not all(results)

    if has_errors:
        return 1

    logger.info("\n✅ All checked story files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
