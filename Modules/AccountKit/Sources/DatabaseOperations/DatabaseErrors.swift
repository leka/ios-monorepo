// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum DatabaseError: Error {
    case customError(String)
    case documentNotFound
    case decodeError
    case encodeError
}
