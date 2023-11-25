// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@MainActor
class Navigation: ObservableObject {

    static let shared = Navigation()

    enum Category: String, CaseIterable, Identifiable {
        case fruits = "Fruits"
        case animals = "Animals"
        case actions = "Actions"

        var id: String { self.rawValue }
    }

    @Published var categories = Category.allCases
    @Published var selectedCategory: Category? = .fruits

    @Published var path: NavigationPath = NavigationPath()

}
