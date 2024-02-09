#!/bin/sh

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

RED='\033[0;31m' # Red color for error
BLUE='\033[4;34m' # Blue color with underline for file path
NC='\033[0m' # No Color

JSON_FILE="$1"

jq -e '.strings | to_entries | all(.value.extractionState != "stale")' $JSON_FILE > /dev/null

RET_VAL=$?

if [ $RET_VAL -ne 0 ]; then
    echo "${RED}❌ Error:${NC} Some strings are stale, please open ${BLUE}$JSON_FILE${NC} in Xcode to remove them."
    exit 1
else
    exit 0
fi
