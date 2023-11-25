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
        var t = Transaction(animation: nil)
        t.disablesAnimations = true
        return t
    }

    @Published var disableUICompletly: Bool = false

    @Published var categories = Category.allCases

    var selectedCategory: Category? = .home {
        willSet {
            disableUICompletly = true
            backupPath(for: selectedCategory)
        }
        didSet {
            restorePath(for: selectedCategory)
        }
    }

    @Published var path: NavigationPath = NavigationPath() {
        willSet {
            disableUICompletly = true
        }
        didSet {
            self.disableUICompletly = false
        }
    }

    private var homeNavPathBackup: NavigationPath = NavigationPath()
    private var activitiesNavPathBackup: NavigationPath = NavigationPath()
    private var curriculumsNavPathBackup: NavigationPath = NavigationPath()

    public func select(category newCategory: Category) {
        guard selectedCategory != newCategory else { return }
        selectedCategory = newCategory
    }

    private func backupPath(for category: Category?) {
        switch category {
            case .home:
                withTransaction(pushPopNoAnimationTransaction) {
                    homeNavPathBackup = path
                }
                print("backup homeNavPathBackup: \(homeNavPathBackup)")

            case .activities:
                withTransaction(pushPopNoAnimationTransaction) {
                    activitiesNavPathBackup = path
                }
                print("backup activitiesNavPathBackup: \(activitiesNavPathBackup)")

            case .curriculums:
                withTransaction(pushPopNoAnimationTransaction) {
                    curriculumsNavPathBackup = path
                }
                print("backup curriculumsNavPathBackup: \(curriculumsNavPathBackup)")

            case .none:
                print("category is nil, early return to avoid reseting path")
                return  // ? Note: early return to avoid reseting path
        }

        withTransaction(pushPopNoAnimationTransaction) {
            path = NavigationPath()
        }
    }

    private func restorePath(for category: Category?) {
        switch category {
            case .home:
                withTransaction(pushPopNoAnimationTransaction) {
                    path = homeNavPathBackup
                }
                print("restore homeNavPath: \(path)")

            case .activities:
                withTransaction(pushPopNoAnimationTransaction) {
                    path = activitiesNavPathBackup
                }
                print("restore activitiesNavPath: \(path)")

            case .curriculums:
                withTransaction(pushPopNoAnimationTransaction) {
                    path = curriculumsNavPathBackup
                }
                print("restore curriculumsNavPath: \(path)")

            case .none:
                print("category is nil, no retore")
        }
    }

}
