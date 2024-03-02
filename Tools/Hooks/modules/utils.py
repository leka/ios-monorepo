#!/usr/bin/python3
"""Utily functions for the hooks."""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import sys


def get_files():
    """Get the files from the command line arguments."""
    if len(sys.argv) <= 1:
        print("\n❌ No file specified")
        sys.exit(1)

    files = sys.argv[1:]
    return files
