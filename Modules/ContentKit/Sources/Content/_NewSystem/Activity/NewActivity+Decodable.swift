// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UtilsKit
import Yams

extension NewActivity: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case payload = "exercises_payload" // TODO: (@ladislas) - also add `payload` for future yaml
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

        let data = try container.decode(AnyCodable.self, forKey: .payload)

        self.payload = try JSONEncoder().encode(data)
    }

    public init?(yaml yamlString: String) {
        if let activity = try? YAMLDecoder().decode(NewActivity.self, from: yamlString) {
            self = activity
        } else {
            return nil
        }
    }
}
