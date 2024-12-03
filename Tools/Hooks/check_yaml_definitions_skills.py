#!/usr/bin/python3
"""Check skill definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.definitions import find_duplicate_ids, sort_list_by_id, is_definition_list_valid
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml

JTD_SCHEMA = "Specs/jtd/skills.jtd.json"
SKILLS_FILE = "Modules/ContentKit/Resources/Content/definitions/skills.yml"


def get_all_skills():
    """List of skills from skills.yml"""
    skills = load_yaml(SKILLS_FILE)

    ids = []

    def find_skill_ids(data, ids):
        for item in data:
            ids.append(item["id"])
            if "subskills" in item and item["subskills"]:
                find_skill_ids(item["subskills"], ids)

    find_skill_ids(skills["list"], ids)

    return ids


def check_skills_definitions(file):
    """Check skills definitions"""
    file_is_valid = True

    # Check JTD schema compliance
    if not is_jtd_schema_compliant(file, JTD_SCHEMA):
        file_is_valid = False

    # Validate definition list (includes sha handling)
    if not is_definition_list_valid(file):
        file_is_valid = False

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        if file != SKILLS_FILE:
            continue

        file_is_valid = check_skills_definitions(file)

        if not file_is_valid:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
