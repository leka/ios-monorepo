#!/usr/bin/python3
"""Check stories content for UUID uniqueness"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from pathlib import Path
from modules.uuid_checker import check_uuids

# Constants
DIRECTORY_PATH = Path("Modules/ContentKit/Resources/Content")
STORY_PATTERN = "*.story.yml"

logging.basicConfig(level=logging.INFO, format='%(message)s')


def main() -> int:
    """Check story UUID uniqueness"""
    return check_uuids(DIRECTORY_PATH, STORY_PATTERN, "story")


if __name__ == "__main__":
    sys.exit(main())
