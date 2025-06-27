#!/usr/bin/python3
"""
Base classes for YAML validation scripts.

Provides common functionality and patterns used across all check_yaml_* scripts
to reduce duplication and improve maintainability.
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from abc import ABC, abstractmethod
from typing import List, Optional, Any

from modules.utils import get_files
from modules.yaml import is_jtd_schema_compliant


class BaseYamlValidator(ABC):
    """
    Base class for YAML validation scripts.
    
    Provides common patterns like:
    - Standard logging setup
    - JTD schema validation
    - File processing loop
    - Error aggregation
    - Consistent exit codes and messaging
    """
    
    def __init__(self, schema_path: Optional[str] = None, validator_name: str = "YAML"):
        """
        Initialize the validator.
        
        Args:
            schema_path: Path to JTD schema file for validation (optional)
            validator_name: Name for logging messages (e.g., "tag definition", "activity")
        """
        self.schema_path = schema_path
        self.validator_name = validator_name
        
        # Setup consistent logging
        logging.basicConfig(level=logging.INFO, format='%(message)s')
        self.logger = logging.getLogger(__name__)
    
    def validate_schema(self, filename: str) -> bool:
        """
        Validate file against JTD schema if schema is configured.
        
        Args:
            filename: Path to YAML file to validate
            
        Returns:
            bool: True if valid or no schema configured, False if validation failed
        """
        if not self.schema_path:
            return True
            
        if not is_jtd_schema_compliant(filename, self.schema_path):
            self.logger.error(f"\n❌ Schema validation failed for {filename}")
            return False
        return True
    
    @abstractmethod
    def validate_file(self, filename: str) -> bool:
        """
        Validate a single YAML file.
        
        Args:
            filename: Path to the YAML file to validate
            
        Returns:
            bool: True if file is valid, False otherwise
        """
        pass
    
    def should_process_file(self, filename: str) -> bool:
        """
        Check if a file should be processed by this validator.
        
        Override this method to filter files (e.g., only process specific filenames).
        
        Args:
            filename: Path to the file
            
        Returns:
            bool: True if file should be processed
        """
        return True
    
    def run(self) -> int:
        """
        Main entry point for the validator.
        
        Gets files from command line, validates each one, and returns appropriate exit code.
        
        Returns:
            int: 0 if all files valid, 1 if any validation errors
        """
        files: List[str] = get_files()
        
        if not files:
            self.logger.info(f"\n✅ No {self.validator_name} files to check!")
            return 0
        
        # Filter files if needed
        files_to_process = [f for f in files if self.should_process_file(f)]
        
        if not files_to_process:
            self.logger.info(f"\n✅ No {self.validator_name} files to check!")
            return 0
        
        self.logger.info(f"\nChecking {len(files_to_process)} {self.validator_name} files...")
        
        has_errors = False
        for file in files_to_process:
            try:
                if not self.validate_file(file):
                    has_errors = True
            except Exception as e:
                self.logger.error(f"Error processing {file}: {e}")
                has_errors = True
        
        if has_errors:
            return 1
        
        self.logger.info(f"\n✅ All {self.validator_name} files are valid!")
        return 0


def main_entry_point(validator_class: type, *args, **kwargs) -> int:
    """
    Standard main function for validator scripts.
    
    Args:
        validator_class: Class that inherits from BaseYamlValidator
        *args, **kwargs: Arguments to pass to validator constructor
        
    Returns:
        int: Exit code from validator
    """
    try:
        validator = validator_class(*args, **kwargs)
        return validator.run()
    except Exception as e:
        logging.error(f"Fatal error: {e}")
        return 1