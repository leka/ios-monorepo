// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step1: View {
        @Binding var selectedTab: Step

        var body: some View {
            VStack(spacing: 30) {
                Text(l10n.AccountCreationProcess.Step1.title)
                    .font(.headline)
                    .foregroundColor(.orange)

                Text(l10n.AccountCreationProcess.Step1.message)

                Button(String(l10n.AccountCreationProcess.Step1.goButton.characters)) {
                    withAnimation {
                        self.selectedTab = .caregiverCreation
                    }
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
    AccountCreationProcess.Step1(selectedTab: .constant(.intro))
}
