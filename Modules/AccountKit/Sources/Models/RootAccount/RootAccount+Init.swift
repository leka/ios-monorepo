// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension RootAccount {
    init(
        id: String = "",
        rootOwnerUid: String = "",
        library: Library = Library(),
        consentInfo: [ConsentInfo] = []
    ) {
        self.id = id
        self.rootOwnerUid = rootOwnerUid
        self.library = library
        self.consentInfo = consentInfo
    }
}
