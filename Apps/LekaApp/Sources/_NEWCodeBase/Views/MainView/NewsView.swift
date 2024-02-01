// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - NewsView

struct NewsView: View {
    @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared

    var body: some View {
        VStack {
            Text("Hello, What's new!")
                .font(.largeTitle)
                .bold()

            if self.rootOwnerViewModel.currentCompany == nil {
                VStack {
                    Text("Vous utilisez actuellement votre application en mode découverte")
                        .font(.headline)
                    Text("Vous ne pouvez pas créer de profils et aucune donnée ne sera enregistrée.")
                        .font(.subheadline)

                    Button("Se connecter ou Créer un compte") {
                        self.rootOwnerViewModel.isWelcomeViewPresented = true
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
