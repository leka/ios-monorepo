#!/usr/bin/python3
"""Utily functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

from modules.yaml import load_yaml, dump_yaml


def sort_list_by_id(data):
    """Sort a list of dictionaries by id."""
    return sorted(data, key=lambda item: item["id"])


def find_duplicate_ids(ids):
    """Check if all ids are unique."""
    duplicates = set()

    if len(set(ids)) != len(ids):
        seen = set()

        for author_id in ids:
            if author_id in seen:
                duplicates.add(author_id)
            else:
                seen.add(author_id)

    return duplicates


def is_definition_list_valid(file):
    """Check definitions"""
    file_is_valid = True

    data = load_yaml(file)

    if sorted_list := sort_list_by_id(data["list"]):
        data["list"] = sorted_list
        dump_yaml(file, data)

    ids = [item["id"] for item in data["list"]]
    if duplicate_ids := find_duplicate_ids(ids):
        file_is_valid = False
        print(f"\n❌ There are duplicate ids in {file}")
        for duplicate_id in duplicate_ids:
            print(f"   - {duplicate_id}")

    return file_is_valid
