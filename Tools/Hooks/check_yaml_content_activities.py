#!/usr/bin/python3
"""Check the content of a YAML file for an activity"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess
import uuid
import sys
import ruamel.yaml


JTD_SCHEMA = "Specs/jtd/activity.jtd.json"
SKILLS_FILE = "Modules/ContentKit/Resources/Content/definitions/skills.yml"


#
# Mark: - Functions
#


def skill_list():
    """List of skills from skills.yml"""
    with open(SKILLS_FILE, "r", encoding="utf8") as file:
        yaml = ruamel.yaml.YAML(typ="rt")
        skills = yaml.load(file)

    ids = []

    def find_skill_ids(data, ids):
        for item in data:
            ids.append(item["id"])  # Add the current skill/subskill ID
            if "subskills" in item and item["subskills"]:  # Check for subskills
                find_skill_ids(item["subskills"], ids)  # Recursive call for subskills

    find_skill_ids(skills["list"], ids)

    return ids


def check_content_activity(filename):
    """Check the content of a YAML file for an activity"""
    # ? Create a YAML object
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)

    file_is_valid = True

    # ? Load the YAML file
    with open(filename, "r", encoding="utf8") as file:
        data = yaml.load(file)

    # ? Check uuid is the same as the filename
    filename_uuid = os.path.basename(filename).split("-")[0]
    if data["uuid"] != filename_uuid:
        print(f"\n❌ The id in {filename} is not the same as the filename")
        print(f"uuid:     {data['uuid']}")
        print(f"filename: {filename_uuid}")
        file_is_valid = False

    # ? Check uuid is valid
    try:
        uuid.UUID(data["uuid"])
    except ValueError:
        print(f"\n❌ The id in {filename} is not valid")
        print(f"uuid: {data['uuid']}")
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

    # ? Check name is the same as filename
    filename_name = os.path.basename(filename).split("-")[-1].split(".activity.yml")[0]
    if data["name"] != filename_name:
        print(f"\n❌ The name in {filename} is not the same as the filename")
        print(f"name:     {data['name']}")
        print(f"filename: {filename_name}")
        file_is_valid = False

    # ? Check skills exist in skills.yml
    skills = skill_list()
    for skill in data["skills"]:
        if skill not in skills:
            print(
                f"\n❌ The skill {skill} in {filename} does not exist in {SKILLS_FILE}"
            )
            file_is_valid = False

    return file_is_valid


#
# Mark: - Main
#


def main():
    """Main function to check the content of a YAML file for an activity"""
    # ? Check if a file was specified
    if len(sys.argv) > 1:
        activity_files = sys.argv[1:]
    else:
        print("\n❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in activity_files:
        file_is_valid = check_content_activity(file)
        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
