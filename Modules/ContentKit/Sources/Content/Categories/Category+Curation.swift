// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI
import UtilsKit
import Yams

// MARK: - CurationItemModel

// swiftlint:disable nesting

public struct CurationItemModel: Identifiable, Hashable, Equatable {
    // MARK: Lifecycle

    public init(id: String, contentType: ContentType) {
        self.id = id
        self.contentType = contentType
    }

    // MARK: Public

    public let id: String
    public var contentType: ContentType = .curation
}

// MARK: - CategoryCuration

public struct CategoryCuration: Identifiable, CategoryProtocol {
    // MARK: Lifecycle

    public init?(id: String) {
        if let curation = ContentKit.allCurations[id] {
            self = curation
        } else {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.icon = try container.decode(String.self, forKey: .icon)
        let hexColor = try container.decode(UInt.self, forKey: .color)
        self.color = Color(hex: hexColor)
        self.l10n = try container.decode([ContentCategory.LocalizedDetails].self, forKey: .l10n)
        self.sections = try container.decode([CategoryCuration.Section].self, forKey: .content)
    }

    // MARK: Public

    public let uuid: String
    public var icon: String
    public var color: Color
    public var l10n: [ContentCategory.LocalizedDetails]
    public var sections: [CategoryCuration.Section]
    public var contentType: ContentType = .curation

    public var id: String { self.uuid }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case uuid
        case icon
        case color
        case l10n
        case content
    }
}

// MARK: CategoryCuration.Section

public extension CategoryCuration {
    struct Section: Identifiable, Decodable {
        // MARK: Lifecycle

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.componentType = try container.decode(ComponentType.self, forKey: .component)
            self.l10n = try container.decode([ContentCategory.LocalizedDetails].self, forKey: .l10n)
            self.items = try container.decode([ContentCategory.CurationPayload].self, forKey: .items)
        }

        // MARK: Public

        public enum CodingKeys: CodingKey {
            case component
            case l10n
            case items
        }

        public enum ComponentType: String, Codable {
            case carousel
            case horizontalCurriculumGrid = "horizontal_curriculum_grid"
            case horizontalActivityGrid = "horizontal_activity_grid"
            case horizontalCurriculumList = "horizontal_curriculum_list"
            case horizontalActivityList = "horizontal_activity_list"
            case horizontalCurationList = "horizontal_curation_list"
            case verticalCurriculumGrid = "vertical_curriculum_grid"
            case verticalActivityGrid = "vertical_activity_grid"
            case verticalCurationGrid = "vertical_curation_grid"
        }

        public let id = UUID()
        public let componentType: ComponentType
        public let items: [ContentCategory.CurationPayload]

        public var details: ContentCategory.Details {
            self.details(in: LocalizationKit.l10n.language)
        }

        // MARK: Internal

        let l10n: [ContentCategory.LocalizedDetails]

        // MARK: Private

        private func details(in language: Locale.LanguageCode) -> ContentCategory.Details {
            guard let details = self.l10n.first(where: { $0.language == language })?.details else {
                logCK.error("No details found for language \(language)")
                fatalError("💥 No details found for language \(language)")
            }

            return details
        }
    }
}

// MARK: - ContentCategory.CurationPayload

public extension ContentCategory {
    struct CurationPayload: Codable, Identifiable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.value = try container.decode(String.self, forKey: .value)
                .split(separator: "-")
                .last!
                .trimmingCharacters(in: .whitespaces)

            let typeString = try container.decode(String.self, forKey: .type)
            self.type = ContentType(rawValue: typeString) ?? .activity
            self.curation = CurationItemModel(id: self.value, contentType: self.type)
        }

        // MARK: Public

        public let id = UUID()
        public var value: String
        public let type: ContentType
        public var curation: CurationItemModel

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case value
            case type
        }
    }
}

// MARK: - ContentCategory.CurationPayload + Equatable, Hashable

extension ContentCategory.CurationPayload: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// swiftlint:enable nesting
