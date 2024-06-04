// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension Encodable {
    func encodeToString() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("Encoding error: \(error)")
            return ""
        }
    }
}
