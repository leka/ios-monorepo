// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public struct CategoryEducationalGames: CategoryProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.activities = try container.decode([String].self, forKey: .content)
            .compactMap {
                $0.split(separator: "-")
                    .last?
                    .trimmingCharacters(in: .whitespaces)
            }.compactMap {
                Activity(id: $0)
            }

        self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
    }

    // MARK: Public

    public static var shared: CategoryEducationalGames {
        let path = ContentKitResources.bundle.path(forResource: "educational_games", ofType: ".category.yml")
        let data = try? String(contentsOfFile: path!, encoding: .utf8)

        guard let data else {
            log.error("Error reading file")
            fatalError("💥 Error reading file")
        }

        let info = try! YAMLDecoder().decode(CategoryEducationalGames.self, from: data) // swiftlint:disable:this force_try

        return info
    }

    public var activities: [Activity]

    public var l10n: [Category.LocalizedDetails]

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case l10n
        case content
    }
}
