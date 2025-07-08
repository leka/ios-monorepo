#!/usr/bin/python3
"""
Base class for YAML content validators
This module provides an abstract base class for validating YAML content files.
It defines the structure and methods that all content validators should implement.
It includes methods for loading YAML files, validating against a JTD schema,
and checking for required fields and unique IDs.
It also provides utility methods for logging and error handling.
It is intended to be subclassed by specific content validators for different types of YAML files.
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

from typing import  Optional

from modules.base_validator import BaseValidator
from modules.yaml import is_jtd_schema_compliant

class BaseYamlValidator(BaseValidator):
    """
    Base class for YAML validation scripts.

    Provides common patterns like:
    - JTD schema validation
    - YAML-specific file processing
    - Inherits all BaseValidator functionality
    """

    def __init__(self, schema_path: Optional[str] = None, validator_name: str = "YAML"):
        """
        Initialize the YAML validator.

        Args:
            schema_path: Path to JTD schema file for validation (optional)
            validator_name: Name for logging messages (e.g., "tag definition", "activity")
        """
        super().__init__(validator_name)
        self.schema_path = schema_path

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

        if not is_jtd_schema_compliant(filename, self.schema_path, self.logger):
            self.logger.error(f"\n❌ Schema validation failed for {filename}")
            return False
        return True
