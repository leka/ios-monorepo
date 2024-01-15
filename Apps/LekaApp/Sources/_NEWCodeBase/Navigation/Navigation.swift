// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class Navigation: ObservableObject {
    // MARK: Public

    public var selectedCategory: Category? = .news {
        willSet {
            self.disableUICompletly = true
            // ? Note: early return to avoid reseting path
            guard !self.isProgrammaticNavigation else { return }
            // TODO: (@ladislas) review this
            // backupPath(for: selectedCategory)
        }
        didSet {
            // TODO: (@ladislas) review this
            // restorePath(for: selectedCategory)
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
