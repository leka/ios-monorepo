// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit

// MARK: - NewActivity

public struct NewActivity: Identifiable {
    // MARK: Lifecycle

    public init(id: String, name: String, payload: Data) {
        self.id = id
        self.name = name
        self.payload = payload
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let payload: Data
}
