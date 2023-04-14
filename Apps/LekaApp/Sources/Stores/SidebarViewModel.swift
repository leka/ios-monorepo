// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class SidebarViewModel: ObservableObject {
    static let educContentSectionLabels: [SectionLabel] = [
        SectionLabel(destination: .curriculums, icon: "curriculums", label: "Parcours", has3Columns: false),
        SectionLabel(destination: .activities, icon: "activities", label: "Activités", has3Columns: false),
        SectionLabel(destination: .commands, icon: "commands", label: "Commandes", has3Columns: false),
        SectionLabel(destination: .stories, icon: "stories", label: "Histoires", has3Columns: false),
    ]

    static let followUpSectionLabels: [SectionLabel] = [
        SectionLabel(destination: .users, icon: "user", label: "Utilisateurs", has3Columns: true),
        SectionLabel(destination: .teachers, icon: "accompanying", label: "Accompagnants", has3Columns: true),
    ]

    @Published var educContentList = ListModel(title: "Contenu Éducatif", sections: educContentSectionLabels)
    @Published var followUpList = ListModel(title: "Suivi", sections: followUpSectionLabels)
    @Published var has3Columns: Bool = false
    @Published var sidebarVisibility = NavigationSplitViewVisibility.all
    @Published var contentVisibility = NavigationSplitViewVisibility.all  // 3 columns-splitView...
    @Published var educContentIsExpanded: Bool = true
    @Published var followUpIsExpanded: Bool = true
    @Published var showSettings: Bool = false

    // Overall Navigation from the sidebar
    @Published var currentView: SidebarDestinations = .curriculums
    // Returned Views & NavigationTitles
    @ViewBuilder var allSidebarDestinationViews: some View {
        switch currentView {
            case .curriculums: CurriculumListView()
            case .activities: ActivityListView()
            case .commands: CommandListView()
            case .stories: StoryListView()
            case .teachers: UserDataView()
            case .users: UserDataView()
        }
    }

    func setNavTitle() -> String {
        switch currentView {
            case .curriculums: return "Parcours"
            case .activities: return "Activités"
            case .commands: return "Commandes"
            case .stories: return "Histoires"
            case .teachers: return "Historique des activités d'Alice"
            case .users: return "Historique des activités d'Alice"
        }
    }

    // Currently watched profiles in FollowUp (this selection is lost when leaving)
    // Simulate some change within the data when selected profile is changing
    @Published var currentlySelectedTeacherProfile = UUID()
    @Published var currentlySelectedUserProfile = UUID()
    @Published var successValues: [Double] = [
        0.86, 0.4, 0.2, 1, 0.56, 0.77, 0.44, 0.48, 1, 0.24, 0.86, 0.4, 0.2, 1, 0.56, 0.77, 0.44, 0.48, 1, 0.24,
    ]

    // Info Tiles
    @Published var showInfoCurriculums: Bool = true
    @Published var showInfoActivities: Bool = true
    @Published var showInfoCommands: Bool = true
    @Published var showInfoStories: Bool = true
    @Published var showInfoTeachers: Bool = true
    @Published var showInfoUsers: Bool = true

    func contextualInfo() -> TileData {
        switch currentView {
            case .curriculums: return .curriculums
            case .activities: return .activities
            case .commands: return .commands
            case .stories: return .stories
            case .teachers: return .teacher
            case .users: return .user
        }
    }

    func showInfo() -> Bool {
        switch currentView {
            case .curriculums: return showInfoCurriculums
            case .activities: return showInfoActivities
            case .commands: return showInfoCommands
            case .stories: return showInfoStories
            case .teachers: return showInfoTeachers
            case .users: return showInfoUsers
        }
    }

    func updateShowInfo() {
        switch currentView {
            case .curriculums: showInfoCurriculums.toggle()
            case .activities: showInfoActivities.toggle()
            case .commands: showInfoCommands.toggle()
            case .stories: showInfoStories.toggle()
            case .teachers: showInfoTeachers.toggle()
            case .users: showInfoUsers.toggle()
        }
    }

}
