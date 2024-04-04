// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import Yams

public struct CategoryActivities: CategoryProtocol {
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

    public static var shared: CategoryActivities {
        let path = ContentKitResources.bundle.path(forResource: "activities", ofType: ".category.yml")
        let data = try? String(contentsOfFile: path!, encoding: .utf8)

        guard let data else {
            log.error("Error reading file")
            fatalError("💥 Error reading file")
        }

        let info = try! YAMLDecoder().decode(CategoryActivities.self, from: data) // swiftlint:disable:this force_try

        return info
    }

    public var activities: [Activity]

    public var details: Category.Details {
        self.details(in: LocalizationKit.l10n.language)
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case l10n
        case content
    }

    private let l10n: [Category.LocalizedDetails]

    private func details(in language: Locale.LanguageCode) -> Category.Details {
        guard let details = self.l10n.first(where: { $0.language == language })?.details else {
            log.error("No details found for language \(language)")
            fatalError("💥 No details found for language \(language)")
        }

        return details
    }
}
