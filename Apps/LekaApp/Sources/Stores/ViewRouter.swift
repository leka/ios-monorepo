// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Page {
    case welcome
    //    case identificationPaths
    case profiles
    case bots
    case home
    case curriculumDetail
    case game
}

class ViewRouter: ObservableObject {

    // if !settings.userIsConnected { .welcome else .home
    //
    @Published var currentPage: Page = .welcome

    // NavigationStacks Triggers
    @Published var goToGameFromCurriculums: Bool = false
    @Published var goToGameFromActivities: Bool = false
    @Published var showUserSelector: Bool = false
}
