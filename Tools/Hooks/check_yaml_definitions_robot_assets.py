#!/usr/bin/python3
"""Check robot asset definitions"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.definitions import find_duplicate_ids, sort_list_by_id
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant, dump_yaml


JTD_SCHEMA = "Specs/jtd/robot_assets.jtd.json"
ROBOT_ASSETS_FILE = "Modules/ContentKit/Resources/Content/definitions/robot_assets.yml"


def get_all_robot_assets_ids():
    """List of robot_assets (id) from robot_assets.yml"""
    robot_assets = load_yaml(ROBOT_ASSETS_FILE)

    ids = []

    def find_robot_asset_ids(data, ids):
        for item in data:
            ids.append(item["id"])

    find_robot_asset_ids(robot_assets["list"], ids)

    return ids

def get_all_robot_assets_names():
    """List of robot_assets (name) from robot_assets.yml"""
    robot_assets = load_yaml(ROBOT_ASSETS_FILE)

    names = []

    def find_robot_asset_names(data, names):
        for item in data:
            names.append(item["name"])

    find_robot_asset_names(robot_assets["list"], names)

    return names

def check_robot_assets_definitions(file):
    """Check robot_assets definitions"""
    file_is_valid = True

    if is_jtd_schema_compliant(file, JTD_SCHEMA) is False:
        file_is_valid = False

    data = load_yaml(file)

    if sorted_list := sort_list_by_id(data["list"]):
        data["list"] = sorted_list
        dump_yaml(file, data)

    if duplicate_ids := find_duplicate_ids(get_all_robot_assets_ids()):
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
        file_is_valid = check_robot_assets_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
