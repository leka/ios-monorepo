// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    // MARK: Internal

    @EnvironmentObject var viewRouter: ViewRouter

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
        .fullScreenCover(isPresented: self.$isCurrentPageModalShown) {
            VStack {
                Button("Show WelcomeView") {
                    self.viewRouter.currentPage = .welcome
                    self.isCurrentPageModalShown.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Show MainView") {
                    self.viewRouter.currentPage = .home
                    self.isCurrentPageModalShown.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Dismiss") {
                    self.isCurrentPageModalShown.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: Private

    @State private var isCurrentPageModalShown = true
}
