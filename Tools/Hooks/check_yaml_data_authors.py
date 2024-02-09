#!/usr/bin/python3

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import ruamel.yaml
import subprocess
import sys

JTD_SCHEMA = "Specs/jtd/authors.jtd.json"

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

# ? Sort the list by id
data['list'] = sorted(data['list'], key=lambda item: item['id'])

# ? Write the sorted data back to the file
with open(FILENAME, 'w') as file:
    yaml.dump(data, file)

# ? Extract the ids
ids = [item['id'] for item in data['list']]

# ? Check if all ids are unique
if len(set(ids)) != len(ids):
    print(f"❌ There are duplicate ids in {FILENAME}")
    seen = set()
    duplicate = set()
    for id in ids:
        if id in seen:
            duplicate.add(id)
        else:
            seen.add(id)
    print(f"Duplicate ids: {duplicate}")
    exit(1)

# Check schema validation with ajv
os.environ['SYSTEMD_COLORS'] = '1'
cmd = f"ajv --spec=jtd -s {JTD_SCHEMA} -d {FILENAME}"
result = subprocess.run(cmd, shell=True)

if result.returncode != 0:
    print(f"❌ {FILENAME} is invalid")
    exit(1)

exit(0)
