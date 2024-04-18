#!/usr/bin/python3
"""Check xstrings for unusal terminators"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import json
from pygments import highlight
from pygments.lexers.data import JsonLexer
from pygments.formatters.terminal import TerminalFormatter


CHARACTER_TO_SEARCH = "\u2028"

#
# Mark: - Functions
#


def check_for_unusual_terminators(file_path):
    """Check the given file for unusual terminators."""
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    wrong_entries = []

    # Navigate through the JSON structure
    for key, value in data["strings"].items():
        for _, localizations in value["localizations"].items():
            localized_string = localizations["stringUnit"]["value"]
            if CHARACTER_TO_SEARCH in localized_string:
                wrong_entries.append((key, value))

    return wrong_entries


#
# Mark: - Main
#


def main():
    """Main function"""
    # Check if a file was specified
    if len(sys.argv) > 1:
        profession_definitions_files = sys.argv[1:]
    else:
        print("❌ No file specified")
        sys.exit(1)

    must_fail = False

    for file in profession_definitions_files:
        print(f"🔍 Checking file {file} for unusual terminators...")
        wrong_entries = check_for_unusual_terminators(file)
        if wrong_entries:
            must_fail = True
            print(
                f"❌ Unusual terminators 'U+{ord(CHARACTER_TO_SEARCH):04X}' found in {file}"
            )
            for key, data in wrong_entries:
                data = json.dumps(data, indent=4)
                print(highlight(f'"{key}": {data}', JsonLexer(), TerminalFormatter()))

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
