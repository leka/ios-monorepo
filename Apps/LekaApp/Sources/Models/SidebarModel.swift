// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// Navigation Sets
enum SidebarDestinations: Int, Identifiable, CaseIterable, Hashable {
    case curriculums, activities, commands

    var id: Self { self }
}

enum PathsToGame: Hashable {
    case robot, user, game
}

// Sidebar Sections - useless while only 1 section
// enum NavSections: Int, Identifiable, CaseIterable {
//     case educ
//
//     var id: Self { self }
// }

// Sidebar UI Models
struct SectionLabel: Identifiable, Hashable {
    let id = UUID()
    let destination: SidebarDestinations
    let icon: String
    let label: String
}

struct ListModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let sections: [SectionLabel]
}
