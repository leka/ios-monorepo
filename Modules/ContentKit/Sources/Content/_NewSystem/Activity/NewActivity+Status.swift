// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: NewActivity.Status

public extension NewActivity {
    enum Status: String, Decodable {
        case draft
        case published
        case template
    }
}
