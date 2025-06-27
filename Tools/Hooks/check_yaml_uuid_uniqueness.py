#!/usr/bin/python3
"""
Generic UUID uniqueness checker for YAML content files.

This script can check UUID uniqueness for any type of content file by specifying
the file pattern and content type.
"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import argparse
import logging
from pathlib import Path
from modules.uuid_checker import check_uuids

# Constants
DEFAULT_DIRECTORY = Path("Modules/ContentKit/Resources/Content")

logging.basicConfig(level=logging.INFO, format='%(message)s')


def main() -> int:
    """
    Main function to check UUID uniqueness for content files.
    
    Returns:
        int: 0 if successful, 1 if duplicates found or errors occurred
    """
    parser = argparse.ArgumentParser(
        description="Check UUID uniqueness in YAML content files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 check_yaml_uuid_uniqueness.py activity "*.activity.yml"
  python3 check_yaml_uuid_uniqueness.py curriculum "*.curriculum.yml"
  python3 check_yaml_uuid_uniqueness.py story "*.story.yml"
        """
    )
    
    parser.add_argument(
        "content_type",
        help="Type of content being checked (e.g., 'activity', 'curriculum', 'story')"
    )
    
    parser.add_argument(
        "file_pattern", 
        help="File pattern to match (e.g., '*.activity.yml')"
    )
    
    parser.add_argument(
        "--directory",
        type=Path,
        default=DEFAULT_DIRECTORY,
        help=f"Directory to search in (default: {DEFAULT_DIRECTORY})"
    )
    
    args = parser.parse_args()
    
    return check_uuids(args.directory, args.file_pattern, args.content_type)


if __name__ == "__main__":
    sys.exit(main())