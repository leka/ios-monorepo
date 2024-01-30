// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - NewsView

struct NewsView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack {
            Text("Hello, What's new!")
                .font(.largeTitle)
                .bold()

            if self.authManager.userAuthenticationState != .loggedIn {
                VStack {
                    Text("Vous utilisez actuellement votre application en mode découverte")
                        .font(.headline)
                    Text("Vous ne pouvez pas créer de profils et aucune donnée ne sera enregistrée.")
                        .font(.subheadline)

                    Button("Se connecter ou Créer un compte") {
                        self.authManager.isWelcomeViewPresented = true
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
    }
}

#Preview {
    NewsView()
}
