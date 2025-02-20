#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from multiprocessing import Pool, cpu_count

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
    find_missing_exercise_assets,
)
from modules.utils import get_files, is_file_modified
from modules.yaml import create_yaml_object, is_jtd_schema_compliant


JTD_SCHEMA = "Specs/jtd/activity.jtd.json"


def check_activity(filename: str) -> bool:
    """
    Check the content of a YAML file for an activity.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    yaml = create_yaml_object()

    file_is_valid = True

    if is_jtd_schema_compliant(filename, JTD_SCHEMA) is False:
        file_is_valid = False

    with open(filename, "r", encoding="utf8") as file:
        activity = yaml.load(file)

    if differing_uuids := is_uuid_same_as_filename(activity, filename):
        file_is_valid = False
        activity_uuid, filename_uuid = differing_uuids
        print(f"\n❌ Activity uuid and filename uuid are not the same in {filename}")
        print(f"uuid:     {activity_uuid}")
        print(f"filename: {filename_uuid}")

    if is_uuid_valid(activity["uuid"]) is False:
        file_is_valid = False
        print(f"\n❌ uuid not valid in {filename}")
        print(f"uuid: {activity['uuid']}")

    if differing_names := is_name_same_as_filename(activity, filename):
        file_is_valid = False
        activity_name, filename_name = differing_names
        print(f"\n❌ Activity name and filename name are not the same in {filename}")
        print(f"name:     {activity_name}")
        print(f"filename: {filename_name}")

    if is_created_at_present(activity) is False:
        file_is_valid = False
        print(f"\n❌ Missing key created_at in {filename}")
        if timestamp := add_created_at(activity):
            print(f"Add created_at: {timestamp}")
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(activity, file)

    if is_last_edited_at_present(activity) is False:
        file_is_valid = False
        print(f"\n❌ Missing key last_edited_at in {filename}")
        if timestamp := add_last_edited_at(activity):
            print(f"Add last_edited_at: {timestamp}")
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(activity, file)

    if is_file_modified(filename) and (timestamp := update_last_edited_at(activity)):
        file_is_valid = False
        print(f"\n❌ last_edited_at  is not up to date in {filename}")
        print(f"Update last_edited_at: {timestamp}")
        with open(filename, "w", encoding="utf8") as file:
            yaml.dump(activity, file)

    if missing_skills := find_missing_skills(activity["skills"]):
        file_is_valid = False
        print(f"\n❌ The following skills do not exist in {filename}")
        for skill in missing_skills:
            print(f"   - {skill}")

    if missing_tags := find_missing_tags(activity["tags"]):
        file_is_valid = False
        print(f"\n❌ The following tags do not exist in {filename}")
        for tag in missing_tags:
            print(f"   - {tag}")

    if missing_icons := find_missing_icons(activity, of_type="activity"):
        file_is_valid = False
        print(f"\n❌ The following icons do not exist in {filename}")
        for icon in missing_icons:
            print(f"   - {icon}")

    if strings_with_newline := find_string_values_starting_with_newline(activity):
        file_is_valid = False
        print(f"\n❌ Found strings staring with newline in {filename}")
        for string in strings_with_newline:
            print(f"  - {string}")

    if empty_string_value := find_empty_string_values(activity):
        file_is_valid = False
        print(f"\n❌ Found empty strings in {filename}")
        for string in empty_string_value:
            print(f"  - {string}")

    if missing_exercise_assets := find_missing_exercise_assets(activity):
        file_is_valid = False
        print(f"\n❌ The following assets do not exist in {filename}")
        for asset in missing_exercise_assets:
            print(f"   - {asset['source']} - {asset['type']} - {asset['value']}")

    return file_is_valid


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    activity_files = get_files()

    if not activity_files:
        print("\n✅ No activity files to check!")
        return 0

    workers = max(1, cpu_count() - 1)

    print(f"\nChecking {len(activity_files)} files using {workers} workers...")

    with Pool(processes=workers) as pool:
        results = pool.map(check_activity, activity_files)

    has_errors = not all(results)

    if has_errors:
        return 1

    print("\n✅ All checked activity files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
