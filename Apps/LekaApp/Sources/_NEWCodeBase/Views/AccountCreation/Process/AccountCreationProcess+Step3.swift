// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step3: View {
        // MARK: Internal

        var body: some View {
            self.tile
                .edgesIgnoringSafeArea(.top)
                .navigationDestination(isPresented: self.$navigateToCarereciverCreationView) {
                    AccountCreationProcess.CreateUserProfileView()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationTitle()
                    }
                }
        }

        // MARK: Private

        @State private var navigateToCarereciverCreationView: Bool = false

        private var tile: some View {
            VStack(spacing: 30) {
                Image(
                    DesignKitAsset.Images.user.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)

                Text(l10n.AccountCreationView.step3Title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationView.step3Message)

                Button(String(l10n.AccountCreationView.step3CreateButton.characters)) {
                    self.navigateToCarereciverCreationView.toggle()
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
    AccountCreationProcess.Step3()
}
