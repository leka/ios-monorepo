#!/usr/bin/python3
"""Check the content of a YAML file for a curation"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import re
import sys
import uuid
from pathlib import Path
from typing import Any, Dict, List, Set, Tuple

from modules.base_validator import main_entry_point
from modules.base_yaml_validator import BaseYamlValidator
from modules.yaml import create_yaml_object

JTD_SCHEMA = "Specs/jtd/curation.jtd.json"
CONTENT_ROOT = Path("Modules/ContentKit/Resources/Content")
REQUIRED_LOCALES = {"fr_FR", "en_US"}
HEX_COLOR_PATTERN = re.compile(r"0x[0-9A-Fa-f]{6}")


class CurationContentValidator(BaseYamlValidator):
    REFERENCE_SUFFIXES = {
        "curriculum": ".curriculum.yml",
        "activity": ".new_activity.yml",
        "curation": ".curation.yml",
    }

    def __init__(self):
        super().__init__(schema_path=JTD_SCHEMA, validator_name="curation")
        self.reference_files = self._index_reference_files()

    def _index_reference_files(self) -> Dict[str, Set[str]]:
        indexed_files: Dict[str, Set[str]] = {}

        for item_type, suffix in self.REFERENCE_SUFFIXES.items():
            indexed_files[item_type] = {
                file_path.name
                for file_path in CONTENT_ROOT.rglob(f"*{suffix}")
            }

        return indexed_files

    @staticmethod
    def _is_uuid_valid(uuid_to_check: Any) -> bool:
        if not isinstance(uuid_to_check, str):
            return False

        try:
            uuid.UUID(uuid_to_check)
            return True
        except ValueError:
            return False

    @staticmethod
    def _filename_uuid(filename: str) -> str:
        return Path(filename).name.split("-")[-1].split(".")[0]

    @staticmethod
    def _find_empty_string_values(data: Any, path: List[str] | None = None) -> List[str]:
        if path is None:
            path = []

        keys_with_empty_strings: List[str] = []

        if isinstance(data, dict):
            for key, value in data.items():
                sub_path = path + [key]
                if isinstance(value, str) and (value == "" or value.isspace()):
                    if key not in {"subtitle", "description"}:
                        keys_with_empty_strings.append("/".join(sub_path))
                else:
                    keys_with_empty_strings += CurationContentValidator._find_empty_string_values(value, sub_path)
        elif isinstance(data, list):
            for index, item in enumerate(data):
                keys_with_empty_strings += CurationContentValidator._find_empty_string_values(item, path + [str(index)])

        return keys_with_empty_strings

    @staticmethod
    def _is_multi_hyphen_name(value: str) -> bool:
        parts = value.rsplit("-", 1)
        if len(parts) != 2:
            return False

        name_part, uuid_part = parts
        return "-" in name_part and bool(re.fullmatch(r"[0-9A-Fa-f]{32}", uuid_part))

    def _find_missing_references(self, content: Dict[str, Any]) -> Tuple[List[str], List[str]]:
        missing_references: List[str] = []
        multi_hyphen_warnings: List[str] = []

        sections = content.get("content", [])
        for section_index, section in enumerate(sections):
            if not isinstance(section, dict):
                continue

            items = section.get("items", [])
            if not isinstance(items, list):
                continue

            for item_index, item in enumerate(items):
                if not isinstance(item, dict):
                    continue

                value = item.get("value")
                item_type = item.get("type")

                if not isinstance(value, str) or not isinstance(item_type, str):
                    continue

                if self._is_multi_hyphen_name(value):
                    multi_hyphen_warnings.append(
                        f"content/{section_index}/items/{item_index}/value: {value}"
                    )

                suffix = self.REFERENCE_SUFFIXES.get(item_type)
                if suffix is None:
                    continue

                expected_filename = f"{value}{suffix}"
                if expected_filename not in self.reference_files[item_type]:
                    missing_references.append(
                        f"content/{section_index}/items/{item_index}: {item_type} -> {value}"
                    )

        return missing_references, multi_hyphen_warnings

    @staticmethod
    def _extract_raw_color_token(filename: str) -> str | None:
        with open(filename, "r", encoding="utf8") as file:
            for line in file:
                match = re.match(r"^\s*color:\s*([^\s#]+)", line)
                if match:
                    return match.group(1).strip('"\'')

        return None

    def validate_file(self, filename: str) -> bool:
        yaml = create_yaml_object()
        file_is_valid = True

        if not self.validate_schema(filename):
            file_is_valid = False

        try:
            with open(filename, "r", encoding="utf8") as file:
                content = yaml.load(file)
        except Exception as error:
            self.logger.error(f"❌ Error loading {filename}: {error}")
            return False

        content_uuid = content.get("uuid")
        filename_uuid = self._filename_uuid(filename)

        if content_uuid != filename_uuid:
            file_is_valid = False
            self.logger.error(f"❌ Curation uuid and filename uuid are not the same in {filename}")
            self.logger.error(f"uuid:     {content_uuid}")
            self.logger.error(f"filename: {filename_uuid}")

        if not self._is_uuid_valid(content_uuid):
            file_is_valid = False
            self.logger.error(f"❌ uuid not valid in {filename}")
            self.logger.error(f"uuid: {content_uuid}")

        l10n_entries = content.get("l10n", [])
        found_locales: Set[str] = set()
        for entry in l10n_entries:
            if not isinstance(entry, dict):
                continue

            locale = entry.get("locale")
            if isinstance(locale, str):
                found_locales.add(locale)

        missing_locales = REQUIRED_LOCALES - found_locales
        extra_locales = found_locales - REQUIRED_LOCALES

        if missing_locales:
            file_is_valid = False
            self.logger.error(f"\n❌ CRITICAL Missing locales in l10n entries in {filename}")
            for locale in sorted(missing_locales):
                self.logger.error(f"   - {locale}")

        if extra_locales:
            file_is_valid = False
            self.logger.error(f"\n❌ CRITICAL Extra locales in l10n entries in {filename}")
            for locale in sorted(extra_locales):
                self.logger.error(f"   - {locale}")

        raw_color_token = self._extract_raw_color_token(filename)
        if raw_color_token is None or not HEX_COLOR_PATTERN.fullmatch(raw_color_token):
            file_is_valid = False
            self.logger.error(f"\n❌ Invalid color format in {filename}")
            self.logger.error(f"   - color: {raw_color_token} (expected format: 0xRRGGBB)")

        if empty_string_values := self._find_empty_string_values(content):
            file_is_valid = False
            self.logger.error(f"\n❌ Found empty strings in {filename}")
            for string in empty_string_values:
                self.logger.error(f"  - {string}")

        missing_references, multi_hyphen_warnings = self._find_missing_references(content)

        if missing_references:
            file_is_valid = False
            self.logger.error(f"\n❌ Found unresolved curation item references in {filename}")
            for reference in missing_references:
                self.logger.error(f"  - {reference}")

        if multi_hyphen_warnings:
            self.logger.info(f"\nℹ️ Found multi-hyphen curation item names in {filename}")
            self.logger.info("   CurationItemModel splits on all hyphens and may truncate names.")
            for warning in multi_hyphen_warnings:
                self.logger.info(f"  - {warning}")

        return file_is_valid


def main() -> int:
    return main_entry_point(CurationContentValidator)


if __name__ == "__main__":
    sys.exit(main())
