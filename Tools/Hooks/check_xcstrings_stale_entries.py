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

from modules.xstrings import check_for_stale_entries
from modules.utils import get_files


def main():
    """Main function."""

    files = get_files()

    must_fail = False

    for file in files:
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
