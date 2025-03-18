// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - SuperSimonModel

public struct SuperSimonModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.level = try container.decode(SuperSimon.Level.self, forKey: .level)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(SuperSimonModel.self, from: data)
        else {
            log.error("Exercise payload not compatible with SuperSimon model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case level
    }

    let level: SuperSimon.Level
}
