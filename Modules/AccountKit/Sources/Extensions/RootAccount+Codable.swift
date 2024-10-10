// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension RootAccount {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.rootOwnerUid = try container.decode(String.self, forKey: .rootOwnerUid)
        self.library = try container.decodeIfPresent(Library.self, forKey: .library) ?? Library()
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.lastEditedAt = try container.decodeIfPresent(Date.self, forKey: .lastEditedAt)
    }
}
