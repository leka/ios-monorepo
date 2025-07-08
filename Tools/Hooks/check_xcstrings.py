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

from modules.base_validator import BaseValidator, main_entry_point
from modules.xcstrings import find_stale_entries, find_unusual_characters


class XcstringsValidator(BaseValidator):
    """
    Validator for .xcstrings files.

    Checks for:
    - Stale entries
    - Unusual characters in localizations
    """

    def __init__(self):
        super().__init__("xcstrings")

    def validate_file(self, filename: str) -> bool:
        """
        Check xcstrings file for stale entries and unusual characters.

        Args:
            filename: Path to the .xcstrings file to validate

        Returns:
            bool: True if file is valid, False otherwise
        """
        file_is_valid = True

        if stale_entries := find_stale_entries(filename):
            file_is_valid = False
            self.logger.error(f"\n❌ Stale entries found in {filename}")
            for key, data in stale_entries:
                data = json.dumps(data, indent=4)
                self.logger.error(highlight(f'"{key}": {data}', JsonLexer(), TerminalFormatter()))

        if problematic_entries := find_unusual_characters(filename):
            file_is_valid = False
            self.logger.error(f"\n❌ Unusual characters found in {filename}")
            for key, value, character in problematic_entries:
                value = json.dumps(value, indent=4)
                self.logger.error(f"Character: {character}")
                self.logger.error(highlight(f'"{key}": {value}', JsonLexer(), TerminalFormatter()))

        return file_is_valid


def main():
    """Main function."""
    return main_entry_point(XcstringsValidator)


if __name__ == "__main__":
    sys.exit(main())
