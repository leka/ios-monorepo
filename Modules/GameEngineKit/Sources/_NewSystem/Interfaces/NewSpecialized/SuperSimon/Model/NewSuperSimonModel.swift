// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - NewSuperSimonModel

public struct NewSuperSimonModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.level = try container.decode(SuperSimonLevel.self, forKey: .level)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(NewSuperSimonModel.self, from: data)
        else {
            logGEK.error("Exercise payload not compatible with SuperSimon model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case level
    }

    let level: SuperSimonLevel
}

// MARK: - SuperSimonLevel

public enum SuperSimonLevel: String, Equatable, Codable {
    case easy
    case medium
    case hard
}
