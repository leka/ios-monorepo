#!/usr/bin/python3
"""Check curriculums content for UUID uniqueness"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from pathlib import Path
from modules.uuid_checker import check_uuids

# Constants
DIRECTORY_PATH = Path("Modules/ContentKit/Resources/Content")
CURRICULUM_PATTERN = "*.curriculum.yml"

logging.basicConfig(level=logging.INFO, format='%(message)s')

if __name__ == "__main__":
    sys.exit(check_uuids(DIRECTORY_PATH, CURRICULUM_PATTERN, "curriculum"))
