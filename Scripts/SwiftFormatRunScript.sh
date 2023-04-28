#!/usr/bin/env bash

# Leka - iOS Monorepo
# Copyright 2023 APF France handicap
# SPDX-License-Identifier: Apache-2.0

if test -d "/opt/homebrew/bin"; then
    PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin"; then
    PATH="/usr/local/bin:${PATH}"
fi

export PATH

if ! command -v swift-format &> /dev/null; then
    echo "error: swift-format not installed, download from https://github.com/apple/swift-format"
    echo "error: or install with brew install swift-format"
    exit 1
fi

if ! command -v gxargs &> /dev/null; then
    echo "error: gxargs not installed, download from https://www.gnu.org/software/findutils/"
    echo "error: or install with brew install findutils"
    exit 1
fi

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
ROOT_DIR=$(realpath "$SCRIPT_DIR/..")

echo "SCRIPT_PATH: $SCRIPT_PATH"
echo "ROOT_DIR: $ROOT_DIR"
echo "SCRIPT_DIR: $SCRIPT_DIR"

which swift-format
which gxargs

git diff --name-status origin/main        \
| grep -E "^A|^M" | sed "s/^[AM]\t//g"    \
| grep -E "\.swift\$$"                    \
| gxargs -I '{}' -d '\n' --no-run-if-empty swift-format format --configuration $ROOT_DIR/.swift-format --in-place --parallel --color-diagnostics "$ROOT_DIR/{}"
