// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// Navigation Sets
enum SidebarDestinations: Int, Identifiable, CaseIterable {
    case curriculums, activities, commands

    var id: Self { self }
}

// Sidebar Sections // useless
enum NavSections: Int, Identifiable, CaseIterable {
    case educ

    var id: Self { self }
}

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
