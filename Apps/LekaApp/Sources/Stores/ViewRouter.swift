// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Page {
    case welcome
    case home
    case curriculumDetail
    case game
}

enum PathsToGame: Hashable {
    case userSelect, game
}

enum PathsToGameFromActivity: Hashable {
    case game
}

class ViewRouter: ObservableObject {

    @Published var currentPage: Page = .welcome
    @Published var pathFromCurriculum: [PathsToGame] = []
    @Published var pathFromActivity: [PathsToGameFromActivity] = []
}
