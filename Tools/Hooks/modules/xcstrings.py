#!/usr/bin/python3
"""Module providing a hook to check for stale entries in .xcstrings files."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json


def find_stale_entries(json_file):
    """Check for stale entries in a .xcstrings file."""
    with open(json_file, "r", encoding="utf8") as file:
        data = json.load(file)
        strings = data.get("strings", {})

    stale_entries = []

    for key, value in strings.items():
        if value.get("extractionState") == "stale":
            stale_entries.append((key, strings[key]))

    return stale_entries


def find_unusual_characters(file_path):
    """Check the given file for unusual terminators."""
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    characters_to_search = [
        "\u2028",
    ]

    def search_localizations(localizations, parent_key):
        wrong_entries = []

        if isinstance(localizations, dict):
            for key, value in localizations.items():
                if key == "stringUnit" and "value" in value:
                    localized_string = value["value"]
                    for character in characters_to_search:
                        if character in localized_string:
                            wrong_entries.append((parent_key, localized_string, character))
                else:
                    wrong_entries.extend(search_localizations(value, parent_key))

        return wrong_entries

    wrong_entries = []

    for key, value in data.get("strings", {}).items():
        localizations = value.get("localizations", {})
        wrong_entries.extend(search_localizations(localizations, key))

    return wrong_entries
