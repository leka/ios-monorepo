#!/usr/bin/python3

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import sys

from pathlib import Path


DIRECTORY_PATH = "Modules/ContentKit/Resources/Content"


def find_duplicates():
    """Find duplicates in the activity files"""
    path = Path(DIRECTORY_PATH)
    activity_files = path.rglob("*.activity.yml")

    uuids_files = {}
    duplicates = []

    for file in activity_files:
        uuid = os.path.basename(file).split("-")[-1].split(".")[0]
        if uuid in uuids_files:
            uuids_files[uuid].append(file)
        else:
            uuids_files[uuid] = [file]

    for uuid, files in uuids_files.items():
        if len(files) > 1:
            duplicates.append((uuid, files))

    return duplicates


def main():
    """Main function"""
    duplicates = find_duplicates()

    if duplicates:
        print("❌ Duplicates found:")
        for uuid, files in duplicates:
            print(f"   - {uuid}")
            for file in files:
                print(f"      - {file}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
