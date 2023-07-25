// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum Page {
    case connection
    case information
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .connection
}
