// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Category: Hashable, Identifiable, CaseIterable {

    case home

    case activities

    case designSystemAppleFonts
    case designSystemAppleButtons
    case designSystemAppleColorsSwiftUI
    case designSystemAppleColorsUIKit

    case designSystemLekaButtons
    case designSystemLekaColorsSwiftUI

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

    public var selectedCategory: Category? = .home {
        willSet {
            disableUICompletly = true
            // ? Note: early return to avoid reseting path
            guard !isProgrammaticNavigation else { return }
            //            backupPath(for: selectedCategory)
        }
        didSet {
            //            restorePath(for: selectedCategory)
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

}
