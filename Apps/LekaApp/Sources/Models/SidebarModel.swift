// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - SidebarDestinations

// Navigation Sets
enum SidebarDestinations: Int, Identifiable, CaseIterable, Hashable {
    case curriculums
    case activities
    case commands

    // MARK: Internal

    var id: Self { self }
}

// MARK: - PathsToGame

enum PathsToGame: Hashable {
    case robot
    case user
    case game
}

// MARK: - SectionLabel

// Sidebar UI Models
struct SectionLabel: Identifiable, Hashable {
    let id = UUID()
    let destination: SidebarDestinations
    let icon: String
    let label: String
}

// MARK: - ListModel

struct ListModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let sections: [SectionLabel]
}
