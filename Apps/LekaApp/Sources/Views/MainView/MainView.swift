// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import Combine
import ContentKit
import DesignKit
import GameEngineKit
import LocalizationKit
import RobotKit
import SwiftUI

// swiftlint:disable type_body_length file_length

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
                            CategoryLabel(category: .libraryFavorites)
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
            .alert(isPresented: self.$showingAppUpdateAlert) {
                Alert(
                    title: Text(l10n.MainView.AppUpdateAlert.title),
                    message: Text(l10n.MainView.AppUpdateAlert.message),
                    primaryButton: .default(Text(l10n.MainView.AppUpdateAlert.action), action: {
                        AnalyticsManager.logEventAppUpdateAlertResponse(.openAppStore)
                        if let url = URL(string: "https://apps.apple.com/app/leka/id6446940339") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    secondaryButton: .cancel(Text(l10n.MainView.AppUpdateAlert.reminder)) {
                        AnalyticsManager.logEventAppUpdateAlertResponse(.remindLater)
                    }
                )
            }
            .alert(isPresented: self.$showingOSUpdateAlert) {
                Alert(
                    title: Text(l10n.MainView.OSUpdateAlert.title),
                    message: Text(l10n.MainView.OSUpdateAlert.message),
                    primaryButton: .default(Text(l10n.MainView.OSUpdateAlert.action), action: {
                        AnalyticsManager.logEventOSUpdateAlertResponse(.openSettings)
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }),
                    secondaryButton: .cancel(Text(l10n.MainView.OSUpdateAlert.reminder)) {
                        AnalyticsManager.logEventOSUpdateAlertResponse(.remindLater)
                    }
                )
            }
            .alert(isPresented: self.$libraryManagerViewModel.showRemoveAlert) {
                self.createRemovalAlert()
            }
        } detail: {
            NavigationStack(path: self.$navigation.path) {
                switch self.navigation.selectedCategory {
                    case .home:
                        CategoryHome()
                            .logEventScreenView(screenName: "home", context: .splitView)

                    case .search:
                        CategorySearchView()
                            .logEventScreenView(screenName: "search", context: .splitView)

                    case .resourcesFirstSteps:
                        CategoryResourcesFirstStepsView()
                            .logEventScreenView(screenName: "resources_first_steps", context: .splitView)

                    case .resourcesVideo:
                        CategoryResourcesVideosView()
                            .logEventScreenView(screenName: "resources_video", context: .splitView)

                    case .resourcesDeepDive:
                        CategoryResourcesDeepDiveView()
                            .logEventScreenView(screenName: "resources_deep_dive", context: .splitView)

                    case .curriculums:
                        CategoryCurriculumsView()
                            .logEventScreenView(screenName: "curriculums", context: .splitView)

                    case .educationalGames:
                        CategoryEducationalGamesView()
                            .logEventScreenView(screenName: "educational_games", context: .splitView)

                    case .stories:
                        CategoryStoriesView()
                            .logEventScreenView(screenName: "stories", context: .splitView)

                    case .gamepads:
                        CategoryGamepadsView()
                            .logEventScreenView(screenName: "gamepads", context: .splitView)

                    case .caregivers:
                        CaregiverList()
                            .logEventScreenView(screenName: "caregivers", context: .splitView)

                    case .carereceivers:
                        CarereceiverList()
                            .logEventScreenView(screenName: "carereceivers", context: .splitView)

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
                            .logEventScreenView(screenName: "library_curriculums", context: .splitView)

                    case .libraryActivities:
                        CategoryLibraryView(category: .libraryActivities)
                            .logEventScreenView(screenName: "library_activities", context: .splitView)

                    case .libraryStories:
                        CategoryLibraryView(category: .libraryStories)
                            .logEventScreenView(screenName: "library_stories", context: .splitView)

                    case .libraryFavorites:
                        CategoryLibraryView(category: .libraryFavorites)
                            .logEventScreenView(screenName: "library_favorites", context: .splitView)

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
            switch content {
                case .welcomeView:
                    NavigationStack {
                        WelcomeView()
                            .logEventScreenView(screenName: "welcome", context: .fullScreenCover)
                    }

                case let .activityView(carereceivers):
                    NavigationStack {
                        ActivityView(activity: self.navigation.currentActivity!, reinforcer: carereceivers.first?.reinforcer ?? .rainbow)
                            .logEventScreenView(screenName: "activity", context: .fullScreenCover)
                    }

                case .storyView:
                    StoryView(story: self.navigation.currentStory!)
                        .logEventScreenView(screenName: "story", context: .fullScreenCover)
            }
        }
        .sheet(item: self.$navigation.sheetContent) {
            self.navigation.sheetContent = nil
        } content: { content in
            NavigationStack {
                switch content {
                    case .robotConnection:
                        RobotConnectionView(viewModel: RobotConnectionViewModel())
                            .logEventScreenView(screenName: "robot_connection", context: .sheet)
                            .navigationBarTitleDisplayMode(.inline)

                    case .settings:
                        SettingsView()
                            .logEventScreenView(screenName: "settings", context: .sheet)
                            .navigationBarTitleDisplayMode(.inline)

                    case .editCaregiver:
                        EditCaregiverView(caregiver: self.caregiverManagerViewModel.currentCaregiver!)
                            .logEventScreenView(screenName: "caregiver_edit", context: .sheet)
                            .navigationBarTitleDisplayMode(.inline)

                    case .createCaregiver:
                        CreateCaregiverView()
                            .logEventScreenView(screenName: "caregiver_create", context: .sheet)
                            .navigationBarTitleDisplayMode(.inline)

                    case .caregiverPicker:
                        CaregiverPicker()
                            .logEventScreenView(screenName: "caregiver_picker", context: .sheet)
                            .navigationBarTitleDisplayMode(.inline)
                            .onDisappear {
                                if !self.updateAlertHasBeenShown {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        if case .appUpdateAvailable = UpdateManager.shared.appUpdateStatus {
                                            self.showingAppUpdateAlert = true
                                            self.updateAlertHasBeenShown = true
                                        } else if case .osUpdateAvailable = UpdateManager.shared.osUpdateStatus {
                                            self.showingOSUpdateAlert = true
                                            self.updateAlertHasBeenShown = true
                                        }
                                    }
                                }
                            }
                    case let .carereceiverPicker(activity, story):
                        CarereceiverPicker(onDismiss: {
                            // nothing to do
                        }, onSelected: { carereceivers in
                            self.carereceiverManager.setCurrentCarereceivers(to: carereceivers)
                            self.navigation.currentActivity = activity
                            self.navigation.currentStory = story
                            if self.navigation.currentActivity != nil {
                                self.navigation.fullScreenCoverContent = .activityView(carereceivers: carereceivers)
                            } else if self.navigation.currentStory != nil {
                                self.navigation.fullScreenCoverContent = .storyView(carereceivers: carereceivers)
                            }

                        }, onSkip: {
                            self.navigation.currentActivity = activity
                            self.navigation.currentStory = story
                            if self.navigation.currentActivity != nil {
                                self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                            } else if self.navigation.currentStory != nil {
                                self.navigation.fullScreenCoverContent = .storyView(carereceivers: [])
                            }
                        })
                        .logEventScreenView(screenName: "carereceiver_picker", context: .sheet)
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
            self.libraryManager.initializeLibraryListener()
        }
    }

    // MARK: Private

    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()

    @State private var showingAppUpdateAlert: Bool = false
    @State private var showingOSUpdateAlert: Bool = false
    @State private var updateAlertHasBeenShown: Bool = false

    private var persistentDataManager: PersistentDataManager = .shared
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared
    private var libraryManager: LibraryManager = .shared

    private func createRemovalAlert() -> Alert {
        guard let itemToRemove = self.libraryManagerViewModel.itemToRemove else {
            return Alert(title: Text("Error"))
        }

        switch self.libraryManagerViewModel.alertType {
            case .confirmPersonalFavorite:
                return Alert(
                    title: Text("Confirm Removal"),
                    message: Text("You have marked this item as a favorite. Are you sure you want to remove it from your library?"),
                    primaryButton: .destructive(Text("Remove")) {
                        self.libraryManagerViewModel.removeItemFromLibrary(itemToRemove)
                    },
                    secondaryButton: .cancel()
                )

            case .informOthersFavorited:
                return Alert(
                    title: Text("Cannot Remove Item"),
                    message: Text("This item is favorited by other caregivers. You cannot remove it."),
                    dismissButton: .default(Text("OK"))
                )

            case .none:
                return Alert(title: Text("Error"))
        }
    }
}

#Preview {
    MainView()
}

// swiftlint:enable type_body_length file_length
