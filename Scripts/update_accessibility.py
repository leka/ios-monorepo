#!/usr/bin/env python3
"""Update accessibility metadata for activity YAML files."""
from __future__ import annotations

from pathlib import Path
from typing import Iterable, Optional

from ruamel.yaml import YAML

REPO_ROOT = Path(__file__).resolve().parent.parent
CONTENT_ROOT = REPO_ROOT / "Modules" / "ContentKit" / "Resources" / "Content"

DRAG_INTERFACES = {
    "dragAndDropGrid",
    "dragAndDropGridWithZones",
    "dragAndDropOneToOne",
}
MAGIC_INTERFACES = {"magicCards"}

EAR_TYPES = {"audio", "speech"}
EYE_TYPES = {"color", "sfsymbol", "emoji", "image"}


def iter_exercises(activity: dict) -> Iterable[dict]:
    payload = activity.get("payload") or {}
    for group_entry in payload.get("exercise_groups", []):
        for exercise in group_entry.get("group", []):
            if isinstance(exercise, dict):
                yield exercise


def gesture_from_interfaces(interfaces: Iterable[str]) -> Optional[str]:
    categories = set()
    for interface in interfaces:
        if interface in DRAG_INTERFACES:
            categories.add("drag_and_drop")
        elif interface in MAGIC_INTERFACES:
            categories.add("magic_card")
        else:
            categories.add("touch_to_select")
    if not categories:
        return None
    if len(categories) == 1:
        return next(iter(categories))
    return "mixed"


def focus_from_actions(actions: Iterable[dict]) -> Optional[str]:
    categories = set()
    for action in actions:
        action_type = action.get("type")
        if action_type == "robot":
            categories.add("robot")
            continue
        if action_type != "ipad":
            continue
        value = action.get("value") or {}
        value_type = value.get("type")
        if value_type in EAR_TYPES:
            categories.add("ear")
        elif value_type in EYE_TYPES:
            categories.add("eye")
    if not categories:
        return None
    if len(categories) == 1:
        return next(iter(categories))
    return "mixed"


def remove_existing_accessibility(lines: list[str]) -> None:
    for index, line in enumerate(lines):
        if line.strip() == "accessibility:":
            start = index
            end = index + 1
            while end < len(lines) and (lines[end].startswith("  - ") or not lines[end].strip()):
                end += 1
            if start > 0 and not lines[start - 1].strip():
                start -= 1
            del lines[start:end]
            break


def insert_accessibility(lines: list[str], gesture: str, focus: Optional[str]) -> None:
    try:
        hmi_index = next(i for i, line in enumerate(lines) if line.strip() == "hmi:")
    except StopIteration as exc:
        raise ValueError("Could not find 'hmi:' key in activity file") from exc

    insert_lines = ["accessibility:", f"  - gesture: {gesture}"]
    if focus:
        insert_lines.append(f"  - focus: {focus}")
    insert_lines.append("")

    if hmi_index > 0 and lines[hmi_index - 1].strip():
        insert_lines.insert(0, "")

    lines[hmi_index:hmi_index] = insert_lines


def update_accessibility_text(text: str, gesture: Optional[str], focus: Optional[str]) -> str:
    lines = text.splitlines()
    had_trailing_newline = text.endswith("\n")

    if not any(line.strip() == "hmi:" for line in lines):
        return text

    remove_existing_accessibility(lines)

    if gesture:
        insert_accessibility(lines, gesture, focus)

    new_text = "\n".join(lines)
    if had_trailing_newline or new_text:
        new_text += "\n"
    return new_text


def update_accessibility(path: Path, yaml_loader: YAML) -> bool:
    original_text = path.read_text(encoding="utf-8")
    activity = yaml_loader.load(original_text)
    if activity is None:
        return False

    interfaces: list[str] = []
    actions: list[dict] = []
    for exercise in iter_exercises(activity):
        interface = exercise.get("interface")
        if interface:
            interfaces.append(interface)
        action = exercise.get("action")
        if isinstance(action, dict):
            actions.append(action)

    gesture = gesture_from_interfaces(interfaces)
    focus = focus_from_actions(actions)

    new_text = update_accessibility_text(original_text, gesture, focus)
    if new_text == original_text:
        return False

    path.write_text(new_text, encoding="utf-8")
    return True


def main() -> None:
    yaml_loader = YAML(typ="safe")

    updated_files = []
    for activity_path in sorted(CONTENT_ROOT.rglob("*.new_activity.yml")):
        if update_accessibility(activity_path, yaml_loader):
            updated_files.append(activity_path)

    if updated_files:
        print("Updated accessibility in", len(updated_files), "files")
    else:
        print("No accessibility updates were necessary.")


if __name__ == "__main__":
    main()
