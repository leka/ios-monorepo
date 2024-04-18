#!/usr/bin/python3

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

from pathlib import Path
import sys

DIRECTORY_PATH = 'Modules/ContentKit/Resources/Content'

path = Path(DIRECTORY_PATH)
activity_files = path.rglob('*.activity.yml')

uuids_files = {}
duplicates_found = False

for file in activity_files:
    uuid = file.name.split('-', 1)[0]
    if uuid in uuids_files:
        uuids_files[uuid].append(file)
    else:
        uuids_files[uuid] = [file]

for uuid, files in uuids_files.items():
    if len(files) > 1:
        duplicates_found = True
        print(f"❌ Duplicate UUID: {uuid}")
        for file in files:
            print(f"   - {file}")
        print()

if duplicates_found:
    sys.exit(1)
else:
    sys.exit(0)
