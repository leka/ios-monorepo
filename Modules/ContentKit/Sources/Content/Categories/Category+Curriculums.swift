// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import Yams

// MARK: - CategoryCurriculums

public struct CategoryCurriculums: CategoryProtocol {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
        self.sections = try container.decode([CategoryCurriculums.Section].self, forKey: .content)
    }

    // MARK: Public

    public static var shared: CategoryCurriculums {
        let path = ContentKitResources.bundle.path(forResource: "curriculums", ofType: ".category.yml")
        let data = try? String(contentsOfFile: path!, encoding: .utf8)

        guard let data else {
            logCK.error("Error reading file")
            fatalError("💥 Error reading file")
        }

        let info = try! YAMLDecoder().decode(CategoryCurriculums.self, from: data) // swiftlint:disable:this force_try

        return info
    }

    public var l10n: [Category.LocalizedDetails]

    public var sections: [CategoryCurriculums.Section]

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case l10n
        case content
    }
}

// MARK: CategoryCurriculums.Section

public extension CategoryCurriculums {
    struct Section: Decodable, Identifiable {
        // MARK: Lifecycle

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.l10n = try container.decode([Category.LocalizedDetails].self, forKey: .l10n)
            self.curriculums = try container.decode([String].self, forKey: .curriculums).compactMap {
                $0.split(separator: "-")
                    .last?
                    .trimmingCharacters(in: .whitespaces)
            }.compactMap {
                Curriculum(id: $0)
            }
        }

        // MARK: Public

        public enum CodingKeys: CodingKey {
            case id
            case l10n
            case curriculums
        }

        public let id: String

        public let curriculums: [Curriculum]

        public var details: Category.Details {
            self.details(in: LocalizationKit.l10n.language)
        }

        // MARK: Internal

        let l10n: [Category.LocalizedDetails]

        // MARK: Private

        private func details(in language: Locale.LanguageCode) -> Category.Details {
            guard let details = self.l10n.first(where: { $0.language == language })?.details else {
                logCK.error("No details found for language \(language)")
                fatalError("💥 No details found for language \(language)")
            }

            return details
        }
    }
}
