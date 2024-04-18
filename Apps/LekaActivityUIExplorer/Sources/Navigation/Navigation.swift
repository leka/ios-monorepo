// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Category

enum Category: Hashable, Identifiable, CaseIterable {
    case home

    case activities
    case experimentations

    case designSystemAppleFonts
    case designSystemAppleButtons
    case designSystemAppleColorsSwiftUI
    case designSystemAppleColorsUIKit

    case designSystemLekaButtons
    case designSystemLekaColorsSwiftUI

    // MARK: Internal

    var id: Self { self }
}

// MARK: - Navigation

class Navigation: ObservableObject {
    // MARK: Public

    public var selectedCategory: Category? = .home {
        willSet {
            self.disableUICompletly = true
            // ? Note: early return to avoid reseting path
            guard !self.isProgrammaticNavigation else { return }
            //            backupPath(for: selectedCategory)
        }
        didSet {
            //            restorePath(for: selectedCategory)
        }
    }

    // MARK: Internal

    static let shared = Navigation()

    @Published var disableUICompletly: Bool = false

    @Published var categories = Category.allCases

    @Published var path: NavigationPath = .init() {
        willSet {
            self.disableUICompletly = true
        }
        didSet {
            self.disableUICompletly = false
        }
    }

    // MARK: Private

    private var isProgrammaticNavigation: Bool = false

    private var pushPopNoAnimationTransaction: Transaction {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        return transaction
    }
}
