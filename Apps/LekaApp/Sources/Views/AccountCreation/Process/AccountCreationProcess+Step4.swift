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
                    self.navigation.setFullScreenCoverContent(nil)
                    self.dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .onDisappear {
                self.authManagerViewModel.userAction = .none
                self.navigation.setSheetContent(.caregiverPicker)
                // TODO: (@dev/team): might not be needed, could be remoded
                self.navigation.setFullScreenCoverContent(nil)
                self.navigation.setNavigateToAccountCreationProcess(false)
            }
        }

        // MARK: Private

        @Environment(\.dismiss) private var dismiss

        @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared

        private var navigation = Navigation.shared
    }
}

#Preview {
    AccountCreationProcess.Step4()
}
