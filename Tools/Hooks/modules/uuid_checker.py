#!/usr/bin/python3
"""Common module for checking UUID uniqueness across YAML files"""

# Leka - LekaOS
# Copyright 2020 APF France handicap
# SPDX-License-Identifier: Apache-2.0

import logging
from pathlib import Path
from typing import Dict, List, Tuple

logger = logging.getLogger(__name__)


def find_duplicates(directory: Path, pattern: str) -> Tuple[List[Tuple[str, List[Path]]], Dict[str, List[Path]]]:
    """
    Find files with duplicate UUIDs.

    Args:
        directory: Base directory to search in
        pattern: File pattern to match (e.g. "*.story.yml")

    Returns:
        Tuple containing:
        - List of tuples with duplicate UUIDs and their files
        - Dict of all UUIDs and their files
    """
    if not directory.exists():
        logger.error(f"Directory not found: {directory}")
        return [], {}

    try:
        uuids_files: Dict[str, List[Path]] = {}
        files = directory.rglob(pattern)

        for file in files:
            uuid = file.stem.split("-")[-1]
            if uuid in uuids_files:
                uuids_files[uuid].append(file)
            else:
                uuids_files[uuid] = [file]

        duplicates = [(uuid, files) for uuid, files in uuids_files.items() if len(files) > 1]
        return duplicates, uuids_files

    except (OSError, IOError) as e:
        logger.error(f"Error scanning files: {e}")
        return [], {}


def check_uuids(directory: Path, pattern: str, file_type: str) -> int:
    """
    Check for duplicate UUIDs in files.

    Args:
        directory: Base directory to search in
        pattern: File pattern to match
        file_type: Type of files being checked (for logging)

    Returns:
        int: 0 if successful, 1 if duplicates found or errors occurred
    """
    logger.info(f"Scanning for duplicate UUIDs in: {directory}")

    duplicates, all_uuids = find_duplicates(directory, pattern)

    total_files = sum(len(files) for files in all_uuids.values())
    logger.info(f"\nScanned {total_files} {file_type} files with {len(all_uuids)} unique UUIDs")

    if duplicates:
        logger.error(f"\n❌ Found {len(duplicates)} duplicate UUIDs:")
        for uuid, files in duplicates:
            logger.error(f"\n   UUID: {uuid}")
            for file in files:
                logger.error(f"      - {file.relative_to(Path.cwd())}")
        return 1

    logger.info("\n✅ No duplicate UUIDs found!")
    return 0
