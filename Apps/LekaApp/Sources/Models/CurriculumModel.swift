// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - CurriculumList

struct CurriculumList: Codable {
    enum CodingKeys: String, CodingKey {
        case curriculums
        case sectionTitle = "section_title"
    }

    var sectionTitle: LocalizedContent
    var curriculums: [String]

    init(
        sectionTitle: LocalizedContent = LocalizedContent(),
        curriculums: [String] = []
    ) {
        self.sectionTitle = sectionTitle
        self.curriculums = curriculums
    }
}

// MARK: - Curriculum

struct Curriculum: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title, subtitle, activities
        case id = "uuid"
        case fullTitle = "full_title"
        case quantity = "number_of_activities"
    }

    var id: String
    var title: LocalizedContent
    var subtitle: LocalizedContent
    var fullTitle: LocalizedContent
    var quantity: Int
    var activities: [String]

    init(
        id: String = "",
        title: LocalizedContent = LocalizedContent(),
        subtitle: LocalizedContent = LocalizedContent(),
        fullTitle: LocalizedContent = LocalizedContent(),
        quantity: Int = 0,
        activities: [String] = []
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.fullTitle = fullTitle
        self.quantity = quantity
        self.activities = activities
    }
}
