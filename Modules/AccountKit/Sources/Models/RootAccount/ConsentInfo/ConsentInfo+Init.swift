// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension ConsentInfo {
    init(
        policyVersion: String
    ) {
        self.policyVersion = policyVersion
        self.acceptedAt = Date()
    }
}
