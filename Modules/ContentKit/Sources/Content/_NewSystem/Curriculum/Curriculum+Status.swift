// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: Curriculum.Status

public extension Curriculum {
    enum Status: String, Decodable {
        case draft
        case published
        case template
    }
}
