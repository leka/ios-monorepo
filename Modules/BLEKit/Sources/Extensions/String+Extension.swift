// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension String {
    var nilWhenEmpty: String? {
        self.isEmpty ? nil : self
    }
}
