#!/usr/bin/python3
"""Check the content of a YAML file for a curriculum"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from typing import Dict, Any

from modules.base_validator import main_entry_point
from modules.content_validators import ContentValidator
from modules.content import find_missing_activities

# Constants
JTD_SCHEMA = "Specs/jtd/curriculum.jtd.json"


class CurriculumContentValidator(ContentValidator):
    """Validator for curriculum content files."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="curriculum",
            content_type="curriculum"
        )
    
    def validate_content_specific(self, content: Dict[str, Any], filename: str) -> bool:
        """
        Curriculum-specific validation for activities.
        
        Args:
            content: Loaded YAML content
            filename: Path to the YAML file
            
        Returns:
            bool: True if valid, False otherwise
        """
        file_is_valid = True
        
        # Check for missing activities
        if missing_activities := find_missing_activities(content):
            file_is_valid = False
            print(f"\n❌ Found activities that do not exist in {filename}")
            for activity in missing_activities:
                print(f"  - {activity}")
        
        return file_is_valid


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    return main_entry_point(CurriculumContentValidator)


if __name__ == "__main__":
    sys.exit(main())
