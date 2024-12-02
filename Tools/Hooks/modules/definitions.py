#!/usr/bin/python3
"""Utily functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import hashlib
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


def compute_sha(id_value, sha_length=4):
    """
    Compute the sha as the first `sha_length` characters of the SHA-1 hash of the id.
    Default length is 4 characters.
    """
    sha1_hash = hashlib.sha1(id_value.encode('utf-8')).hexdigest()
    sha = sha1_hash[:sha_length]
    return sha


def validate_and_update_sha(data, file, sha_length=4):
    """
    Validate and update the sha for each entry in the list.
    Adds sha if missing or incorrect.
    Returns a tuple (modified, sha_duplicates).
    """
    modified = False
    shas = []

    for item in data.get("list", []):
        id_value = item.get("id", "")
        expected_sha = compute_sha(id_value, sha_length=sha_length)
        current_sha = item.get("sha", None)

        if current_sha != expected_sha:
            # Update the sha
            item["sha"] = expected_sha
            modified = True

        shas.append(expected_sha)

    # Check for sha collisions
    unique_shas = set(shas)
    sha_duplicates = set()

    if len(unique_shas) != len(shas):
        # Find duplicates
        seen = set()
        for sha in shas:
            if sha in seen:
                sha_duplicates.add(sha)
            else:
                seen.add(sha)

    return modified, sha_duplicates


def validate_and_sort(data, file):
    """
    Sort the list by id and return whether the data was modified.
    """
    sorted_list = sort_list_by_id(data.get("list", []))
    if sorted_list != data.get("list", []):
        data["list"] = sorted_list
        dump_yaml(file, data)
        print(f"📂 Sorted entries in {file} by 'id'.")
        return True
    return False


def is_definition_list_valid(file, sha_length=4):
    """
    Check definitions, validate and update shas, and check for collisions.
    Returns True if the file is valid, False otherwise.
    """
    file_is_valid = True
    data = load_yaml(file)
    modified = False

    # Sort the list by id
    if validate_and_sort(data, file):
        modified = True

    # Check for duplicate ids
    ids = [item["id"] for item in data.get("list", [])]
    duplicate_ids = find_duplicate_ids(ids)
    if duplicate_ids:
        file_is_valid = False
        print(f"\n❌ There are duplicate ids in {file}:")
        for duplicate_id in duplicate_ids:
            print(f"   - {duplicate_id}")

    # Validate and update shas
    sha_modified, sha_duplicates = validate_and_update_sha(data, file, sha_length=sha_length)
    if sha_modified:
        dump_yaml(file, data)
        print(f"📝 Updated shas in {file}.")
        modified = True

    # If any modifications were made (sorting or sha updates), mark the file as invalid
    if modified:
        file_is_valid = False

    # Check for sha collisions
    if sha_duplicates:
        file_is_valid = False
        print(f"\n❌ There are sha collisions in {file}:")
        for sha in sha_duplicates:
            print(f"   - {sha}")

    return file_is_valid
