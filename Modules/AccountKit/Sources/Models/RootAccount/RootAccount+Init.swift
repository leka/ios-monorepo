// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension RootAccount {
    init(uuid: String? = "",
         rootOwnerUid: String = "")
    {
        self.id = uuid
        self.rootOwnerUid = rootOwnerUid
    }
}
