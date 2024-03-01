#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess
import uuid
import sys
from pathlib import Path
from datetime import datetime, timedelta
import ruamel.yaml


JTD_SCHEMA = "Specs/jtd/activity.jtd.json"
SKILLS_FILE = "Modules/ContentKit/Resources/Content/definitions/skills.yml"
CONTENTKIT_DIRECTORY = "Modules/ContentKit/Resources/Content"

CREATED_AT_INDEX = 3
LAST_EDITED_AT_INDEX = 4
DATE_NOW_TIMESTAMP = ruamel.yaml.scalarstring.DoubleQuotedScalarString(
    datetime.now().isoformat()
)


#
# Mark: - Functions
#


def find_icon(icon):
    """Find the icon file"""
    start_path = Path(CONTENTKIT_DIRECTORY)
    icon_filename = icon + ".activity.icon.png"
    for file in start_path.rglob("*.activity.icon.png"):
        if file.name == icon_filename:
            return file
    return None


def list_icons(data):
    """List of icons from the YAML file"""
    icons = []
    for l10n_entry in data["l10n"]:
        if "details" in l10n_entry and "icon" in l10n_entry["details"]:
            icons.append(l10n_entry["details"]["icon"])
    return icons


def skill_list():
    """List of skills from skills.yml"""
    with open(SKILLS_FILE, "r", encoding="utf8") as file:
        yaml = ruamel.yaml.YAML(typ="rt")
        skills = yaml.load(file)

    ids = []

    def find_skill_ids(data, ids):
        for item in data:
            ids.append(item["id"])  # Add the current skill/subskill ID
            if "subskills" in item and item["subskills"]:  # Check for subskills
                find_skill_ids(item["subskills"], ids)  # Recursive call for subskills

    find_skill_ids(skills["list"], ids)

    return ids


def is_file_modified(file_path):
    """Check if a file is modified and/or staged for commit"""
    result = subprocess.run(
        ["git", "status", "--porcelain", file_path],
        capture_output=True,
        text=True,
        check=False,
    )

    output = result.stdout.strip()

    if output:
        # Check for modifications in both staged (index) and work tree
        # Staged modifications: first letter is not ' ' (space)
        # Work tree modifications: second letter is 'M'
        # This covers added (A), modified (M), deleted (D), renamed (R), etc.
        status_code = output[:2]
        if status_code[0] != " " or status_code[1] == "M":
            return True

    return False


def check_strings_for_newline(data, path=None):
    """Check if a string starts with a newline character"""
    if path is None:
        path = []  # Initialize path
    keys_with_newlines = []

    if isinstance(data, dict):  # If the item is a dictionary
        for key, value in data.items():
            keys_with_newlines += check_strings_for_newline(value, path + [key])
    elif isinstance(data, list):  # If the item is a list
        for index, item in enumerate(data):
            keys_with_newlines += check_strings_for_newline(item, path + [index])
    elif isinstance(data, str):  # If the item is a string
        if data.startswith("\n"):
            keys_with_newlines.append("/".join(map(str, path)))

    return keys_with_newlines


def check_empty_strings(data, path=None):
    """Check for empty strings in the data structure"""
    if path is None:
        path = []
    violations = []

    if isinstance(data, dict):
        for key, value in data.items():
            sub_path = path + [key]  # Build the path for nested dictionaries
            if isinstance(value, str) and (value == "" or value.isspace()):
                violations.append("/".join(map(str, sub_path)))
            else:
                # Recurse into the value if it's a dict or list
                violations += check_empty_strings(value, sub_path)
    elif isinstance(data, list):
        for index, item in enumerate(data):
            sub_path = path + [str(index)]  # Handle list indexing in the path
            # Recurse into the item if it's a dict or list
            violations += check_empty_strings(item, sub_path)

    return violations


def create_yaml_object():
    """Create a YAML object"""
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)
    yaml.preserve_quotes = True
    yaml.representer.add_representer(
        type(None),
        lambda dumper, data: dumper.represent_scalar("tag:yaml.org,2002:null", "null"),
    )
    return yaml


def check_content_activity(filename):
    """Check the content of a YAML file for an activity"""
    yaml = create_yaml_object()

    file_is_valid = True

    # ? Load the YAML file
    with open(filename, "r", encoding="utf8") as file:
        data = yaml.load(file)

    # ? Check uuid is the same as the filename
    filename_uuid = os.path.basename(filename).split("-")[-1].split(".")[0]
    if data["uuid"] != filename_uuid:
        print(f"\n❌ The id in {filename} is not the same as the filename")
        print(f"uuid:     {data['uuid']}")
        print(f"filename: {filename_uuid}")
        file_is_valid = False

    # ? Check uuid is valid
    try:
        uuid.UUID(data["uuid"])
    except ValueError:
        print(f"\n❌ The id in {filename} is not valid")
        print(f"uuid: {data['uuid']}")
        file_is_valid = False

    # ? Check created_at is present
    if "created_at" not in data:
        print(f"\n❌ Missing key created_at in {filename}")
        print(f"Add created_at: {DATE_NOW_TIMESTAMP}")
        if "name" in data and "status" in data:
            data.insert(CREATED_AT_INDEX, "created_at", DATE_NOW_TIMESTAMP)
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(data, file)

        file_is_valid = False

    # ? Check last_edited_at is present
    if "last_edited_at" not in data:
        print(f"\n❌ Missing key last_edited_at in {filename}")
        print(f"Add last_edited_at: {DATE_NOW_TIMESTAMP}")
        if "name" in data and "status" in data:
            data.insert(LAST_EDITED_AT_INDEX, "last_edited_at", DATE_NOW_TIMESTAMP)
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(data, file)

        file_is_valid = False

    # ? Update last_edited_at if DATE_NOW_TIMESTAMP is more recent with a threshold of 1 minute
    if is_file_modified(filename) and "last_edited_at" in data:
        last_edited_at = datetime.fromisoformat(data["last_edited_at"])
        one_minute_ago = datetime.fromisoformat(DATE_NOW_TIMESTAMP) - timedelta(
            minutes=1
        )
        if last_edited_at < one_minute_ago:
            print(
                f"\n❌ last_edited_at {last_edited_at} is not up to date in {filename}"
            )
            print(f"Update last_edited_at: {DATE_NOW_TIMESTAMP}\n")
            data["last_edited_at"] = DATE_NOW_TIMESTAMP
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(data, file)

            file_is_valid = False

    # ? Check schema validation with ajv
    os.environ["FORCE_COLOR"] = "true"
    cmd = (
        f"ajv validate --verbose --all-errors --spec=jtd -s {JTD_SCHEMA} -d {filename}"
    )
    result = subprocess.run(cmd, shell=True, capture_output=True, check=False)

    if result.returncode != 0:
        error = result.stderr.decode("utf-8")
        print(f"\n❌ File does not match the schema {JTD_SCHEMA}")
        print(error)
        file_is_valid = False

    # ? Check name is the same as filename
    filename_name = os.path.basename(filename).split("-")[0]
    if data["name"] != filename_name:
        print(f"\n❌ The name in {filename} is not the same as the filename")
        print(f"name:     {data['name']}")
        print(f"filename: {filename_name}")
        file_is_valid = False

    # ? Check skills exist in skills.yml
    skills = skill_list()
    for skill in data["skills"]:
        if skill not in skills:
            print(
                f"\n❌ The skill {skill} in {filename} does not exist in {SKILLS_FILE}"
            )
            file_is_valid = False

    # ? Check icon exists
    icons = list_icons(data)
    for icon in icons:
        if find_icon(icon) is None:
            print(f"❌ The icon {icon}.activity.icon.png in {filename} does not exist")
            file_is_valid = False

    # ? Check string values do not start with a newline character
    strings_with_newline = check_strings_for_newline(data)
    for string in strings_with_newline:
        print(f"❌ String staring with newline for key: {string} \nin {filename}\n")
        file_is_valid = False

    # ? Check for empty strings according to the JTD schema
    # schema = load_jtd_schema(JTD_SCHEMA)
    empty_strings = check_empty_strings(data)
    for string in empty_strings:
        print(f"❌ Empty string for key: {string} \nin {filename}\n")
        file_is_valid = False

    return file_is_valid


#
# Mark: - Main
#


def main():
    """Main function to check the content of a YAML file for an activity"""
    # ? Check if a file was specified
    if len(sys.argv) > 1:
        activity_files = sys.argv[1:]
    else:
        print("\n❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in activity_files:
        file_is_valid = check_content_activity(file)
        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
