// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaActivityUIExplorerApp: App {

    @StateObject var router = Router()

    var body: some Scene {
        WindowGroup {
            SwitchBoard()
                .environmentObject(router)
                .preferredColorScheme(.light)
        }
    }
}
