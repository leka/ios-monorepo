#!/bin/sh

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

RED='\033[0;31m' # Red color for error
BLUE='\033[4;34m' # Blue color with underline for file path
NC='\033[0m' # No Color

# Path to the JSON file you want to check
JSON_FILE="$1"

# Check for unusual terminators like <U+2028>
if grep --quiet $'\xe2\x80\xa8' "$JSON_FILE"; then
    echo "${RED}❌ Error:${NC} The file ${BLUE}$JSON_FILE${NC} contains unusual terminators (e.g., <U+2028>).\nPlease replace them with '\\\n' them using vscode"
    exit 1
fi

exit 0
