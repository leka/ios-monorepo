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

    // MARK: Public

    public func onStartActivity(_ activity: Activity) {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.demoMode {
            self.sheetContent = .carereceiverPicker(activity: activity, story: nil)
        } else {
            self.currentActivity = activity
            self.fullScreenCoverContent = .activityView(carereceivers: [])
        }
    }

    public func onStartStory(_ story: Story) {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.demoMode {
            self.sheetContent = .carereceiverPicker(activity: nil, story: story)
        } else {
            self.currentStory = story
            self.fullScreenCoverContent = .storyView(carereceivers: [])
        }
    }

    public func curationDestination(_ curation: CurationItemModel) -> any View {
        switch curation.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: curation.id) else {
                    return Text("Curriculum \(curation.id) not found")
                }
                return CurriculumDetailsView(curriculum: curriculum, onStartActivity: self.onStartActivity)
            case .activity:
                guard let activity = Activity(id: curation.id) else {
                    return Text("Activity \(curation.id) not found")
                }
                return ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
            case .story:
                guard let story = Story(id: curation.id) else {
                    return Text("Story \(curation.id) not found")
                }
                return StoryDetailsView(story: story, onStartStory: self.onStartStory)
            case .curation:
                guard let curation = CategoryCuration(id: curation.id) else {
                    return Text("Curation \(curation.id) not found")
                }
                return CurationView(curation: curation)
        }
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
    private var authManagerViewModel: AuthManagerViewModel = .shared
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
