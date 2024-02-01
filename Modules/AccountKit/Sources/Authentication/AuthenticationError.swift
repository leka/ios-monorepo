// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension AuthManager {
    enum AuthenticationError: Error {
        case custom(message: String)

        // MARK: Internal

        var localizedDescription: String {
            switch self {
                case let .custom(message):
                    message
            }
        }
    }
}
