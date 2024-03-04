#!/usr/bin/python3
"""Utily functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import subprocess

import ruamel.yaml


def create_yaml_object():
    """Create a YAML object"""
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)
    yaml.preserve_quotes = True
    yaml.representer.add_representer(
        type(None),
        lambda dumper, data: dumper.represent_scalar("tag:yaml.org,2002:null", "null"),
    )
    return yaml


def load_yaml(filename):
    """Load a YAML file."""
    yaml = create_yaml_object()

    with open(filename, "r", encoding="utf8") as file:
        data = yaml.load(file)

    return data


def dump_yaml(filename, data):
    """Dump a YAML file."""
    yaml = create_yaml_object()

    with open(filename, "w", encoding="utf8") as file:
        yaml.dump(data, file)


def check_jtd_schema_compliance(filename, schema):
    """Validate a YAML file with a JTD schema."""
    file_is_compliant = True

    os.environ["FORCE_COLOR"] = "true"
    cmd = f"ajv validate --verbose --all-errors --spec=jtd -s {schema} -d {filename}"

    result = subprocess.run(cmd, shell=True, capture_output=True, check=False)

    if result.returncode != 0:
        error = result.stderr.decode("utf-8")
        print(f"\n❌ File does not match the schema {schema}")
        print(error)
        file_is_compliant = False

    return file_is_compliant
