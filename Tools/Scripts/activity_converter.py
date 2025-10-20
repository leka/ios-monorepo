#!/usr/bin/env python3
"""Convert legacy activity YAML files to the new .new_activity.yml format."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from collections.abc import Iterable
from typing import Any, Dict

from ruamel.yaml import YAML
from ruamel.yaml.comments import CommentedMap, CommentedSeq


yaml = YAML()
yaml.preserve_quotes = True
yaml.width = 4096  # Do not reflow multi-line strings
yaml.indent(mapping=2, sequence=4, offset=2)


INTERFACE_ALIASES = {
    "touchToSelect": "touchToSelect",
    "robotThenTouchToSelect": "touchToSelect",
    "listenThenTouchToSelect": "touchToSelect",
    "observeThenTouchToSelect": "touchToSelect",
    "dragAndDropIntoZones": "dragAndDropGridWithZones",
    "robotThenDragAndDropIntoZones": "dragAndDropGridWithZones",
    "listenThenDragAndDropIntoZones": "dragAndDropGridWithZones",
    "observeThenDragAndDropIntoZones": "dragAndDropGridWithZones",
    "dragAndDropToAssociate": "dragAndDropGrid",
    "robotThenDragAndDropToAssociate": "dragAndDropGrid",
    "listenThenDragAndDropToAssociate": "dragAndDropGrid",
    "observeThenDragAndDropToAssociate": "dragAndDropGrid",
    "dragAndDropInOrder": "dragAndDropOneToOne",
}

ZONE_CATEGORY = {
    "A": "catA",
    "B": "catB",
    "C": "catC",
    "D": "catD",
}


class ActivityConversionError(RuntimeError):
    """Raised when the converter encounters an unexpected structure."""


def convert_file(source: Path, destination: Path, force: bool = False) -> None:
    if not source.exists():
        raise ActivityConversionError(f"Source file '{source}' does not exist.")

    if destination.exists() and not force:
        raise ActivityConversionError(
            f"Destination file '{destination}' already exists. Use --force to overwrite."
        )

    with source.open("r", encoding="utf-8") as stream:
        data = yaml.load(stream)

    if not isinstance(data, CommentedMap):
        raise ActivityConversionError("Activity YAML root must be a mapping.")

    data["version"] = "2.0.0"

    if "exercises_payload" not in data:
        raise ActivityConversionError("Missing 'exercises_payload' section in activity file.")

    exercises_payload = data.pop("exercises_payload")
    converted_payload = convert_payload(exercises_payload)
    data["payload"] = converted_payload

    with destination.open("w", encoding="utf-8") as stream:
        yaml.dump(data, stream)


def convert_payload(payload: Any) -> CommentedMap:
    if not isinstance(payload, CommentedMap):
        raise ActivityConversionError("'exercises_payload' must be a mapping.")

    converted = CommentedMap()

    for key in payload:
        if key == "exercise_groups":
            groups = payload[key]
            if not isinstance(groups, Iterable):
                raise ActivityConversionError("'exercise_groups' must be a list of groups.")
            converted_groups = CommentedSeq()
            for group in groups:
                converted_groups.append(convert_group(group))
            converted[key] = converted_groups
        else:
            converted[key] = payload[key]

    if "exercise_groups" not in converted:
        raise ActivityConversionError("'exercise_groups' section is required in payload.")

    return converted


def convert_group(group: Any) -> CommentedMap:
    if not isinstance(group, CommentedMap):
        raise ActivityConversionError("Each group entry must be a mapping containing a 'group' key.")

    if "group" not in group:
        raise ActivityConversionError("Missing 'group' key in exercise group entry.")

    exercises = group["group"]
    if not isinstance(exercises, Iterable):
        raise ActivityConversionError("'group' must contain a list of exercises.")

    converted_group = CommentedMap()
    converted_exercises = CommentedSeq()

    for exercise in exercises:
        converted_exercises.append(convert_exercise(exercise))

    converted_group["group"] = converted_exercises
    return converted_group


def convert_exercise(exercise: Any) -> CommentedMap:
    if not isinstance(exercise, CommentedMap):
        raise ActivityConversionError("Each exercise must be a mapping.")

    original_interface = exercise.get("interface")
    gameplay = exercise.get("gameplay")

    if original_interface is None or gameplay is None:
        raise ActivityConversionError("Exercise entries must define both 'interface' and 'gameplay'.")

    new_interface = INTERFACE_ALIASES.get(original_interface, original_interface)
    exercise["interface"] = new_interface

    if (
        original_interface in {
            "dragAndDropIntoZones",
            "robotThenDragAndDropIntoZones",
            "listenThenDragAndDropIntoZones",
            "observeThenDragAndDropIntoZones",
        }
        and gameplay == "findTheRightAnswers"
    ):
        exercise["gameplay"] = "associateCategories"
        gameplay = "associateCategories"

    payload = exercise.get("payload")
    if not isinstance(payload, CommentedMap):
        raise ActivityConversionError("Each exercise must contain a mapping under 'payload'.")

    move_shuffle_choices_to_options(exercise, payload)

    if exercise["interface"] == "dragAndDropOneToOne":
        ensure_shuffle_choices_option(exercise)

    if gameplay == "associateCategories":
        convert_zones_payload(payload)

    exercise["payload"] = payload
    return exercise


def move_shuffle_choices_to_options(exercise: CommentedMap, payload: CommentedMap) -> None:
    shuffle_choices = payload.pop("shuffle_choices", None)
    if shuffle_choices is not None:
        options = ensure_options_mapping(exercise)
        options["shuffle_choices"] = bool(shuffle_choices)


def ensure_shuffle_choices_option(exercise: CommentedMap) -> None:
    options = ensure_options_mapping(exercise)
    options["shuffle_choices"] = True


def ensure_options_mapping(exercise: CommentedMap) -> CommentedMap:
    existing = exercise.get("options")
    if isinstance(existing, CommentedMap):
        return existing

    options = CommentedMap()
    keys = list(exercise.keys())
    insert_after = None
    for anchor in ("instructions", "interface", "gameplay", "action"):
        if anchor in exercise:
            insert_after = anchor

    if "payload" in exercise:
        index = keys.index("payload")
        exercise.insert(index, "options", options)
    elif insert_after is not None:
        index = keys.index(insert_after) + 1
        exercise.insert(index, "options", options)
    else:
        exercise["options"] = options

    return options


def convert_zones_payload(payload: CommentedMap) -> None:
    if "choices" not in payload:
        raise ActivityConversionError("associateCategories payloads must include 'choices'.")

    choices = payload["choices"]
    if not isinstance(choices, Iterable):
        raise ActivityConversionError("'choices' must be a list.")

    # Extract drop zones (dropZoneA, dropZoneB, ...)
    zone_entries: dict[str, CommentedMap] = {}
    keys_to_remove = [key for key in payload if key.startswith("dropZone")]
    for key in keys_to_remove:
        zone_data = payload.pop(key)
        if not isinstance(zone_data, CommentedMap):
            raise ActivityConversionError(f"Drop zone '{key}' must be a mapping.")
        zone_entries[key] = zone_data

    new_choices = CommentedSeq()

    for key in sorted(zone_entries.keys()):
        zone_data = zone_entries[key]
        suffix = key.replace("dropZone", "")
        category = ZONE_CATEGORY.get(suffix)
        if category is None:
            raise ActivityConversionError(f"Unsupported drop zone identifier '{key}'.")

        zone_choice = CommentedMap()
        for field in zone_data:
            zone_choice[field] = zone_data[field]
        zone_choice["category"] = category
        zone_choice["is_dropzone"] = True
        new_choices.append(zone_choice)

    for item in choices:
        if not isinstance(item, CommentedMap):
            raise ActivityConversionError("Each choice must be a mapping.")
        mapped = CommentedMap()
        for field in item:
            if field == "dropZone":
                zone_value = item[field]
                if not isinstance(zone_value, str) or not zone_value.startswith("zone"):
                    raise ActivityConversionError(
                        "'dropZone' values must be strings starting with 'zone'."
                    )
                suffix = zone_value.replace("zone", "")
                category = ZONE_CATEGORY.get(suffix.upper())
                if category is None:
                    raise ActivityConversionError(
                        f"Unsupported drop zone value '{zone_value}' in choice."
                    )
                mapped["category"] = category
            else:
                mapped[field] = item[field]
        new_choices.append(mapped)

    payload["choices"] = new_choices


def parse_arguments(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Path to the legacy .activity.yml file")
    parser.add_argument(
        "destination",
        type=Path,
        nargs="?",
        help="Optional path for the converted file. Defaults to replacing the extension with .new_activity.yml.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite the destination file if it already exists.",
    )
    return parser.parse_args(argv)


def main(argv: Iterable[str] | None = None) -> int:
    args = parse_arguments(argv or sys.argv[1:])
    source: Path = args.source

    if args.destination is not None:
        destination = args.destination
    else:
        if source.name.endswith(".activity.yml"):
            destination = source.with_name(
                source.name.replace(".activity.yml", ".new_activity.yml")
            )
        else:
            destination = source.with_suffix(".new_activity.yml")

    try:
        convert_file(source, destination, force=args.force)
    except ActivityConversionError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
