// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Page

enum Page {
    case welcome
    case home
}

// MARK: - ViewRouter

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .welcome
}
