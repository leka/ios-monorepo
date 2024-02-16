#!/usr/bin/python3
"""Module providing a hook to check for stale entries in .xcstrings files."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json
import sys
from pygments import highlight
from pygments.lexers.data import JsonLexer
from pygments.formatters.terminal import TerminalFormatter


def check_for_stale_entries(json_file):
    """Check for stale entries in a .xcstrings file."""
    with open(json_file, "r", encoding="utf8") as file:
        data = json.load(file)
        strings = data.get("strings", {})

    stale_entries = []

    for key, value in strings.items():
        if value.get("extractionState") == "stale":
            stale_entries.append((key, strings[key]))

    return stale_entries


def main():
    """Main function."""
    # ? Check if a file was specified
    if len(sys.argv) > 1:
        xcstrings_files = sys.argv[1:]
    else:
        print("❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in xcstrings_files:
        stale_entries = check_for_stale_entries(file)
        if stale_entries:
            print(f"❌ Stale entries found in {file}")
            for key, data in stale_entries:
                data = json.dumps(data, indent=4)
                print(highlight(f'"{key}": {data}', JsonLexer(), TerminalFormatter()))
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
