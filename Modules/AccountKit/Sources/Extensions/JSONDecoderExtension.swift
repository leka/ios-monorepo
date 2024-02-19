// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_: T.Type, fromJSONObject object: Any) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object)
        return try self.decode(T.self, from: data)
    }
}
