// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import DesignKit
import GameEngineKit
import LocalizationKit
import RobotKit
import SwiftUI

extension Bundle {
    static var version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    static var buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
}

// MARK: - MainView

struct MainView: View {
    // MARK: Internal

    @State var isResourcesCollapsed: Bool = true
    @ObservedObject var navigation: Navigation = .shared
    @ObservedObject var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject var viewModel: ViewModel = .init()

    var body: some View {
        NavigationSplitView {
            ScrollViewReader { scrollViewProxy in
                List(selection: self.$navigation.selectedCategory) {
                    Group {
                        if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                            EditCaregiverLabel()
                        } else {
                            NoAccountConnectedLabel()
                        }
                    }
                    .id("caregiverLabel")
                    .onReceive(self.authManagerViewModel.$userAuthenticationState) { state in
                        if state == .loggedOut {
                            withAnimation {
                                scrollViewProxy.scrollTo("caregiverLabel", anchor: .top)
                            }
                        }
                    }

                    Button {
                        self.navigation.sheetContent = .robotConnection
                    } label: {
                        RobotConnectionLabel()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

                    Section(String(l10n.MainView.Sidebar.sectionInformation.characters)) {
                        CategoryLabel(category: .home)
                        CategoryLabel(category: .search)
                    }

                    Section(String(l10n.MainView.Sidebar.sectionContent.characters)) {
                        CategoryLabel(category: .curriculums)
                        CategoryLabel(category: .educationalGames)
                        CategoryLabel(category: .stories)
                        CategoryLabel(category: .gamepads)
                    }

                    #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                        Section(String(l10n.MainView.Sidebar.sectionLibrary.characters)) {
                            CategoryLabel(category: .libraryCurriculums)
                            CategoryLabel(category: .libraryActivities)
                            CategoryLabel(category: .libraryStories)
                        }
                    #endif

                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        Section(String(l10n.MainView.Sidebar.sectionUsers.characters)) {
                            CategoryLabel(category: .caregivers)
                            CategoryLabel(category: .carereceivers)
                        }
                    }

                    Section(String(l10n.MainView.Sidebar.sectionResources.characters)) {
                        CategoryLabel(category: .resourcesFirstSteps)
                        CategoryLabel(category: .resourcesVideo)
                        CategoryLabel(category: .resourcesDeepDive)
                    }

                    #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                        if !self.navigation.demoMode {
                            Section("Developer Mode") {
                                CategoryLabel(category: .allTemplateActivities)
                                CategoryLabel(category: .allDraftActivities)
                                CategoryLabel(category: .allPublishedActivities)
                                CategoryLabel(category: .rasterImageList)
                                CategoryLabel(category: .vectorImageList)
                                CategoryLabel(category: .news)
                            }
                        } else {
                            Section("Demo mode") {
                                CategoryLabel(category: .demo)
                            }
                        }
                    #endif

                    VStack(alignment: .center, spacing: 20) {
                        Button {
                            self.navigation.sheetContent = .settings
                        } label: {
                            SettingsLabel()
                        }

                        LekaAppAsset.Assets.lekaLogoStripes.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .frame(maxWidth: .infinity)
                }
                .listStyle(.sidebar)
            }
            // TODO: (@ladislas) remove if not necessary
            // .disabled(navigation.disableUICompletly)
        } detail: {
            NavigationStack(path: self.$navigation.path) {
                switch self.navigation.selectedCategory {
                    case .home:
                        CategoryHome()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_home")
                            }

                    case .search:
                        CategorySearchView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_search")
                            }

                    case .resourcesFirstSteps:
                        CategoryResourcesFirstStepsView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_resources_first_steps")
                            }

                    case .resourcesVideo:
                        CategoryResourcesVideosView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_resources_video")
                            }

                    case .resourcesDeepDive:
                        CategoryResourcesDeepDiveView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_resources_deep_dive")
                            }

                    case .curriculums:
                        CategoryCurriculumsView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_catergory_curriculums")
                            }

                    case .educationalGames:
                        CategoryEducationalGamesView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_educational_games")
                            }

                    case .stories:
                        CategoryStoriesView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_stories")
                            }

                    case .gamepads:
                        CategoryGamepadsView()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_gamepads")
                            }

                    case .caregivers:
                        CaregiverList()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_caregivers")
                            }

                    case .carereceivers:
                        CarereceiverList()
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_carereceivers")
                            }

                    // ? DEVELOPER_MODE + TESTFLIGHT_BUILD
                    case .allPublishedActivities:
                        AllPublishedActivitiesView()

                    case .allDraftActivities:
                        AllDraftActivitiesView()

                    case .allTemplateActivities:
                        AllTemplateActivitiesView()

                    case .rasterImageList:
                        DebugImageListView(images: ContentKit.listRasterImages())
                            .navigationTitle("Raster Image List (.png, .jpg, .jpeg)")

                    case .vectorImageList:
                        DebugImageListView(images: ContentKit.listVectorImages())
                            .navigationTitle("Vector Image List (.svg)")

                    case .news:
                        NewsView()

                    case .demo:
                        DiscoverLekaView(demoMode: self.navigation.demoMode)

                    case .libraryCurriculums:
                        CategoryLibraryView(category: .libraryCurriculums)
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_library_curriculums")
                            }

                    case .libraryActivities:
                        CategoryLibraryView(category: .libraryActivities)
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_library_activities")
                            }

                    case .libraryStories:
                        CategoryLibraryView(category: .libraryStories)
                            .onAppear {
                                AnalyticsManager.shared.logScreenView(screenName: "view_category_library_stories")
                            }

                    case .none:
                        Text(l10n.MainView.Sidebar.CategoryLabel.home)
                            .font(.largeTitle)
                            .bold()
                }
            }
        }
        .fullScreenCover(item: self.$navigation.fullScreenCoverContent) {
            self.navigation.fullScreenCoverContent = nil
            self.navigation.currentActivity = nil
            self.navigation.currentStory = nil
        } content: { content in
            NavigationStack {
                switch content {
                    case .welcomeView:
                        WelcomeView()
                    case let .activityView(carereceivers):
                        ActivityView(activity: self.navigation.currentActivity!, reinforcer: carereceivers.first?.reinforcer ?? .rainbow)
                    case let .storyView(carereceivers):
                        StoryView(story: self.navigation.currentStory!)
                }
            }
        }
        .sheet(item: self.$navigation.sheetContent) {
            self.navigation.sheetContent = nil
        } content: { content in
            NavigationStack {
                switch content {
                    case .robotConnection:
                        RobotConnectionView(viewModel: RobotConnectionViewModel())
                            .navigationBarTitleDisplayMode(.inline)
                    case .settings:
                        SettingsView()
                            .navigationBarTitleDisplayMode(.inline)
                    case .editCaregiver:
                        EditCaregiverView(caregiver: self.caregiverManagerViewModel.currentCaregiver!)
                            .navigationBarTitleDisplayMode(.inline)
                    case .createCaregiver:
                        CreateCaregiverView()
                            .navigationBarTitleDisplayMode(.inline)
                    case .caregiverPicker:
                        CaregiverPicker()
                            .navigationBarTitleDisplayMode(.inline)
                    case let .carereceiverPicker(activity, story):
                        CarereceiverPicker(onDismiss: {
                            // nothing to do
                        }, onSelected: { carereceivers in
                            self.carereceiverManager.setCurrentCarereceivers(to: carereceivers)
                            self.navigation.currentActivity = activity
                            self.navigation.currentStory = story
                            if let activity = self.navigation.currentActivity {
                                self.navigation.fullScreenCoverContent = .activityView(carereceivers: carereceivers)
                            } else if let story = self.navigation.currentStory {
                                self.navigation.fullScreenCoverContent = .storyView(carereceivers: carereceivers)
                            }

                        }, onSkip: {
                            self.navigation.currentActivity = activity
                            self.navigation.currentStory = story
                            if let activity = self.navigation.currentActivity {
                                self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                            } else if let story = self.navigation.currentStory {
                                self.navigation.fullScreenCoverContent = .storyView(carereceivers: [])
                            }
                        })
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .onAppear {
            guard self.authManagerViewModel.userAuthenticationState == .loggedIn else {
                return
            }
            self.persistentDataManager.checkInactivity()
        }
        .onChange(of: self.scenePhase) { newPhase in
            guard self.authManagerViewModel.userAuthenticationState == .loggedIn else {
                return
            }
            switch newPhase {
                case .active:
                    self.persistentDataManager.checkInactivity()
                case .inactive,
                     .background:
                    self.persistentDataManager.updateLastActiveTimestamp()
                    if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                        self.persistentDataManager.lastActiveCaregiverID = currentCaregiverID
                    }
                @unknown default:
                    break
            }
        }
        .onReceive(self.caregiverManagerViewModel.$caregivers, perform: { _ in
            if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                self.persistentDataManager.checkInactivity()
            }
        })
        .onReceive(self.persistentDataManager.inactivityTimeoutPublisher) { isTimedOut in
            if isTimedOut {
                self.caregiverManager.resetCurrentCaregiver()
                guard self.navigation.sheetContent == nil, self.navigation.fullScreenCoverContent == nil else {
                    return
                }
                self.navigation.sheetContent = .caregiverPicker
            } else {
                guard let storedCaregiverID = self.persistentDataManager.lastActiveCaregiverID else {
                    self.navigation.sheetContent = .caregiverPicker
                    return
                }
                self.caregiverManager.setCurrentCaregiver(byID: storedCaregiverID)
            }
        }
        .onChange(of: self.caregiverManagerViewModel.currentCaregiver) { currentCaregiver in
            self.persistentDataManager.lastActiveCaregiverID = currentCaregiver?.id
            self.persistentDataManager.updateLastActiveTimestamp()
            if currentCaregiver != nil {
                self.styleManager.colorScheme = self.caregiverManagerViewModel.currentCaregiver!.colorScheme
                self.styleManager.accentColor = self.caregiverManagerViewModel.currentCaregiver!.colorTheme.color
            }
        }
    }

    // MARK: Private

    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()

    private var persistentDataManager: PersistentDataManager = .shared
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared
}

#Preview {
    MainView()
}
