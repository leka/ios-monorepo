#!/usr/bin/python3
"""Module providing a hook to check for stale entries in .xcstrings files."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import json


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


def check_for_unusual_characters(file_path):
    """Check the given file for unusual terminators."""
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    characters_to_search = [
        "\u2028",
    ]

    wrong_entries = []

    # Navigate through the JSON structure
    for key, value in data["strings"].items():
        for _, localizations in value["localizations"].items():
            localized_string = localizations["stringUnit"]["value"]
            for character in characters_to_search:
                if character in localized_string:
                    wrong_entries.append((key, value, character))

    return wrong_entries
