// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import UIKit

// MARK: Curriculum.Details

public extension Curriculum {
    struct Details: Decodable {
        // MARK: Public

        public let icon: String
        public let title: String
        public let subtitle: String?
        public let abstract: String
        public let description: String

        // TODO: (@ladislas) use string path instead
        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).curriculum.icon.png", in: .module, with: nil)
                ?? UIImage(named: "placeholder.curriculum.icon.png", in: .module, with: nil)!
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case icon
            case title
            case subtitle
            case abstract
            case description
        }
    }
}
