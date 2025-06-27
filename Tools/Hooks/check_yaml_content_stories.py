#!/usr/bin/python3
"""Check the content of YAML files for stories"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from modules.base_validator import main_entry_point
from modules.content_validators import ContentValidator

# Constants
JTD_SCHEMA = "Specs/jtd/story.jtd.json"


class StoryContentValidator(ContentValidator):
    """Validator for story content files."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="story",
            content_type="story"
        )


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    return main_entry_point(StoryContentValidator)


if __name__ == "__main__":
    sys.exit(main())
