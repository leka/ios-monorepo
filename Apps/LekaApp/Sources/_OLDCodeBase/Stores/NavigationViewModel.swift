// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
    // Educative Content section data
    static let educContentSectionLabels: [SectionLabel] = [
        SectionLabel(
            destination: .curriculums,
            icon: "graduationcap",
            label: "Parcours"
        ),
        SectionLabel(
            destination: .activities,
            icon: "dice",
            label: "Activités"
        ),
        SectionLabel(
            destination: .commands,
            icon: "gamecontroller",
            label: "Commandes"
        ),
    ]

    // sidebar utils
    @Published var sidebarVisibility = NavigationSplitViewVisibility.all
    @Published var showSettings: Bool = false
    @Published var showProfileEditor: Bool = false
    @Published var showRobotPicker: Bool = false

    @Published var educContentList = ListModel(
        title: "Contenu Éducatif",
        sections: educContentSectionLabels
    )

    // Overall Navigation from the sidebar
    @Published var currentView: SidebarDestinations = .curriculums
    // Navigation within FullScreenCover to GameView()
    @Published var pathsFromHome = NavigationPath()
    @Published var showActivitiesFullScreenCover: Bool = false
    @Published var pathToGame = NavigationPath()

    // Info Tiles triggers
    @Published var showInfoCurriculums: Bool = true
    @Published var showInfoActivities: Bool = true
    @Published var showInfoCommands: Bool = true

    // Returned Views & NavigationTitles
    @ViewBuilder var allSidebarDestinationViews: some View {
        switch self.currentView {
            case .curriculums: CurriculumListView()
            case .activities: ActivityListView()
            case .commands: CommandListView()
        }
    }

    func getNavTitle() -> String {
        switch self.currentView {
            case .curriculums: "Parcours"
            case .activities: "Activités"
            case .commands: "Commandes"
        }
    }

    func contextualInfo() -> TileData {
        switch self.currentView {
            case .curriculums: .curriculums
            case .activities: .activities
            case .commands: .commands
        }
    }

    func showInfo() -> Bool {
        switch self.currentView {
            case .curriculums: self.showInfoCurriculums
            case .activities: self.showInfoActivities
            case .commands: self.showInfoCommands
        }
    }

    func updateShowInfo() {
        switch self.currentView {
            case .curriculums: self.showInfoCurriculums.toggle()
            case .activities: self.showInfoActivities.toggle()
            case .commands: self.showInfoCommands.toggle()
        }
    }
}
