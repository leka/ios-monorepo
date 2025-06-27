#!/usr/bin/python3
"""
Check robot asset definitions in YAML files.

Validates robot asset definition files against JTD schema and checks for:
- Schema compliance
- Unique IDs across all assets
- Name uniqueness
- Proper sorting by ID
"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.base_validator import main_entry_point
from modules.definition_validators import SimpleListDefinitionValidator

# Constants
JTD_SCHEMA = "Specs/jtd/robot_assets.jtd.json"


class RobotAssetsDefinitionValidator(SimpleListDefinitionValidator):
    """Validator for robot asset definitions with ID and name uniqueness."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="robot asset definition",
            check_duplicates=True,
            enable_sorting=True,
            duplicate_fields=["id", "name"]  # Check both ID and name uniqueness
        )


def main() -> int:
    """Validate robot asset definition files"""
    return main_entry_point(RobotAssetsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
