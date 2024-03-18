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

    @Environment(\.dismiss) var dismiss

    var body: some View {
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
        .navigationDestination(isPresented: self.$navigation.navigateToAccountCreationProcess) {
            AccountCreationProcess.CarouselView()
                .navigationBarBackButtonHidden()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(String(l10n.WelcomeView.skipStepButton.characters)) {
                    self.dismiss()
                }
            }
        }
        .onAppear {
            self.authManagerViewModel.userAction = .none
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
