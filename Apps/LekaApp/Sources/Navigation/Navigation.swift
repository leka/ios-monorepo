// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
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

@Observable
class Navigation {
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
                    .logEventScreenView(
                        screenName: "curriculum_details",
                        context: .splitView,
                        parameters: [
                            "lk_curriculum_id": "\(curriculum.name)-\(curriculum.id)",
                        ]
                    )
            case .activity:
                guard let activity = Activity(id: curation.id) else {
                    return Text("Activity \(curation.id) not found")
                }
                return ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                    .logEventScreenView(
                        screenName: "activity_details",
                        context: .splitView,
                        parameters: ["lk_activity_id": "\(activity.name)-\(activity.id)"]
                    )
            case .story:
                guard let story = Story(id: curation.id) else {
                    return Text("Story \(curation.id) not found")
                }
                return StoryDetailsView(story: story, onStartStory: self.onStartStory)
                    .logEventScreenView(
                        screenName: "story_details",
                        context: .splitView,
                        parameters: ["lk_story_id": "\(story.name)-\(story.id)"]
                    )
            case .curation:
                guard let curation = CategoryCuration(id: curation.id) else {
                    return Text("Curation \(curation.id) not found")
                }
                return CurationView(curation: curation)
                    .logEventScreenView(
                        screenName: "curation",
                        context: .splitView,
                        parameters: ["lk_curation_id": "\(curation.id)"]
                    )
        }
    }

    // MARK: Internal

    static let shared = Navigation()

    var demoMode: Bool = false
    // TODO: (@ladislas) No 'private(set)' because used as modal trigger
    var sheetContent: SheetContent?
    var fullScreenCoverContent: FullScreenCoverContent?
    var navigateToAccountCreationProcess: Bool = false

    private(set) var currentActivity: Activity?
    private(set) var currentStory: Story?

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

    var path: NavigationPath = .init() {
        willSet {
            self.disableUICompletly = true
        }
        didSet {
            self.disableUICompletly = false
        }
    }

    func setSheetContent(_ content: SheetContent?) {
        self.sheetContent = content
    }

    func setFullScreenCoverContent(_ content: FullScreenCoverContent?) {
        self.fullScreenCoverContent = content
    }

    func setCurrentActivity(_ activity: Activity?) {
        self.currentActivity = activity
    }

    func setCurrentStory(_ story: Story?) {
        self.currentStory = story
    }

    func setNavigateToAccountCreationProcess(_ value: Bool) {
        self.navigateToAccountCreationProcess = value
    }

    func setSelectedCategory(_ category: Category?) {
        self.selectedCategory = category
    }

    func setPath(_ path: NavigationPath) {
        self.path = path
    }

    // MARK: Private

    @ObservationIgnored private var authManager: AuthManager = .shared
    @ObservationIgnored private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    @ObservationIgnored private var isProgrammaticNavigation: Bool = false
    @ObservationIgnored private var disableUICompletly: Bool = false

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
