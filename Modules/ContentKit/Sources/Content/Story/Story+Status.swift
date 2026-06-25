// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

// MARK: Story.Status

public extension Story {
    enum Status: String, Decodable {
        case draft
        case published
    }
}
