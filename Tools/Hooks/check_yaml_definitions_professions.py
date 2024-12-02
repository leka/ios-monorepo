#!/usr/bin/python3
"""Check profession definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.definitions import is_definition_list_valid
from modules.utils import get_files
from modules.yaml import is_jtd_schema_compliant


JTD_SCHEMA = "Specs/jtd/professions.jtd.json"


def check_profession_definitions(file):
    """Check profession definitions"""
    file_is_valid = True

    if not is_jtd_schema_compliant(file, JTD_SCHEMA):
        file_is_valid = False

    if not is_definition_list_valid(file):
        file_is_valid = False

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_profession_definitions(file)

        if not file_is_valid:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
