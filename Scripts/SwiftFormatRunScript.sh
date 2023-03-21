# Leka - iOS Monorepo
# Copyright 2023 APF Frdance handicap
# SPDX-License-Identifier: Apache-2.0

if test -d "/opt/homebrew/bin"; then
    PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin"; then
    PATH="/usr/local/bin:${PATH}"
fi

export PATH

# if which swift-format > /dev/null; then
# 	swift-format format -i -r ../../ --configuration ../../.swift-format
# else
#     echo "warning: swift-format not installed, download from https://github.com/apple/swift-format"
# fi
