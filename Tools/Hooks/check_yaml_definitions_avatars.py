#!/usr/bin/python3
"""Check avatars definitions"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path

from modules.utils import get_files
from modules.yaml import load_yaml, check_jtd_schema_compliance
from modules.definitions import check_ids_are_unique


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


def main():
    """Main function"""
    files = get_files()

    must_fail = False

    for file in files:
        if check_jtd_schema_compliance(file, JTD_SCHEMA) is False:
            must_fail = True

        data = load_yaml(file)

        ids = [item["id"] for item in data["categories"]]
        duplicate_ids = check_ids_are_unique(ids)
        if duplicate_ids is not None:
            print(f"❌ There are duplicate ids in {file}")
            print(f"Duplicate ids: {duplicate_ids}\n")
            must_fail = True

        image_names = list_image_names(data)
        for name in image_names:
            if "-" in name:
                print(f'❌ The image {name}.avatars.png include "-" instead of "_"\n')
                must_fail = True
            if find_image(name) is None:
                print(f"❌ The image {name}.avatars.png in {file} does not exist\n")
                must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
