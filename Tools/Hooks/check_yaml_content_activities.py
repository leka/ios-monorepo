#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.utils import get_files, is_file_modified
from modules.yaml import create_yaml_object, is_jtd_schema_compliant
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
    find_missing_icons,
    find_string_values_starting_with_newline,
    find_empty_string_values,
)


JTD_SCHEMA = "Specs/jtd/activity.jtd.json"


def check_activity(filename):
    """Check the content of a YAML file for an activity"""
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

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_activity(file)
        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
