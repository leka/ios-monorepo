// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class SidebarViewModel: ObservableObject {
    static let educContentSectionLabels: [SectionLabel] = [  // Clean-ups all of this logic, enum instead for destinations
        SectionLabel(destination: .curriculums, icon: "curriculums", label: "Parcours"),
        SectionLabel(destination: .activities, icon: "activities", label: "Activités"),
        SectionLabel(destination: .commands, icon: "commands", label: "Commandes"),
    ]

    @Published var educContentList = ListModel(title: "Contenu Éducatif", sections: educContentSectionLabels)
    @Published var sidebarVisibility = NavigationSplitViewVisibility.all
    @Published var showSettings: Bool = false

    // Overall Navigation from the sidebar
    @Published var currentView: SidebarDestinations = .curriculums
    // Returned Views & NavigationTitles
    @ViewBuilder var allSidebarDestinationViews: some View {
        switch currentView {
            case .curriculums: CurriculumListView()
            case .activities: ActivityListView()
            case .commands: CommandListView()
        }
    }

    func setNavTitle() -> String {
        switch currentView {
            case .curriculums: return "Parcours"
            case .activities: return "Activités"
            case .commands: return "Commandes"
        }
    }

    // Currently watched profiles in FollowUp (this selection is lost when leaving)
    // Simulate some change within the data when selected profile is changing
    //    @Published var currentlySelectedTeacherProfile = UUID()
    //    @Published var currentlySelectedUserProfile = UUID()

    // Info Tiles
    @Published var showInfoCurriculums: Bool = true
    @Published var showInfoActivities: Bool = true
    @Published var showInfoCommands: Bool = true

    func contextualInfo() -> TileData {
        switch currentView {
            case .curriculums: return .curriculums
            case .activities: return .activities
            case .commands: return .commands
        }
    }

    func showInfo() -> Bool {
        switch currentView {
            case .curriculums: return showInfoCurriculums
            case .activities: return showInfoActivities
            case .commands: return showInfoCommands
        }
    }

    func updateShowInfo() {
        switch currentView {
            case .curriculums: showInfoCurriculums.toggle()
            case .activities: showInfoActivities.toggle()
            case .commands: showInfoCommands.toggle()
        }
    }

}
