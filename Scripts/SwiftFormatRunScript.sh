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

if which swift-format > /dev/null; then
	echo "ROOT_DIR: $ROOT_DIR"
	echo "SCRIPT_DIR: $SCRIPT_DIR"
	swift-format format --configuration $ROOT_DIR/.swift-format --in-place --parallel  --color-diagnostics --recursive $ROOT_DIR
else
    echo "warning: swift-format not installed, download from https://github.com/apple/swift-format"
fi
