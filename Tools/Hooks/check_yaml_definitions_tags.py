#!/usr/bin/python3
"""
Check tag definitions in YAML files.

Validates tag definition files against JTD schema and checks for:
- Schema compliance
- Unique tag IDs (including subtags)
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

# Constants
JTD_SCHEMA = "Specs/jtd/tags.jtd.json"
TAGS_FILE = Path("Modules/ContentKit/Resources/Content/definitions/tags.yml")


class TagsDefinitionValidator(RecursiveDefinitionValidator):
    """Validator for tag definitions with recursive subtag support."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            definition_file=TAGS_FILE,
            validator_name="tag definition",
            child_key="subtags"
        )


def get_all_tags():
    """
    Get list of all tag IDs including subtags.
    
    Returns:
        List of tag IDs
        
    Note: This function is kept for backward compatibility.
    Use TagsDefinitionValidator().get_all_ids() for new code.
    """
    validator = TagsDefinitionValidator()
    return validator.get_all_ids()


def main() -> int:
    """Validate tag definition files"""
    return main_entry_point(TagsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
