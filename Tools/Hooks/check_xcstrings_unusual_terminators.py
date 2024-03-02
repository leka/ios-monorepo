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

from modules.utils import get_files
from modules.xstrings import check_for_unusual_characters


def main():
    """Main function"""

    files = get_files()

    must_fail = False

    for file in files:
        wrong_entries = check_for_unusual_characters(file)
        if wrong_entries:
            must_fail = True
            print(f"❌ Unusual characters found in {file}")
            for key, value, character in wrong_entries:
                value = json.dumps(value, indent=4)
                print(f"Character: {character}")
                print(highlight(f'"{key}": {value}', JsonLexer(), TerminalFormatter()))

    if must_fail:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
