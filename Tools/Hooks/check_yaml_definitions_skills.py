#!/usr/bin/python3
"""Check skill definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.utils import get_files
from modules.yaml import load_yaml, check_jtd_schema_compliance
from modules.definitions import check_definition_list, check_ids_are_unique


JTD_SCHEMA = "Specs/jtd/skills.jtd.json"
SKILLS_FILE = "Modules/ContentKit/Resources/Content/definitions/skills.yml"


def find_all_skills():
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

    if check_jtd_schema_compliance(file, JTD_SCHEMA) is False:
        file_is_valid = False

    if check_definition_list(file) is False:
        file_is_valid = False

    duplicate_ids = check_ids_are_unique(find_all_skills())
    if duplicate_ids is not None:
        print(f"❌ There are duplicate ids in {file}")
        print(f"Duplicate ids: {duplicate_ids}")
        file_is_valid = False

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_skills_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
