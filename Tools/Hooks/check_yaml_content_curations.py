#!/usr/bin/python3
"""Check the content of a YAML file for a curation"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import os
from typing import Dict, Any

from modules.base_validator import main_entry_point
from modules.base_yaml_validator import BaseYamlValidator
from modules.content import find_missing_content_items, is_uuid_same_as_filename, is_uuid_valid
from modules.yaml import create_yaml_object

# Constants
JTD_SCHEMA = "Specs/jtd/curation.jtd.json"


class CurationContentValidator(BaseYamlValidator):
    """Validator for curation content files."""

    def __init__(self):
        super().__init__(JTD_SCHEMA, "curation")

    def validate_curation_item(self, filename: str) -> bool:
        """
        Validate a single curation item.

        Args:
            filename: Path to the YAML file to validate

        Returns:
            bool: True if file is valid, False otherwise
        """
        yaml = create_yaml_object()
        file_is_valid = True

        # Schema validation
        if not self.validate_schema(filename):
            file_is_valid = False

        # Load content
        try:
            with open(filename, "r", encoding="utf8") as file:
                content = yaml.load(file)
        except Exception as error:
            self.logger.error(f"❌ Error loading {filename}: {error}")
            return False

        # UUID validation
        if uuid_mismatch := is_uuid_same_as_filename(content, filename):
            file_is_valid = False
            content_uuid, filename_uuid = uuid_mismatch
            self.logger.error(f"❌ uuid and filename uuid are not the same in {filename}")
            self.logger.error(f"uuid:     {content_uuid}")
            self.logger.error(f"filename: {filename_uuid}")

        if not is_uuid_valid(content["uuid"]):
            file_is_valid = False
            self.logger.error(f"❌ uuid not valid in {filename}")
            self.logger.error(f"uuid: {content['uuid']}")

        # Curation-specific validation
        if not self.validate_content_specific(content, filename):
            file_is_valid = False

        return file_is_valid

    def validate_content_specific(self, content: Dict[str, Any], filename: str) -> bool:
        """
        Curation-specific validation for content items.

        Args:
            content: Loaded YAML content
            filename: Path to the YAML file

        Returns:
            bool: True if valid, False otherwise
        """
        file_is_valid = True

        # Check for missing content items
        if missing_items := find_missing_content_items(content):
            file_is_valid = False
            self.logger.error(f"\n❌ Found content items that do not exist in {filename}")
            for item in missing_items:
                self.logger.error(f"  - {item['value']} ({item['type']}) - expected file: {item['expected_filename']}")

        return file_is_valid

    def validate_file(self, filename: str) -> bool:
        """
        Validate a single file.

        Args:
            filename: Path to the YAML file to validate

        Returns:
            bool: True if file is valid, False otherwise
        """
        return self.validate_curation_item(filename)


def main() -> int:
    """Main function that orchestrates the YAML content checking"""
    return main_entry_point(CurationContentValidator)


if __name__ == "__main__":
    sys.exit(main())