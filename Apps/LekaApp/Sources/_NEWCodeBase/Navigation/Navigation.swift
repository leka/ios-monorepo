// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import SwiftUI

class Navigation: ObservableObject {
    // MARK: Lifecycle

    private init() {
        self.subscribeAuthentificationStateUpdates()
    }

    // MARK: Internal

    static let shared = Navigation()

    @Published var disableUICompletly: Bool = false
    @Published var categories = Category.allCases

    @Published var isCarereceiverPickerPresented: Bool = false

    @Published var currentActivity: Activity?

    var selectedCategory: Category? = .news {
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

    @Published var path: NavigationPath = .init() {
        willSet {
            self.disableUICompletly = true
        }
        didSet {
            self.disableUICompletly = false
        }
    }

    // MARK: Private

    private var authManager: AuthManager = .shared
    private var cancellables: Set<AnyCancellable> = []

    private var isProgrammaticNavigation: Bool = false

    private var pushPopNoAnimationTransaction: Transaction {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        return transaction
    }

    private func subscribeAuthentificationStateUpdates() {
        self.authManager.authenticationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink {
                if $0 != .loggedIn {
                    self.selectedCategory = .news
                }
            }
            .store(in: &self.cancellables)
    }
}
