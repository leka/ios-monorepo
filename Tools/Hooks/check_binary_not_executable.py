#!/usr/bin/python3
"""Check that binary files do not have the executable bit set"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import sys


def main() -> int:
    """Check that binary files are not executable"""
    files = sys.argv[1:]
    if not files:
        return 0

    failed_files = []
    for filepath in files:
        if os.path.isfile(filepath) and os.access(filepath, os.X_OK):
            failed_files.append(filepath)

    if failed_files:
        print("The following binary files have the executable bit set:")
        for f in failed_files:
            print(f"  - {f}")
        print("\nTo fix, run:")
        print(f"  chmod -x {' '.join(failed_files)}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
