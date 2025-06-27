#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from typing import Dict, Any

from modules.base_validator import main_entry_point
from modules.content_validators import ContentValidator
from modules.content import find_missing_exercise_assets

# Constants
JTD_SCHEMA = "Specs/jtd/activity.jtd.json"


class ActivityContentValidator(ContentValidator):
    """Validator for activity content files."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="activity",
            content_type="activity"
        )
    
    def validate_content_specific(self, content: Dict[str, Any], filename: str) -> bool:
        """
        Activity-specific validation for exercise assets.
        
        Args:
            content: Loaded YAML content
            filename: Path to the YAML file
            
        Returns:
            bool: True if valid, False otherwise
        """
        file_is_valid = True
        
        # Check for missing exercise assets
        if missing_exercise_assets := find_missing_exercise_assets(content):
            file_is_valid = False
            print(f"\n❌ The following assets do not exist in {filename}")
            for asset in missing_exercise_assets:
                print(f"   - {asset['source']} - {asset['type']} - {asset['value']}")
        
        return file_is_valid


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    return main_entry_point(ActivityContentValidator)


if __name__ == "__main__":
    sys.exit(main())
