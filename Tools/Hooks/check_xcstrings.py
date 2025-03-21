#!/usr/bin/python3
"""Module providing a hook to check for .xcstrings files."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json
import sys
from pygments import highlight
from pygments.lexers.data import JsonLexer
from pygments.formatters.terminal import TerminalFormatter

from modules.utils import get_files
from modules.xcstrings import find_stale_entries, find_unusual_characters


def check_xcstrings_file(file):
    """Check xcstrings for stale entries."""
    file_is_valid = True

    if stale_entries := find_stale_entries(file):
        file_is_valid = False
        print(f"\n❌ Stale entries found in {file}")
        for key, data in stale_entries:
            data = json.dumps(data, indent=4)
            print(highlight(f'"{key}": {data}', JsonLexer(), TerminalFormatter()))

    if problematic_entries := find_unusual_characters(file):
        file_is_valid = False
        print(f"\n❌ Unusual characters found in {file}")
        for key, value, character in problematic_entries:
            value = json.dumps(value, indent=4)
            print(f"Character: {character}")
            print(highlight(f'"{key}": {value}', JsonLexer(), TerminalFormatter()))

    return file_is_valid


def main():
    """Main function."""
    files = get_files()

    must_fail = False

    for file in files:
        file_is_valid = check_xcstrings_file(file)

        if file_is_valid is False:
            must_fail = True

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
