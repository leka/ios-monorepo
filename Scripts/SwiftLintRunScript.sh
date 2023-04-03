# Leka - iOS Monorepo
# Copyright 2023 APF Frdance handicap
# SPDX-License-Identifier: Apache-2.0

if test -d "/opt/homebrew/bin"; then
    PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin"; then
    PATH="/usr/local/bin:${PATH}"
fi

export PATH

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
ROOT_DIR=$(realpath "$SCRIPT_DIR/..")

if which swiftlint > /dev/null; then
	echo "ROOT_DIR: $ROOT_DIR"
	echo "SCRIPT_DIR: $SCRIPT_DIR"
    swiftlint --config $ROOT_DIR/.swiftlint.yml --reporter xcode $ROOT_DIR
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
