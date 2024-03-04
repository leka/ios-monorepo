#!/usr/bin/python3
"""Check avatars definitions"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path

from modules.utils import get_files
from modules.yaml import load_yaml, is_jtd_schema_compliant
from modules.definitions import find_duplicate_ids


JTD_SCHEMA = "Specs/jtd/avatars.jtd.json"
AVATAR_IMAGE_DIRECTORY = "Modules/AccountKit/Resources/avatars/images"


def find_image(image):
    """Find the image file"""
    start_path = Path(AVATAR_IMAGE_DIRECTORY)
    image_filename = image + ".avatars.png"
    for file in start_path.rglob("*.avatars.png"):
        if file.name == image_filename:
            return file
    return None


def list_image_names(data):
    """List of images from the YAML file"""
    images = []
    category = [item["avatars"] for item in data["categories"]]
    for avatars in category:
        for avatar in avatars:
            images.append(avatar)
    return images


def check_avatars_definitions(file):
    """Check avatars definitions"""
    file_is_valid = True

    if is_jtd_schema_compliant(file, JTD_SCHEMA) is False:
        file_is_valid = False

    data = load_yaml(file)

    ids = [item["id"] for item in data["categories"]]
    if duplicate_ids := find_duplicate_ids(ids):
        file_is_valid = False
        print(f"\n❌ There are duplicate ids in {file}")
        for duplicate_id in duplicate_ids:
            print(f"   - {duplicate_id}")

    for name in list_image_names(data):
        if "-" in name:
            file_is_valid = False
            print(f'\n❌ The image {name}.avatars.png include "-" instead of "_"')

        if find_image(name) is None:
            file_is_valid = False
            print(f"\n❌ The image {name}.avatars.png in {file} does not exist")

    return file_is_valid


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_avatars_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
