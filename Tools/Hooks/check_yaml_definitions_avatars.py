#!/usr/bin/python3
"""
Check avatars definitions in YAML files.

Validates avatar definition files against JTD schema and checks for:
- Schema compliance
- Unique category IDs
- Image file existence
- Image naming conventions
"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path
from typing import Dict, List, Optional

from modules.base_validator import main_entry_point, BaseYamlValidator
from modules.definitions import find_duplicate_ids
from modules.yaml import load_yaml

# Constants
JTD_SCHEMA = "Specs/jtd/avatars.jtd.json"
AVATAR_IMAGE_DIRECTORY = Path("Modules/AccountKit/Resources/avatars/images")


class AvatarsDefinitionValidator(BaseYamlValidator):
    """Validator for avatar definitions with image file validation."""
    
    def __init__(self):
        super().__init__(
            schema_path=JTD_SCHEMA,
            validator_name="avatar definition"
        )
    
    def find_image(self, image: str) -> Optional[Path]:
        """
        Find the image file in the avatars directory.

        Args:
            image: Base name of the image without extension

        Returns:
            Path to the image file if found, None otherwise
        """
        if not AVATAR_IMAGE_DIRECTORY.exists():
            self.logger.error(f"Avatar images directory not found: {AVATAR_IMAGE_DIRECTORY}")
            return None

        image_filename = f"{image}.avatars.png"
        try:
            for file in AVATAR_IMAGE_DIRECTORY.rglob("*.avatars.png"):
                if file.name == image_filename:
                    return file
        except (OSError, IOError) as e:
            self.logger.error(f"Error searching for image {image_filename}: {e}")
        return None
    
    def list_image_names(self, data: Dict) -> List[str]:
        """
        Extract list of image names from the YAML data.

        Args:
            data: Loaded YAML data

        Returns:
            List of image names
        """
        images = []
        category = [item["avatars"] for item in data["categories"]]
        for avatars in category:
            for avatar in avatars:
                images.append(avatar)
        return images
    
    def validate_file(self, filename: str) -> bool:
        """
        Validate avatar definitions file.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if file is valid, False otherwise
        """
        try:
            file_is_valid = True

            # Schema validation
            if not self.validate_schema(filename):
                file_is_valid = False

            data = load_yaml(filename)
            if not data:
                return False

            # Check for duplicate category IDs
            ids = [item["id"] for item in data["categories"]]
            if duplicate_ids := find_duplicate_ids(ids):
                file_is_valid = False
                self.logger.error(f"\n❌ Duplicate category IDs found in {filename}:")
                for duplicate_id in duplicate_ids:
                    self.logger.error(f"   - {duplicate_id}")

            # Validate image files and naming conventions
            for name in self.list_image_names(data):
                if "-" in name:
                    file_is_valid = False
                    self.logger.error(f'\n❌ Image name contains "-" instead of "_": {name}.avatars.png')

                if self.find_image(name) is None:
                    file_is_valid = False
                    self.logger.error(f"\n❌ Missing image file: {name}.avatars.png")

            return file_is_valid

        except (OSError, IOError) as e:
            self.logger.error(f"Error processing {filename}: {e}")
            return False


def main() -> int:
    """Validate avatar definition files"""
    return main_entry_point(AvatarsDefinitionValidator)


if __name__ == "__main__":
    sys.exit(main())
