#!/usr/bin/python3
"""
Specialized validators for definition files (tags, skills, etc.).

Handles common patterns in definition validation including:
- Recursive ID checking and sorting
- Duplicate detection
- Schema validation
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

from pathlib import Path
from typing import Dict, List, Any, Optional, Callable
from abc import abstractmethod

from modules.base_validator import BaseYamlValidator
from modules.definitions import find_duplicate_ids, sort_list_by_id
from modules.yaml import load_yaml, dump_yaml


class DefinitionValidator(BaseYamlValidator):
    """
    Base validator for definition files (authors, avatars, professions, etc.).
    
    Handles simple list-based definitions with ID uniqueness and optional sorting.
    """
    
    def __init__(self, schema_path: str, validator_name: str):
        super().__init__(schema_path, validator_name)
    
    def validate_file(self, filename: str) -> bool:
        """
        Validate a definition file.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if file is valid, False otherwise
        """
        try:
            file_is_valid = True
            
            # Schema validation
            if not self.validate_schema(filename):
                file_is_valid = False
            
            # Additional validation can be overridden
            if not self.validate_definitions(filename):
                file_is_valid = False
            
            return file_is_valid
            
        except (OSError, IOError) as e:
            self.logger.error(f"Error processing {filename}: {e}")
            return False
    
    def validate_definitions(self, filename: str) -> bool:
        """
        Override this method for custom definition validation.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        return True


class RecursiveDefinitionValidator(DefinitionValidator):
    """
    Validator for definition files with recursive structures (tags with subtags, skills with subskills).
    
    Handles:
    - Recursive ID collection and duplicate checking
    - Recursive sorting by ID
    - Schema validation
    """
    
    def __init__(self, schema_path: str, definition_file: Path, validator_name: str, 
                 child_key: str = "subtags"):
        """
        Initialize recursive definition validator.
        
        Args:
            schema_path: Path to JTD schema file
            definition_file: Path to the definition file to check against
            validator_name: Name for logging (e.g., "tag definition")
            child_key: Key for child elements (e.g., "subtags", "subskills")
        """
        super().__init__(schema_path, validator_name)
        self.definition_file = definition_file
        self.child_key = child_key
    
    def should_process_file(self, filename: str) -> bool:
        """Only process the specific definition file."""
        from pathlib import Path
        try:
            # Resolve both paths to absolute paths for comparison
            file_path = Path(filename).resolve()
            definition_path = Path(self.definition_file).resolve()
            return file_path == definition_path
        except Exception:
            # Fallback to string comparison if path resolution fails
            return str(filename) == str(self.definition_file)
    
    def get_all_ids(self) -> List[str]:
        """
        Get list of all IDs including recursive children.
        
        Returns:
            List of all IDs in the definition file
        """
        try:
            data = load_yaml(self.definition_file)
            if not data:
                return []
            
            ids: List[str] = []
            
            def collect_ids_recursive(items: List[Dict[str, Any]], ids: List[str]) -> None:
                for item in items:
                    ids.append(item["id"])
                    if self.child_key in item and item[self.child_key]:
                        collect_ids_recursive(item[self.child_key], ids)
            
            collect_ids_recursive(data["list"], ids)
            return ids
            
        except (OSError, IOError) as e:
            self.logger.error(f"Error loading {self.definition_file}: {e}")
            return []
    
    def sort_recursive(self, items: List[Dict[str, Any]]) -> bool:
        """
        Sort items and their children recursively by ID.
        
        Args:
            items: List of items to sort
            
        Returns:
            bool: True if any sorting was performed
        """
        was_sorted = False
        
        # Sort current level
        if sorted_list := sort_list_by_id(items):
            items.clear()
            items.extend(sorted_list)
            was_sorted = True
        
        # Sort children recursively
        for item in items:
            if self.child_key in item and item[self.child_key]:
                if self.sort_recursive(item[self.child_key]):
                    was_sorted = True
        
        return was_sorted
    
    def validate_definitions(self, filename: str) -> bool:
        """
        Validate recursive definitions.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        try:
            file_is_valid = True
            
            data = load_yaml(filename)
            if not data:
                return False
            
            # Sort recursively if needed
            if self.sort_recursive(data["list"]):
                dump_yaml(filename, data)
                item_type = self.validator_name.split()[0]  # Extract "tag" from "tag definition"
                self.logger.info(f"\n💡 Sorted {item_type}s and {self.child_key} by ID in {filename}")
            
            # Check for duplicate IDs
            all_ids = self.get_all_ids()
            if duplicate_ids := find_duplicate_ids(all_ids):
                file_is_valid = False
                item_type = self.validator_name.split()[0]  # Extract "tag" from "tag definition"
                self.logger.error(f"\n❌ Found duplicate {item_type} IDs in {filename}:")
                for duplicate_id in duplicate_ids:
                    self.logger.error(f"   - {duplicate_id}")
            
            return file_is_valid
            
        except Exception as e:
            self.logger.error(f"Error processing {filename}: {e}")
            return False


class SimpleListDefinitionValidator(DefinitionValidator):
    """
    Validator for simple list-based definition files with optional sorting and duplicate checking.
    
    Handles files like authors.yml, avatars.yml, professions.yml, robot_assets.yml.
    """
    
    def __init__(self, schema_path: str, validator_name: str, 
                 check_duplicates: bool = True, enable_sorting: bool = True,
                 duplicate_fields: Optional[List[str]] = None):
        """
        Initialize simple list definition validator.
        
        Args:
            schema_path: Path to JTD schema file
            validator_name: Name for logging
            check_duplicates: Whether to check for duplicate IDs
            enable_sorting: Whether to sort the list by ID
            duplicate_fields: List of fields to check for duplicates (defaults to ["id"])
        """
        super().__init__(schema_path, validator_name)
        self.check_duplicates = check_duplicates
        self.enable_sorting = enable_sorting
        self.duplicate_fields = duplicate_fields or ["id"]
    
    def validate_definitions(self, filename: str) -> bool:
        """
        Validate simple list definitions.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        try:
            file_is_valid = True
            
            data = load_yaml(filename)
            if not data:
                return False
            
            # Sort by ID if enabled
            if self.enable_sorting:
                if sorted_list := sort_list_by_id(data["list"]):
                    data["list"] = sorted_list
                    dump_yaml(filename, data)
                    item_type = self.validator_name.split()[0]  # Extract item type
                    self.logger.info(f"\n💡 Sorted {item_type}s by ID in {filename}")
            
            # Check for duplicates in specified fields
            if self.check_duplicates:
                for field in self.duplicate_fields:
                    field_values = [item[field] for item in data["list"] if field in item]
                    if duplicate_values := find_duplicate_ids(field_values):
                        file_is_valid = False
                        field_name = "IDs" if field == "id" else f"{field}s"
                        self.logger.error(f"\n❌ Found duplicate {field_name} in {filename}:")
                        for duplicate_value in duplicate_values:
                            self.logger.error(f"   - {duplicate_value}")
            
            return file_is_valid
            
        except (OSError, IOError) as e:
            self.logger.error(f"Error processing {filename}: {e}")
            return False