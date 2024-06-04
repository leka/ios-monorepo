// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension Decodable {
    static func decodeFromString(_ jsonString: String) throws -> Self? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        return try JSONDecoder().decode(Self.self, from: jsonData)
    }
}
