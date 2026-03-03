#!/usr/bin/python3
"""Check content files for UUID uniqueness across different content types"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import logging
from pathlib import Path
from typing import Dict, List, Tuple

# Constants
DIRECTORY_PATH = Path("Modules/ContentKit/Resources/Content")

# Content types to check: (pattern, display_name)
CONTENT_TYPES = [
    ("*.new_activity.yml", "new_activity"),
    ("*.curriculum.yml", "curriculum"),
    ("*.story.yml", "story"),
    ("*.curation.yml", "curation"),
]

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def find_all_uuids() -> Dict[str, List[Tuple[str, Path]]]:
    """
    Find all UUIDs across all content types.

    Returns:
        Dict mapping UUID to list of (content_type, file_path) tuples
    """
    if not DIRECTORY_PATH.exists():
        logger.error(f"Directory not found: {DIRECTORY_PATH}")
        return {}

    uuid_map: Dict[str, List[Tuple[str, Path]]] = {}

    try:
        for pattern, content_type in CONTENT_TYPES:
            files = DIRECTORY_PATH.rglob(pattern)

            for file in files:
                # Extract UUID from filename: name-UUID.type.yml
                # UUID is the last segment before the extension
                uuid = file.stem.split("-")[-1]

                if uuid in uuid_map:
                    uuid_map[uuid].append((content_type, file))
                else:
                    uuid_map[uuid] = [(content_type, file)]

    except (OSError, IOError) as e:
        logger.error(f"Error scanning files: {e}")
        return {}

    return uuid_map


def check_cross_type_uuids() -> int:
    """
    Check for UUIDs that appear across different content types.

    Returns:
        int: 0 if successful, 1 if cross-type collisions found
    """
    logger.info(f"Scanning for cross-type UUID collisions in: {DIRECTORY_PATH}")

    uuid_map = find_all_uuids()

    if not uuid_map:
        logger.error("No content files found")
        return 1

    # Count total files and unique UUIDs
    total_files = sum(len(entries) for entries in uuid_map.values())
    logger.info(f"\nScanned {total_files} content files with {len(uuid_map)} unique UUIDs")

    # Find cross-type collisions
    cross_type_collisions = [
        (uuid, entries)
        for uuid, entries in uuid_map.items()
        if len(set(content_type for content_type, _ in entries)) > 1
    ]

    if cross_type_collisions:
        logger.error(f"\n❌ Found {len(cross_type_collisions)} cross-type UUID collision(s):")
        for uuid, entries in cross_type_collisions:
            logger.error(f"\n   UUID: {uuid}")
            for content_type, file in entries:
                logger.error(f"      - [{content_type}] {file.relative_to(Path.cwd())}")
        return 1

    logger.info("\n✅ No cross-type UUID collisions found!")
    return 0


def main() -> int:
    """Main entry point"""
    return check_cross_type_uuids()


if __name__ == "__main__":
    sys.exit(main())
