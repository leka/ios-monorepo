// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    // MARK: Internal

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
                        self.rootOwnerViewModel.isWelcomeViewPresented.toggle()
                    }
                }
            }
            .onAppear {
                self.authManagerViewModel.userIsSigningIn = false
                self.authManagerViewModel.userIsSigningUp = false
            }
        }
    }

    // MARK: Private

    @ObservedObject private var caregiverManagerViewModel: CaregiverManagerViewModel = .shared
    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared
}

#Preview {
    WelcomeView()
}
