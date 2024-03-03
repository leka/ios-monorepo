#!/usr/bin/python3
"""Utily functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

from modules.yaml import load_yaml, dump_yaml


def sort_list_by_id(data):
    """Sort a list of dictionaries by id."""
    return sorted(data, key=lambda item: item["id"])


def check_ids_are_unique(ids):
    """Check if all ids are unique."""
    duplicates = set()

    if len(set(ids)) != len(ids):
        seen = set()

        for author_id in ids:
            if author_id in seen:
                duplicates.add(author_id)
            else:
                seen.add(author_id)

    return list(duplicates) if duplicates else None


def check_definition_list(filename):
    """Check definitions"""
    file_is_valid = True

    data = load_yaml(filename)

    data["list"] = sort_list_by_id(data["list"])
    dump_yaml(filename, data)

    ids = [item["id"] for item in data["list"]]
    duplicate_ids = check_ids_are_unique(ids)
    if duplicate_ids is not None:
        print(f"❌ There are duplicate ids in {filename}")
        print(f"Duplicate ids: {duplicate_ids}")
        file_is_valid = False

    return file_is_valid
