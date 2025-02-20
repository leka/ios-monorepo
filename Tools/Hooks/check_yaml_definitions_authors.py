#!/usr/bin/python3
"""
Check authors definitions in YAML files.

Validates author definition files against JTD schema and checks for:
- Schema compliance
- Unique IDs
- Required fields
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from typing import List

from modules.definitions import is_definition_list_valid
from modules.utils import get_files
from modules.yaml import is_jtd_schema_compliant

# Constants
JTD_SCHEMA = "Specs/jtd/authors.jtd.json"

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def check_authors_definitions(filename: str) -> bool:
    """
    Check author definitions in a YAML file.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    try:
        file_is_valid = True

        if not is_jtd_schema_compliant(filename, JTD_SCHEMA):
            logger.error(f"\n❌ Schema validation failed for {filename}")
            file_is_valid = False

        if not is_definition_list_valid(filename):
            logger.error(f"\n❌ Definition list validation failed for {filename}")
            file_is_valid = False

        return file_is_valid

    except (OSError, IOError) as e:
        logger.error(f"Error processing {filename}: {e}")
        return False


def main() -> int:
    """Validate author definition files"""
    files: List[str] = get_files()

    if not files:
        logger.info("\n✅ No author definition files to check!")
        return 0

    logger.info(f"\nChecking {len(files)} author definition files...")

    has_errors = False
    for file in files:
        if not check_authors_definitions(file):
            has_errors = True

    if has_errors:
        return 1

    logger.info("\n✅ All author definition files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
