#!/usr/bin/python3
"""Validate JSON files."""
# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json
import sys


def main() -> int:
    for filename in sys.argv[1:]:
        try:
            with open(filename, encoding="utf-8") as file:
                json.load(file)
        except Exception as error:
            print(f"{filename}: invalid JSON: {error}", file=sys.stderr)
            return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
