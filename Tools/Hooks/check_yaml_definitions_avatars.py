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
import logging
from pathlib import Path
from typing import Dict, List, Optional

from modules.definitions import find_duplicate_ids
from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant

# Constants
JTD_SCHEMA = "Specs/jtd/avatars.jtd.json"
AVATAR_IMAGE_DIRECTORY = Path("Modules/AccountKit/Resources/avatars/images")

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def find_image(image: str) -> Optional[Path]:
    """
    Find the image file in the avatars directory.

    Args:
        image: Base name of the image without extension

    Returns:
        Path to the image file if found, None otherwise
    """
    if not AVATAR_IMAGE_DIRECTORY.exists():
        logger.error(f"Avatar images directory not found: {AVATAR_IMAGE_DIRECTORY}")
        return None

    image_filename = f"{image}.avatars.png"
    try:
        for file in AVATAR_IMAGE_DIRECTORY.rglob("*.avatars.png"):
            if file.name == image_filename:
                return file
    except (OSError, IOError) as e:
        logger.error(f"Error searching for image {image_filename}: {e}")
    return None


def list_image_names(data: Dict) -> List[str]:
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


def check_avatars_definitions(filename: str) -> bool:
    """
    Check avatars definitions in a YAML file.

    Args:
        filename: Path to the YAML file to check

    Returns:
        bool: True if file is valid, False otherwise
    """
    try:
        file_is_valid = True

        if not is_jtd_schema_compliant(filename, JTD_SCHEMA):
            logger.error(f"\n❌ Schema validation failed for {filename}")
            file_is_valid = False

        data = load_yaml(filename)
        if not data:
            return False

        ids = [item["id"] for item in data["categories"]]
        if duplicate_ids := find_duplicate_ids(ids):
            file_is_valid = False
            logger.error(f"\n❌ Duplicate category IDs found in {filename}:")
            for duplicate_id in duplicate_ids:
                logger.error(f"   - {duplicate_id}")

        for name in list_image_names(data):
            if "-" in name:
                file_is_valid = False
                logger.error(f'\n❌ Image name contains "-" instead of "_": {name}.avatars.png')

            if find_image(name) is None:
                file_is_valid = False
                logger.error(f"\n❌ Missing image file: {name}.avatars.png")

        return file_is_valid

    except (OSError, IOError) as e:
        logger.error(f"Error processing {filename}: {e}")
        return False


def main() -> int:
    """Validate avatar definition files"""
    files: List[str] = get_files()

    if not files:
        logger.info("\n✅ No avatar definition files to check!")
        return 0

    logger.info(f"\nChecking {len(files)} avatar definition files...")

    has_errors = False
    for file in files:
        if not check_avatars_definitions(file):
            has_errors = True

    if has_errors:
        return 1

    logger.info("\n✅ All avatar definition files are valid!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
