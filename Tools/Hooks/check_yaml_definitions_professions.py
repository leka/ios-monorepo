#!/usr/bin/python3
"""Check profession definitions"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess
import sys
import ruamel.yaml

JTD_SCHEMA = "Specs/jtd/professions.jtd.json"

#
# Mark: - Functions
#


def check_profession_definitions(filename):
    """Check profession definitions"""
    # ? Create a YAML object
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)

    # ? Load the YAML file
    with open(filename, "r", encoding="utf8") as file:
        data = yaml.load(file)

    # ? Sort the list by id
    data["list"] = sorted(data["list"], key=lambda item: item["id"])

    # ? Write the sorted data back to the file
    with open(filename, "w", encoding="utf8") as file:
        yaml.dump(data, file)

    # ? Extract the ids
    ids = [item["id"] for item in data["list"]]

    file_is_valid = True

    # ? Check if all ids are unique
    if len(set(ids)) != len(ids):
        print(f"❌ There are duplicate ids in {filename}")
        seen = set()
        duplicate = set()
        for profession_id in ids:
            if profession_id in seen:
                duplicate.add(profession_id)
            else:
                seen.add(profession_id)
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

    return file_is_valid


#
# Mark: - Main
#


def main():
    """Main function"""
    # ? Check if a file was specified
    if len(sys.argv) > 1:
        profession_definitions_files = sys.argv[1:]
    else:
        print("❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in profession_definitions_files:
        file_is_valid = check_profession_definitions(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
