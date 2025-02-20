#!/usr/bin/python3
"""Utility functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys
import subprocess


def get_files():
    """Get the files from the command line arguments."""
    if len(sys.argv) <= 1:
        print("\n❌ No file specified")
        sys.exit(1)

    files = sys.argv[1:]
    return files


def is_file_modified(file_path):
    """Check if a file is modified and/or staged for commit"""
    result = subprocess.run(
        ["git", "status", "--porcelain", file_path],
        capture_output=True,
        text=True,
        check=False,
    )

    output = result.stdout.strip()

    if output:
        # Check for modifications in both staged (index) and work tree
        # Staged modifications: first letter is not ' ' (space)
        # Work tree modifications: second letter is 'M'
        # This covers added (A), modified (M), deleted (D), renamed (R), etc.
        status_code = output[:2]
        if status_code[0] != " " or status_code[1] == "M":
            return True

    return False
