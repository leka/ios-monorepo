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


def get_all_robot_assets_ids():
    """
    Get list of all robot asset IDs from robot_assets.yml.
    
    Returns:
        List of robot asset IDs
        
    Note: This function is kept for backward compatibility.
    Use RobotAssetsDefinitionValidator for new code.
    """
    from pathlib import Path
    from modules.yaml import load_yaml
    
    robot_assets_file = Path("Modules/ContentKit/Resources/Content/definitions/robot_assets.yml")
    try:
        robot_assets = load_yaml(robot_assets_file)
        if not robot_assets:
            return []

        ids = []
        for item in robot_assets["list"]:
            ids.append(item["id"])
        return ids

    except (OSError, IOError):
        return []


def get_all_robot_assets_names():
    """
    Get list of all robot asset names from robot_assets.yml.
    
    Returns:
        List of robot asset names
        
    Note: This function is kept for backward compatibility.
    Use RobotAssetsDefinitionValidator for new code.
    """
    from pathlib import Path
    from modules.yaml import load_yaml
    
    robot_assets_file = Path("Modules/ContentKit/Resources/Content/definitions/robot_assets.yml")
    try:
        robot_assets = load_yaml(robot_assets_file)
        if not robot_assets:
            return []

        names = []
        for item in robot_assets["list"]:
            names.append(item["name"])
        return names

    except (OSError, IOError):
        return []


def main() -> int:
    """Validate robot asset definition files"""
    return main_entry_point(RobotAssetsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
