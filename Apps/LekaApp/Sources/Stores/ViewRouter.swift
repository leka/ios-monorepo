// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Page {
    case welcome
    case home
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .welcome
}
