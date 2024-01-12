// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaApp: App {
    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.viewRouter)
        }
    }
}
