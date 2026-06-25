#!/usr/bin/python3
"""Format JSON files with repository conventions."""
# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json
import sys
from collections import OrderedDict
from pathlib import Path

TOP_KEYS = ("version", "sourceLanguage")


def order_top_keys(data: object) -> object:
    if not isinstance(data, dict):
        return data

    ordered = OrderedDict()
    for key in TOP_KEYS:
        if key in data:
            ordered[key] = data[key]

    for key, value in data.items():
        if key not in ordered:
            ordered[key] = value

    return ordered


def format_file(path: Path) -> bool:
    data = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=OrderedDict)
    formatted = json.dumps(order_top_keys(data), ensure_ascii=True, indent=4) + "\n"
    original = path.read_text(encoding="utf-8")

    if formatted != original:
        path.write_text(formatted, encoding="utf-8")
        return True

    return False


def main() -> int:
    for filename in sys.argv[1:]:
        try:
            format_file(Path(filename))
        except Exception as error:
            print(f"{filename}: invalid JSON: {error}", file=sys.stderr)
            return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
