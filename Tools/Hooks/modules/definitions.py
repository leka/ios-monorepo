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


def validate_and_update_sha(entry, shas_set, sha_length=4, file=None):
    """
    Validate and update the sha for a single entry.
    Adds sha if missing or incorrect.
    Returns True if modified, False otherwise.
    Also updates shas_set with the sha.
    """
    modified = False
    id_value = entry.get("id", "")
    expected_sha = compute_sha(id_value, sha_length=sha_length)
    current_sha = entry.get("sha", None)

    if current_sha != expected_sha:
        # Update the sha
        entry["sha"] = expected_sha
        modified = True
        if file:
            print(f"🔧 Updated sha for id '{id_value}' to '{expected_sha}' in {file}.")

    # Check for duplicate shas
    if expected_sha in shas_set:
        return modified, expected_sha  # Duplicate found
    shas_set.add(expected_sha)
    return modified, None  # No duplicate


def process_entries(entries, shas_set, sha_length=4, file=None):
    """
    Recursively process a list of entries and their subskills.
    Returns a tuple (modified, duplicate_shas).
    """
    modified = False
    duplicate_shas = set()

    # Sort entries by id
    sorted_entries = sort_list_by_id(entries)
    if sorted_entries != entries:
        entries[:] = sorted_entries
        modified = True
        if file:
            print(f"📂 Sorted entries in {file} by 'id'.")

    for entry in entries:
        # Validate and update sha
        entry_modified, duplicate_sha = validate_and_update_sha(
            entry, shas_set, sha_length=sha_length, file=file
        )
        if entry_modified:
            modified = True
        if duplicate_sha:
            duplicate_shas.add(duplicate_sha)

        # Recursively process subskills
        if "subskills" in entry and isinstance(entry["subskills"], list):
            sub_modified, sub_duplicates = process_entries(
                entry["subskills"], shas_set, sha_length=sha_length, file=file
            )
            if sub_modified:
                modified = True
            duplicate_shas.update(sub_duplicates)

    return modified, duplicate_shas


def is_definition_list_valid(file, sha_length=4):
    """
    Check definitions, validate and update shas, and check for collisions.
    Returns True if the file is valid, False otherwise.
    """
    file_is_valid = True
    data = load_yaml(file)
    modified = False
    duplicate_shas = set()
    shas_set = set()

    # Process the main list and all subskills
    if "list" in data and isinstance(data["list"], list):
        list_modified, list_duplicates = process_entries(
            data["list"], shas_set, sha_length=sha_length, file=file
        )
        if list_modified:
            modified = True
        duplicate_shas.update(list_duplicates)

    # Check for duplicate ids
    ids = []

    def collect_ids(entries):
        for entry in entries:
            ids.append(entry["id"])
            if "subskills" in entry and isinstance(entry["subskills"], list):
                collect_ids(entry["subskills"])

    collect_ids(data.get("list", []))
    duplicate_ids = find_duplicate_ids(ids)
    if duplicate_ids:
        file_is_valid = False
        print(f"\n❌ There are duplicate ids in {file}:")
        for duplicate_id in duplicate_ids:
            print(f"   - {duplicate_id}")

    # If any shas were duplicated
    if duplicate_shas:
        file_is_valid = False
        print(f"\n❌ There are sha collisions in {file}:")
        for sha in duplicate_shas:
            print(f"   - {sha}")

    # If modifications were made, dump the updated YAML
    if modified:
        dump_yaml(file, data)
        print(f"📝 Updated shas in {file}.")
        file_is_valid = False
        print(f"\n⚠️  Changes were made to {file}. Please review and re-commit.")

    return file_is_valid
