#!/usr/bin/python3
"""Check tag definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.definitions import find_duplicate_ids, sort_list_by_id
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml


JTD_SCHEMA = "Specs/jtd/tags.jtd.json"
TAGS_FILE = "Modules/ContentKit/Resources/Content/definitions/tags.yml"


def get_all_tags():
    """List of tags from tags.yml"""
    tags = load_yaml(TAGS_FILE)

    ids = []

    def find_skill_ids(data, ids):
        for item in data:
            ids.append(item["id"])
            if "subtags" in item and item["subtags"]:
                find_skill_ids(item["subtags"], ids)

    find_skill_ids(tags["list"], ids)

    return ids


def check_tags_definitions(file):
    """Check tags definitions"""
    file_is_valid = True

    if is_jtd_schema_compliant(file, JTD_SCHEMA) is False:
        file_is_valid = False

    data = load_yaml(file)

    if sorted_list := sort_list_by_id(data["list"]):
        data["list"] = sorted_list
        dump_yaml(file, data)

    if duplicate_ids := find_duplicate_ids(get_all_tags()):
        file_is_valid = False
        print(f"\n❌ There are duplicate ids in {file}")
        for duplicate_id in duplicate_ids:
            print(f"   - {duplicate_id}")

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_tags_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
