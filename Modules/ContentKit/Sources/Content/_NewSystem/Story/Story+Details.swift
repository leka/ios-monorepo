// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

// MARK: Story.Details

public extension Story {
    struct Details: Decodable {
        // MARK: Public

        public let icon: String
        public let title: String
        public let subtitle: String?
        public let shortDescription: String
        public let description: String
        public let instructions: String

        public var iconImage: UIImage {
            UIImage(named: "\(self.icon).story.icon.png", in: .module, with: nil)
                ?? UIImage(named: "placeholder.activity.icon.png", in: .module, with: nil)!
        }

        // MARK: Private

        private enum CodingKeys: String, CodingKey {
            case icon
            case title
            case subtitle
            case shortDescription = "short_description"
            case description
            case instructions
        }
    }
}
