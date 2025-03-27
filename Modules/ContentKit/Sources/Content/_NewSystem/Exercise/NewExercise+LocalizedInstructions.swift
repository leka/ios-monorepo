// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension NewExercise {
    struct LocalizedInstructions: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.value = try container.decode(String.self, forKey: .value)
        }

        // MARK: Internal

        let locale: Locale
        let value: String
    }
}
