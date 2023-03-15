# Leka - iOS Monorepo
# Copyright 2023 APF Frdance handicap
# SPDX-License-Identifier: Apache-2.0

if test -d "/opt/homebrew/bin"; then
    PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin"; then
    PATH="/usr/local/bin:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
    swiftlint --config ../../.swiftlint.yml --reporter xcode
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
