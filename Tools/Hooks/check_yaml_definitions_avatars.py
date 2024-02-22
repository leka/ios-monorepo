#!/usr/bin/python3
"""Check avatars definitions"""

# Leka - LekaOS
# Copyright 2024 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess
import sys
from pathlib import Path
import ruamel.yaml

JTD_SCHEMA = "Specs/jtd/avatars.jtd.json"
ACCOUNTKIT_DIRECTORY = "Modules/AccountKit/Resources/avatars/images"

#
# Mark: - Functions
#

def find_image(image):
    """Find the image file"""
    start_path = Path(ACCOUNTKIT_DIRECTORY)
    image_filename = image + ".avatars.png"
    for file in start_path.rglob("*.avatars.png"):
        if file.name == image_filename:
            return file
    return None

def list_images(data):
    """List of images from the YAML file"""
    images = []
    category = [item["avatars"] for item in data["categories"]]
    for avatars in category:
        for avatar in avatars:
            images.append(avatar)
    return images

def check_avatar_definitions(filename):
    """Check avatar definitions"""
    # ? Create a YAML object
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)

    # ? Load the YAML file
    with open(filename, "r", encoding="utf8") as file:
        data = yaml.load(file)

    # ? Extract the ids
    ids = [item["id"] for item in data["categories"]]

    file_is_valid = True

    # ? Check if all ids are unique
    if len(set(ids)) != len(ids):
        print(f"❌ There are duplicate ids in {filename}")
        seen = set()
        duplicate = set()
        for id in ids:
            if id in seen:
                duplicate.add(id)
            else:
                seen.add(id)
        print(f"Duplicate ids: {duplicate}")
        file_is_valid = False

    # ? Check schema validation with ajv
    os.environ["FORCE_COLOR"] = "true"
    cmd = (
        f"ajv validate --verbose --all-errors --spec=jtd -s {JTD_SCHEMA} -d {filename}"
    )

    result = subprocess.run(cmd, shell=True, capture_output=True, check=False)

    if result.returncode != 0:
        error = result.stderr.decode("utf-8")
        print(f"\n❌ File does not match the schema {JTD_SCHEMA}")
        print(error)
        file_is_valid = False

    # ? Check image exists
    images = list_images(data)
    for image in images:
        if "-" in image:
            print(f"❌ The image {image}.avatars.png include \"-\" instead of \"_\"")
            file_is_valid = False
        if find_image(image) is None:
            print(f"❌ The image {image}.avatars.png in {filename} does not exist")
            file_is_valid = False

    return file_is_valid


#
# Mark: - Main
#


def main():
    """Main function"""
    # ? Check if a file was specified
    if len(sys.argv) > 1:
        avatar_definitions_files = sys.argv[1:]
    else:
        print("❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in avatar_definitions_files:
        file_is_valid = check_avatar_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
