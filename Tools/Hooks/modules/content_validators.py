#!/usr/bin/python3
"""
Content validators for YAML content files (activities, curriculums, stories).

Handles common patterns in content validation including:
- Multiprocessing for performance
- UUID and filename consistency
- Schema validation
- Timestamp management
- Cross-reference validation (skills, tags, etc.)
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
from multiprocessing import Pool, cpu_count
from typing import List, Dict, Any, Optional

from modules.base_validator import BaseYamlValidator
from modules.content import (
    is_created_at_present,
    is_last_edited_at_present,
    add_created_at,
    add_last_edited_at,
    update_last_edited_at,
    is_uuid_same_as_filename,
    is_name_same_as_filename,
    is_uuid_valid,
    find_missing_skills,
    find_missing_tags,
    find_missing_icons,
    find_string_values_starting_with_newline,
    find_empty_string_values,
)
from modules.utils import is_file_modified
from modules.yaml import create_yaml_object


class ContentValidator(BaseYamlValidator):
    """
    Base validator for content files (activities, curriculums, stories).
    
    Handles common validation patterns including UUID checking, timestamp management,
    and cross-reference validation.
    """
    
    def __init__(self, schema_path: str, validator_name: str, content_type: str):
        """
        Initialize content validator.
        
        Args:
            schema_path: Path to JTD schema file
            validator_name: Name for logging (e.g., "activity")
            content_type: Type of content for icon validation
        """
        super().__init__(schema_path, validator_name)
        self.content_type = content_type
    
    def validate_content_item(self, filename: str) -> bool:
        """
        Validate a single content item.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if file is valid, False otherwise
        """
        yaml = create_yaml_object()
        file_is_valid = True
        
        # Schema validation
        if not self.validate_schema(filename):
            file_is_valid = False
        
        # Load content
        try:
            with open(filename, "r", encoding="utf8") as file:
                content = yaml.load(file)
        except Exception as e:
            print(f"\n❌ Error loading {filename}: {e}")
            return False
        
        # UUID validation
        if differing_uuids := is_uuid_same_as_filename(content, filename):
            file_is_valid = False
            content_uuid, filename_uuid = differing_uuids
            print(f"\n❌ {self.content_type.title()} uuid and filename uuid are not the same in {filename}")
            print(f"uuid:     {content_uuid}")
            print(f"filename: {filename_uuid}")
        
        if not is_uuid_valid(content["uuid"]):
            file_is_valid = False
            print(f"\n❌ uuid not valid in {filename}")
            print(f"uuid: {content['uuid']}")
        
        # Name validation
        if differing_names := is_name_same_as_filename(content, filename):
            file_is_valid = False
            content_name, filename_name = differing_names
            print(f"\n❌ {self.content_type.title()} name and filename name are not the same in {filename}")
            print(f"name:     {content_name}")
            print(f"filename: {filename_name}")
        
        # Timestamp validation and management
        if not is_created_at_present(content):
            file_is_valid = False
            print(f"\n❌ Missing key created_at in {filename}")
            if timestamp := add_created_at(content):
                print(f"Add created_at: {timestamp}")
                with open(filename, "w", encoding="utf8") as file:
                    yaml.dump(content, file)
        
        if not is_last_edited_at_present(content):
            file_is_valid = False
            print(f"\n❌ Missing key last_edited_at in {filename}")
            if timestamp := add_last_edited_at(content):
                print(f"Add last_edited_at: {timestamp}")
                with open(filename, "w", encoding="utf8") as file:
                    yaml.dump(content, file)
        
        if is_file_modified(filename) and (timestamp := update_last_edited_at(content)):
            file_is_valid = False
            print(f"\n❌ last_edited_at is not up to date in {filename}")
            print(f"Update last_edited_at: {timestamp}")
            with open(filename, "w", encoding="utf8") as file:
                yaml.dump(content, file)
        
        # Cross-reference validation
        if missing_skills := find_missing_skills(content["skills"]):
            file_is_valid = False
            print(f"\n❌ The following skills do not exist in {filename}")
            for skill in missing_skills:
                print(f"   - {skill}")
        
        if missing_tags := find_missing_tags(content["tags"]):
            file_is_valid = False
            print(f"\n❌ The following tags do not exist in {filename}")
            for tag in missing_tags:
                print(f"   - {tag}")
        
        if missing_icons := find_missing_icons(content, of_type=self.content_type):
            file_is_valid = False
            print(f"\n❌ The following icons do not exist in {filename}")
            for icon in missing_icons:
                print(f"   - {icon}")
        
        # String validation
        if strings_with_newline := find_string_values_starting_with_newline(content):
            file_is_valid = False
            print(f"\n❌ Found strings starting with newline in {filename}")
            for string in strings_with_newline:
                print(f"  - {string}")
        
        if empty_string_values := find_empty_string_values(content):
            file_is_valid = False
            print(f"\n❌ Found empty strings in {filename}")
            for string in empty_string_values:
                print(f"  - {string}")
        
        # Content-specific validation (override in subclasses)
        if not self.validate_content_specific(content, filename):
            file_is_valid = False
        
        return file_is_valid
    
    def validate_content_specific(self, content: Dict[str, Any], filename: str) -> bool:
        """
        Override this method for content-specific validation.
        
        Args:
            content: Loaded YAML content
            filename: Path to the YAML file
            
        Returns:
            bool: True if valid, False otherwise
        """
        return True
    
    def validate_file(self, filename: str) -> bool:
        """
        Validate a single file (used by multiprocessing).
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if file is valid, False otherwise
        """
        return self.validate_content_item(filename)
    
    def run(self) -> int:
        """
        Run validation with multiprocessing for performance.
        
        Returns:
            int: 0 if all files valid, 1 if any validation errors
        """
        from modules.utils import get_files
        
        files: List[str] = get_files()
        
        if not files:
            print(f"\n✅ No {self.validator_name} files to check!")
            return 0
        
        # Filter files if needed
        files_to_process = [f for f in files if self.should_process_file(f)]
        
        if not files_to_process:
            print(f"\n✅ No {self.validator_name} files to check!")
            return 0
        
        workers = max(1, cpu_count() - 1)
        print(f"\nChecking {len(files_to_process)} files using {workers} workers...")
        
        with Pool(processes=workers) as pool:
            results = pool.map(self.validate_content_item, files_to_process)
        
        has_errors = not all(results)
        
        if has_errors:
            return 1
        
        print(f"\n✅ All checked {self.validator_name} files are valid!")
        return 0