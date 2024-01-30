// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step4: View {
        @EnvironmentObject var authManager: AuthManager

        var body: some View {
            VStack(spacing: 30) {
                Text(l10n.AccountCreationProcess.Step4.title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step4.message)

                Button(String(l10n.AccountCreationProcess.Step4.discoverContentButton.characters)) {
                    self.authManager.isWelcomeViewPresented.toggle()
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
