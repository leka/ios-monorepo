// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step3: View {
        // MARK: Internal

        @Binding var selectedTab: Step

        var body: some View {
            VStack(spacing: 30) {
                Image(
                    DesignKitAsset.Images.user.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)

                Text(l10n.AccountCreationProcess.Step3.title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step3.message)

                Button(String(l10n.AccountCreationProcess.Step3.createButton.characters)) {
                    self.isCarereceiverCreationPresented.toggle()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: self.$isCarereceiverCreationPresented) {
                CreateCarereceiverView(isPresented: self.$isCarereceiverCreationPresented) {
                    self.selectedTab = .final
                }
            }
        }

        // MARK: Private

        @State private var isCarereceiverCreationPresented: Bool = false
    }
}

#Preview {
    AccountCreationProcess.Step3(selectedTab: .constant(.carereceiverCreation))
}
