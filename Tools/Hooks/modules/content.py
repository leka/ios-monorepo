#!/usr/bin/python3
"""Check activities and curriculums content"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import uuid
from pathlib import Path
from datetime import datetime, timedelta
from typing import Any, Dict, List, Union


import ruamel.yaml

from check_yaml_definitions_skills import get_all_skills  # pylint: disable=import-error

DATE_NOW_TIMESTAMP = ruamel.yaml.scalarstring.DoubleQuotedScalarString(
    datetime.now().isoformat()
)

CONTENTKIT_DIRECTORY = "Modules/ContentKit/Resources/Content"

CREATED_AT_INDEX = 3
LAST_EDITED_AT_INDEX = 4

IMAGE_EXTENSIONS = [".png", ".jpg", ".jpeg", ".svg"]


def is_uuid_same_as_filename(activity, filename):
    """Check if the UUID is the same as the filename"""
    activity_uuid = activity["uuid"]
    filename_uuid = os.path.basename(filename).split("-")[-1].split(".")[0]

    if activity_uuid != filename_uuid:
        return (activity_uuid, filename_uuid)

    return None


def is_uuid_valid(uuid_to_check):
    """Check if the UUID is valid"""
    try:
        uuid.UUID(uuid_to_check)
        return True
    except ValueError:
        return False


def is_name_same_as_filename(activity, filename):
    """Check if the name is the same as the filename"""
    activity_name = activity["name"]
    filename_name = os.path.basename(filename).split("-")[0]

    if activity_name != filename_name:
        return (activity_name, filename_name)

    return None


def is_created_at_present(data):
    """Check if the created_at field is present"""
    return "created_at" in data


def add_created_at(data):
    """Add the created_at field to the YAML file"""
    if "name" in data and "status" in data:
        data.insert(CREATED_AT_INDEX, "created_at", DATE_NOW_TIMESTAMP)
        return DATE_NOW_TIMESTAMP

    return None


def is_last_edited_at_present(data):
    """Check if the last_edited_at field is present"""
    return "last_edited_at" in data


def add_last_edited_at(data):
    """Add the last_edited_at field to the YAML file"""
    if "name" in data and "status" in data:
        data.insert(LAST_EDITED_AT_INDEX, "last_edited_at", DATE_NOW_TIMESTAMP)
        return DATE_NOW_TIMESTAMP

    return None


def update_last_edited_at(data):
    """Update the last_edited_at field to the YAML file"""
    last_edited_at = datetime.fromisoformat(data["last_edited_at"])
    now_minus_delta = datetime.fromisoformat(DATE_NOW_TIMESTAMP) - timedelta(minutes=1)

    if last_edited_at < now_minus_delta:
        data["last_edited_at"] = DATE_NOW_TIMESTAMP
        return DATE_NOW_TIMESTAMP

    return None


def find_missing_skills(skills):
    """Check if the skills exist in the skills.yml"""
    skills_ids = get_all_skills()

    missing_skills = []

    for skill in skills:
        if skill not in skills_ids:
            missing_skills.append(skill)

    return missing_skills


def find_icon(icon):
    """Find the icon file"""
    start_path = Path(CONTENTKIT_DIRECTORY)
    icon_filename = icon + ".icon.png"
    for file in start_path.rglob("*.icon.png"):
        if file.name == icon_filename:
            return file
    return None


def list_icons(data):
    """List of icons from the YAML file"""
    icons = []
    for l10n_entry in data["l10n"]:
        if "details" in l10n_entry and "icon" in l10n_entry["details"]:
            icons.append(l10n_entry["details"]["icon"])
    return icons


def find_missing_icons(data: str, of_type: str):
    """Check if the icon exists"""
    icons = list_icons(data)

    missing_icons = []

    for icon in icons:
        if of_type == "activity":
            icon_name = icon + ".activity"
        if of_type == "curriculum":
            icon_name = icon + ".curriculum"
        if find_icon(icon_name) is None:
            missing_icons.append(icon)

    return missing_icons


def find_string_values_starting_with_newline(data, path=None):
    """Check if a string starts with a newline character"""
    if path is None:
        path = []  # Initialize path

    keys_with_newlines = []

    if isinstance(data, dict):  # If the item is a dictionary
        for key, value in data.items():
            keys_with_newlines += find_string_values_starting_with_newline(
                value, path + [key]
            )
    elif isinstance(data, list):  # If the item is a list
        for index, item in enumerate(data):
            keys_with_newlines += find_string_values_starting_with_newline(
                item, path + [index]
            )
    elif isinstance(data, str):  # If the item is a string
        if data.startswith("\n"):
            keys_with_newlines.append("/".join(map(str, path)))

    return keys_with_newlines


def find_empty_string_values(data, path=None):
    """Check for empty strings in the data structure"""
    if path is None:
        path = []

    keys_with_empty_strings = []

    if isinstance(data, dict):
        for key, value in data.items():
            sub_path = path + [key]  # Build the path for nested dictionaries
            if isinstance(value, str) and (value == "" or value.isspace()):
                keys_with_empty_strings.append("/".join(map(str, sub_path)))
            else:
                # Recurse into the value if it's a dict or list
                keys_with_empty_strings += find_empty_string_values(value, sub_path)
    elif isinstance(data, list):
        for index, item in enumerate(data):
            sub_path = path + [str(index)]  # Handle list indexing in the path
            # Recurse into the item if it's a dict or list
            keys_with_empty_strings += find_empty_string_values(item, sub_path)

    return keys_with_empty_strings


def find_missing_activities(data):
    """Find missing activities in the content directory"""
    activity_list = data["activities"]
    missing_activities = []

    search_path = Path(CONTENTKIT_DIRECTORY)

    for activity in activity_list:
        activity_filenmae = activity + ".activity.yml"
        matching_files = list(search_path.rglob(activity_filenmae))
        print(f"Matching files: {matching_files}")
        if not matching_files:
            print(f"Activity {activity_filenmae} not found")
            missing_activities.append(activity)

    return missing_activities


def find_missing_exercise_assets(
    data: Union[Dict, List], type_key: str = "type", value_key: str = "value"
) -> List[Any]:
    """
    Recursively search through a nested data structure of lists and dictionaries
    to find all values associated with a specified structure containing both `type`
    and `value` keys.

    Parameters:
        data (Union[Dict, List]): The data to search through.
        type_key (str): The key used to identify the type. Default is 'type'.
        value_key (str): The key whose value is to be collected. Default is 'value'.

    Returns:
        List[Any]: A list of values associated with the specified structure.
    """

    search_path = Path(CONTENTKIT_DIRECTORY)

    def is_asset_missing(asset_basename: str, image_extensions: List[str]) -> bool:
        """Check if an asset is missing for all given extensions."""
        for ext in image_extensions:
            if list(search_path.rglob(f"{asset_basename}{ext}")):
                return False
        return True

    def recursive_search(data, collected_results):
        if not isinstance(data, (dict, list)):
            return

        if isinstance(data, dict):
            if type_key in data and value_key in data and data[type_key] == "image":
                asset_basename = data[value_key] + ".activity.asset"
                if asset_basename not in collected_results and is_asset_missing(
                    asset_basename, IMAGE_EXTENSIONS
                ):
                    collected_results.append(asset_basename)
            else:
                for value in data.values():
                    recursive_search(value, collected_results)

        elif isinstance(data, list):
            for item in data:
                recursive_search(item, collected_results)

    missing_assets = []
    recursive_search(data, missing_assets)
    return missing_assets
