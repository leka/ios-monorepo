// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

enum Category: CaseIterable, Identifiable {
    case home
    case activities
    case curriculums

    var id: Self { self }
}


class Navigation: ObservableObject {

    static let shared = Navigation()

    @Published var categories = Category.allCases
    @Published var selectedCategory: Category? = .home

    @Published var homeNavPath: NavigationPath = NavigationPath()
    @Published var activitiesNavPath: NavigationPath = NavigationPath()
    @Published var curriculumsNavPath: NavigationPath = NavigationPath()

    public func selectCategory(_ newCategory: Category) {
        guard selectedCategory != newCategory else { return }
        selectedCategory = newCategory
    }

}
