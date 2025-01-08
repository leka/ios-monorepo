// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import SwiftUI

// MARK: - FullScreenCoverContent

enum FullScreenCoverContent: Hashable, Identifiable {
    case welcomeView
    case activityView(carereceivers: [Carereceiver] = [])
    case storyView(carereceivers: [Carereceiver] = [])

    // MARK: Internal

    var id: Self { self }
}

// MARK: - SheetContent

enum SheetContent: Hashable, Identifiable {
    case robotConnection
    case consent
    case createCaregiver
    case editCaregiver
    case caregiverPicker
    case carereceiverPicker(activity: Activity?, story: Story?)
    case settings

    // MARK: Internal

    var id: Self { self }
}

// MARK: - Navigation

class Navigation: ObservableObject {
    // MARK: Lifecycle

    private init() {
        self.subscribeAuthentificationStateUpdates()
    }

    // MARK: Internal

    static let shared = Navigation()

    @Published var disableUICompletly: Bool = false
    @Published var demoMode: Bool = false
    @Published var categories = Category.allCases

    @Published var sheetContent: SheetContent?
    @Published var fullScreenCoverContent: FullScreenCoverContent?

    @Published var currentActivity: Activity?
    @Published var currentStory: Story?

    @Published var navigateToAccountCreationProcess: Bool = false

    var selectedCategory: Category? = .home {
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
                if case $0 = AuthManager.AuthenticationState.loggedOut {
                    self.selectedCategory = .home
                    if self.sheetContent == nil, self.fullScreenCoverContent == nil {
                        self.fullScreenCoverContent = .welcomeView
                    }
                }
            }
            .store(in: &self.cancellables)
    }
}
