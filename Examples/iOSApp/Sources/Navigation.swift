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

enum Destination: Hashable {
    case activity(id: String)
    case curriculum(id: String)
}

class Navigation: ObservableObject {

    static let shared = Navigation()

    @Published var categories = Category.allCases
    @Published var selectedCategory: Category? = .home {
        willSet {
            switch selectedCategory {
                case .home:
                    break
                case .activities:
                    activitiesNavPathBackup = activitiesNavPath
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) {
                        activitiesNavPath = NavigationPath()
                    }
                    print("backup activitiesNavPathBackup: \(activitiesNavPathBackup)")
                case .curriculums:
                    curriculumsNavPathBackup = curriculumsNavPath
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) {
                        curriculumsNavPath = NavigationPath()
                    }
                    print("backup curriculumsNavPathBackup: \(curriculumsNavPathBackup)")
                case nil:
                    break
            }
        }

        didSet {
            switch selectedCategory {
                case .home:
                    homeNavPath = NavigationPath()
                case .activities:
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) {
                        activitiesNavPath = activitiesNavPathBackup
                    }
                    print("restore activitiesNavPath: \(activitiesNavPath)")
                case .curriculums:
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) {
                        curriculumsNavPath = curriculumsNavPathBackup
                    }
                    print("restore curriculumsNavPath: \(curriculumsNavPath)")
                case nil:
                    break
            }
        }
    }

    @Published var homeNavPath: NavigationPath = NavigationPath()
//    @Published var activitiesNavPath: [Destination] = []
    @Published var activitiesNavPath: NavigationPath = NavigationPath()
    @Published var curriculumsNavPath: NavigationPath = NavigationPath()
//    @Published var curriculumsNavPath: [Destination] = []

//    var activitiesNavPathBackup: [Destination] = []
//    var curriculumsNavPathBackup: [Destination] = []

    var activitiesNavPathBackup: NavigationPath = NavigationPath()
    var curriculumsNavPathBackup: NavigationPath = NavigationPath()

    public func selectCategory(_ newCategory: Category) {
        guard selectedCategory != newCategory else { return }
        selectedCategory = newCategory
    }

}
