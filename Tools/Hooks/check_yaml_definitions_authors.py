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


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        if check_jtd_schema_compliance(file, JTD_SCHEMA) is False:
            must_fail = True

        if check_definition_list(file) is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
