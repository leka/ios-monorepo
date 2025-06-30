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

from modules.base_validator import main_entry_point
from modules.definition_validators import SimpleListDefinitionValidator
from modules.definitions import is_definition_list_valid

# Constants
JTD_SCHEMA = "Specs/jtd/authors.jtd.json"


class AuthorsDefinitionValidator(SimpleListDefinitionValidator):
    """Validator for author definitions."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="author definition",
            check_duplicates=True,
            enable_sorting=True
        )
    
    def validate_definitions(self, filename: str) -> bool:
        """
        Validate author definitions including SHA validation.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        # First run the SHA validation from definitions module
        if not is_definition_list_valid(filename):
            self.logger.error(f"\n❌ Definition list validation failed for {filename}")
            return False
        
        # Then run the standard list validation
        return super().validate_definitions(filename)


def main() -> int:
    """Validate author definition files"""
    return main_entry_point(AuthorsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
