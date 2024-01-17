// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouterDeprecated

    var body: some View {
        Group {
            switch self.viewRouter.currentPage {
                case .welcome:
                    WelcomeView()
                        .transition(.opacity)
                case .home:
                    MainView()
                        .transition(.opacity)
            }
        }
        .animation(.default, value: self.viewRouter.currentPage)
    }
}
