// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum DatabaseError: Error {
    case customError(String)
    case documentNotFound
    case decodeError
    case encodeError
}
