// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentViewDeprecated: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Group {
            switch self.viewRouter.currentPage {
                case .welcome:
                    WelcomeViewDeprecated()
                        .transition(.opacity)
                case .home:
                    HomeViewDeprecated()
                        .transition(.opacity)
            }
        }
        .animation(.default, value: self.viewRouter.currentPage)
        .preferredColorScheme(.light)
    }
}
