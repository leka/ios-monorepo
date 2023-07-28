// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class SidebarViewModel: ObservableObject {

    // sidebar utils
    @Published var sidebarVisibility = NavigationSplitViewVisibility.all
    @Published var showSettings: Bool = false
    @Published var showProfileEditor: Bool = false
    @Published var showRobotPicker: Bool = false

    // Educative Content section data
    static let educContentSectionLabels: [SectionLabel] = [
        SectionLabel(destination: .curriculums, icon: "curriculums", label: "Parcours"),
        SectionLabel(destination: .activities, icon: "activities", label: "Activités"),
        SectionLabel(destination: .commands, icon: "commands", label: "Commandes"),
    ]
    @Published var educContentList = ListModel(title: "Contenu Éducatif", sections: educContentSectionLabels)

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

    // Info Tiles triggers
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
