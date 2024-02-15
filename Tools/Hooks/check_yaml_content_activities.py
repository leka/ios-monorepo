#!/usr/bin/python3

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess
import uuid
import ruamel.yaml
import sys


JTD_SCHEMA = "Specs/jtd/activity.jtd.json"


#
# Mark: - Main
#


# ? Check if a file was specified
if len(sys.argv) > 1:
    FILENAME = sys.argv[1]
else:
    print("❌ No file specified")
    exit(1)

# ? Create a YAML object
yaml = ruamel.yaml.YAML(typ='rt')
yaml.indent(mapping=2, sequence=4, offset=2)

# ? Load the YAML file
with open(FILENAME, 'r') as file:
    data = yaml.load(file)

# ? Check uuid is the same as the filename
filename_uuid = os.path.basename(FILENAME).split("-")[0]
if data['uuid'] != filename_uuid:
    print(f"❌ The id in {FILENAME} is not the same as the filename")
    print(f"uuid:     {data['uuid']}")
    print(f"filename: {filename_uuid}")
    exit(1)

# ? Check uuid is valid
try:
    uuid.UUID(data['uuid'])
except ValueError:
    print(f"❌ The id in {FILENAME} is not valid")
    print(f"uuid: {data['uuid']}")
    exit(1)

# ? Check schema validation with ajv
os.environ['FORCE_COLOR'] = 'true'
cmd = f"ajv validate --verbose --all-errors --spec=jtd -s {JTD_SCHEMA} -d {FILENAME}"
result = subprocess.run(cmd, shell=True, capture_output=True)

if result.returncode != 0:
    error = result.stderr.decode('utf-8')
    print(f"❌ File does not match the schema {JTD_SCHEMA}")
    print(error)
    exit(1)

# ? Check name is the same as filename
filename_name = os.path.basename(FILENAME).split('-')[-1].split('.activity.yml')[0]
if data['name'] != filename_name:
    print(f"❌ The name in {FILENAME} is not the same as the filename")
    print(f"name:     {data['name']}")
    print(f"filename: {filename_name}")
    exit(1)


exit(0)
