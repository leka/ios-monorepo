#!/usr/bin/python3
"""Validate YAML files."""
# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys

from ruamel.yaml import YAML


def main() -> int:
    yaml = YAML(typ="safe")

    for filename in sys.argv[1:]:
        try:
            with open(filename, encoding="utf-8") as file:
                yaml.load(file)
        except Exception as error:
            print(f"{filename}: invalid YAML: {error}", file=sys.stderr)
            return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
