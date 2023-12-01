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
            // ? Note: early return to avoid reseting path
            guard !isProgrammaticNavigation else { return }
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

    private var isProgrammaticNavigation: Bool = false

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

            case .activities:
                withTransaction(pushPopNoAnimationTransaction) {
                    activitiesNavPathBackup = path
                }

            case .curriculums:
                withTransaction(pushPopNoAnimationTransaction) {
                    curriculumsNavPathBackup = path
                }

            case .none:
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

            case .activities:
                withTransaction(pushPopNoAnimationTransaction) {
                    path = activitiesNavPathBackup
                }

            case .curriculums:
                withTransaction(pushPopNoAnimationTransaction) {
                    path = curriculumsNavPathBackup
                }

            case .none:
                break
        }
    }

    func set(path newPath: AnyHashable..., for newCategory: Category) {
        switch newCategory {
            case .home:
                break

            case .activities:
                activitiesNavPathBackup = newPath.compactMap { $0 as? Activity }
                    .reduce(into: NavigationPath()) { $0.append($1) }

            case .curriculums:
                var localPath = NavigationPath()
                newPath.forEach {
                    if let activity = $0 as? Activity {
                        localPath.append(activity)
                    } else if let curriculum = $0 as? Curriculum {
                        localPath.append(curriculum)
                    }
                }
                curriculumsNavPathBackup = localPath
        }

        underProgrammaticNavigation {
            select(category: newCategory)
        }
    }

    func set(curriculum: String, activity index: Int) {
        guard let curriculum = Curriculum.all.first(where: { $0.id == curriculum }) else { return }
        guard let activity = curriculum.activities[safe: index] else { return }

        var localPath = NavigationPath()

        localPath.append(curriculum)
        localPath.append(activity)

        curriculumsNavPathBackup = localPath

        underProgrammaticNavigation {
            select(category: .curriculums)
        }
    }

    func set(curriculum: String, activity id: String) {
        guard let curriculum = Curriculum.all.first(where: { $0.id == curriculum }) else { return }
        guard let activity = curriculum.activities.first(where: { $0.id == id }) else { return }

        var localPath = NavigationPath()

        localPath.append(curriculum)
        localPath.append(activity)

        curriculumsNavPathBackup = localPath

        underProgrammaticNavigation {
            select(category: .curriculums)
        }
    }

    private func underProgrammaticNavigation(_ callback: () -> Void) {
        isProgrammaticNavigation = true
        callback()
        isProgrammaticNavigation = false
    }

}
