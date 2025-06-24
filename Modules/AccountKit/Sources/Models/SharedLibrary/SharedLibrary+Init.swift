// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension SharedLibrary {
    init(
        id: String? = nil,
        rootOwnerUid: String = "",
        createdAt _: Date? = nil,
        lastEditedAt _: Date? = nil
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
    }
}
