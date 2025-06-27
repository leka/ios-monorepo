#!/usr/bin/python3
"""
Check skill definitions in YAML files.

Validates skill definition files against JTD schema and checks for:
- Schema compliance
- Unique skill IDs (including subskills)
- Required fields
- Proper sorting by ID
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path

from modules.base_validator import main_entry_point
from modules.definition_validators import RecursiveDefinitionValidator
from modules.definitions import is_definition_list_valid

# Constants
JTD_SCHEMA = "Specs/jtd/skills.jtd.json"
SKILLS_FILE = Path("Modules/ContentKit/Resources/Content/definitions/skills.yml")


class SkillsDefinitionValidator(RecursiveDefinitionValidator):
    """Validator for skill definitions with recursive subskill support."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            definition_file=SKILLS_FILE,
            validator_name="skill definition",
            child_key="subskills"
        )
    
    def validate_definitions(self, filename: str) -> bool:
        """
        Validate skill definitions including SHA validation.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        # First run the SHA validation from definitions module
        if not is_definition_list_valid(filename):
            self.logger.error(f"\n❌ Definition list validation failed for {filename}")
            return False
        
        # Then run the standard recursive validation
        return super().validate_definitions(filename)


def get_all_skills():
    """
    Get list of all skill IDs including subskills.
    
    Returns:
        List of skill IDs
        
    Note: This function is kept for backward compatibility.
    Use SkillsDefinitionValidator().get_all_ids() for new code.
    """
    validator = SkillsDefinitionValidator()
    return validator.get_all_ids()


def main() -> int:
    """Validate skill definition files"""
    return main_entry_point(SkillsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
