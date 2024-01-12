// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                LekaLogo(height: 90)

                NavigationLink(String(l10n.WelcomeView.createAccountButton.characters)) {
                    SignupView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(String(l10n.WelcomeView.loginButton.characters)) {
                    LoginView()
                }
                .buttonStyle(.bordered)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(l10n.WelcomeView.skipStepButton.characters)) {
                        self.viewRouter.currentPage = .home
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(ViewRouter())
}
