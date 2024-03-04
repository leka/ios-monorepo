#!/usr/bin/python3
"""Check authors definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.utils import get_files
from modules.yaml import check_jtd_schema_compliance
from modules.definitions import check_definition_list


JTD_SCHEMA = "Specs/jtd/authors.jtd.json"


def check_authors_definitions(file):
    """Check authors definitions"""
    file_is_valid = True
    if check_jtd_schema_compliance(file, JTD_SCHEMA) is False:
        file_is_valid = False

    if check_definition_list(file) is False:
        file_is_valid = False

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_authors_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
