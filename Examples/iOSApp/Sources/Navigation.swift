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

    private var pushPopNoAnimationTransaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = true
        return t
    }

    @Published var categories = Category.allCases

    @Published var selectedCategory: Category? = .home {
        willSet {
            switch selectedCategory {
                case .home:
                    withTransaction(pushPopNoAnimationTransaction) {
                        homeNavPathBackup = homeNavPath
                        homeNavPath = NavigationPath()
                    }
                    print("backup homeNavPathBackup: \(homeNavPathBackup)")
                case .activities:
                    withTransaction(pushPopNoAnimationTransaction) {
                        activitiesNavPathBackup = activitiesNavPath
                        activitiesNavPath = NavigationPath()
                    }
                    print("backup activitiesNavPathBackup: \(activitiesNavPathBackup)")
                case .curriculums:
                    withTransaction(pushPopNoAnimationTransaction) {
                        curriculumsNavPathBackup = curriculumsNavPath
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
                    withTransaction(pushPopNoAnimationTransaction) {
                        homeNavPath = homeNavPathBackup
                    }
                    print("restore homeNavPath: \(homeNavPath)")
                case .activities:
                    withTransaction(pushPopNoAnimationTransaction) {
                        activitiesNavPath = activitiesNavPathBackup
                    }
                    print("restore activitiesNavPath: \(activitiesNavPath)")
                case .curriculums:
                    withTransaction(pushPopNoAnimationTransaction) {
                        curriculumsNavPath = curriculumsNavPathBackup
                    }
                    print("restore curriculumsNavPath: \(curriculumsNavPath)")
                case .none:
                    break
            }
        }
    }

    @Published var homeNavPath: NavigationPath = NavigationPath()
    @Published var activitiesNavPath: NavigationPath = NavigationPath()
    @Published var curriculumsNavPath: NavigationPath = NavigationPath()

    private var homeNavPathBackup: NavigationPath = NavigationPath()
    private var activitiesNavPathBackup: NavigationPath = NavigationPath()
    private var curriculumsNavPathBackup: NavigationPath = NavigationPath()

    public func select(category newCategory: Category) {
        guard selectedCategory != newCategory else { return }
        selectedCategory = newCategory
    }

}
