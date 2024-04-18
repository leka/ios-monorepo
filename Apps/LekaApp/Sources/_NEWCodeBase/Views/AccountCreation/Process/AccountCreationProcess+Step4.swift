// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step4: View {
        // MARK: Internal

        var body: some View {
            VStack(spacing: 30) {
                Text(l10n.AccountCreationProcess.Step4.title)
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step4.message)

                Button(String(l10n.AccountCreationProcess.Step4.discoverContentButton.characters)) {
                    self.authManagerViewModel.userAction = .none
                    self.rootOwnerViewModel.isWelcomeViewPresented = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
        }

        // MARK: Private

        @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
        @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared
    }
}

#Preview {
    AccountCreationProcess.Step4()
}
