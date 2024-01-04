// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension String {
    var nilWhenEmpty: String? {
        isEmpty ? nil : self
    }
}
