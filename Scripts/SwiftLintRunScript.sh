#!/usr/bin/env bash

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

if test -d "/opt/homebrew/bin"; then
    PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin"; then
    PATH="/usr/local/bin:${PATH}"
fi

export PATH

if ! command -v swiftlint &> /dev/null; then
    echo "error: swiftlint not installed, download from https://github.com/realm/SwiftLint"
    echo "error: or install with brew install swiftlint"
    exit 1
fi

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
ROOT_DIR=$(realpath "$SCRIPT_DIR/..")

echo "Linting directory: $(pwd)"
swiftlint --config $ROOT_DIR/.swiftlint.yml --reporter xcode --use-alternative-excluding
