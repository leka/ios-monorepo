// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step2: View {
        // MARK: Internal

        var body: some View {
            self.tile
                .edgesIgnoringSafeArea(.top)
                .navigationDestination(isPresented: self.$navigateToCaregiverCreationView) {
                    AccountCreationProcess.CreateTeacherProfileView()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationTitle()
                    }
                }
        }

        // MARK: Private

        @State private var navigateToCaregiverCreationView: Bool = false

        private var tile: some View {
            VStack(spacing: 30) {
                Image(
                    DesignKitAsset.Images.accompagnantPicto.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)

                Text(l10n.AccountCreationView.step2Title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(.orange)

                Text(l10n.AccountCreationView.step2Message)

                Button(String(l10n.AccountCreationView.step2CreateButton.characters)) {
                    self.navigateToCaregiverCreationView.toggle()
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
