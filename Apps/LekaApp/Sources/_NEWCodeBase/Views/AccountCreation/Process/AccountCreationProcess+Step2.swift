// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step2: View {
        // MARK: Internal

        @Binding var selectedTab: Step

        var body: some View {
            VStack(spacing: 30) {
                Image(
                    DesignKitAsset.Images.accompagnantPicto.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)

                Text(l10n.AccountCreationProcess.Step2.title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(.orange)

                Text(l10n.AccountCreationProcess.Step2.message)

                Button(String(l10n.AccountCreationProcess.Step2.createButton.characters)) {
                    withAnimation {
                        self.isCaregiverCreationPresented.toggle()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: self.$isCaregiverCreationPresented) {
                AccountCreationProcess.CreateCaregiverView(selectedTab: self.$selectedTab,
                                                           isPresented: self.$isCaregiverCreationPresented)
            }
        }

        // MARK: Private

        @State private var isCaregiverCreationPresented: Bool = false
    }
}

#Preview {
    AccountCreationProcess.Step2(selectedTab: .constant(AccountCreationProcess.Step.caregiverCreation))
}
