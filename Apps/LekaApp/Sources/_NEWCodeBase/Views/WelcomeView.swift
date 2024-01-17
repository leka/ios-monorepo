// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    @EnvironmentObject var viewRouter: ViewRouterDeprecated

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                LekaLogo(height: 90)

                NavigationLink(String(l10n.WelcomeView.createAccountButton.characters)) {
                    AccountCreationView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(String(l10n.WelcomeView.loginButton.characters)) {
                    ConnectionView()
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
        .environmentObject(ViewRouterDeprecated())
}
