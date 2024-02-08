// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step4: View {
        @ObservedObject var rootOwnerViewModel = RootOwnerViewModel.shared

        var body: some View {
            VStack(spacing: 30) {
                Text(l10n.AccountCreationProcess.Step4.title)
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step4.message)

                Button(String(l10n.AccountCreationProcess.Step4.discoverContentButton.characters)) {
                    if !self.rootOwnerViewModel.mockCaregiversSet.isEmpty {
                        self.rootOwnerViewModel.currentCaregiver = self.rootOwnerViewModel.mockCaregiversSet.last
                    }
                    self.rootOwnerViewModel.isWelcomeViewPresented.toggle()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    AccountCreationProcess.Step4()
}
