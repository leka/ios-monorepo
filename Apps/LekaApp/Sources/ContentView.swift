// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Group {
            switch viewRouter.currentPage {
                case .welcome:
                    WelcomeView()
                        .transition(.opacity)
                case .home:
                    HomeView()
                        .transition(.opacity)
            }
        }
        .animation(.default, value: viewRouter.currentPage)
        .preferredColorScheme(.light)
    }
}
