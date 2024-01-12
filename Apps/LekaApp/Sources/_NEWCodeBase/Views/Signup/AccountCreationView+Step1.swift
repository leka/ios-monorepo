// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationView {
    struct Step1: View {
        // MARK: Internal

        var body: some View {
            self.tile
                .edgesIgnoringSafeArea(.top)
                .navigationDestination(isPresented: self.$navigateToStep2) {
                    Step2()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationTitle()
                    }
                }
        }

        // MARK: Private

        @State private var navigateToStep2: Bool = false

        private var tile: some View {
            VStack(spacing: 30) {
                Image(
                    DesignKitAsset.Images.welcome.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
                .padding()

                Text(l10n.AccountCreationView.step1Title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(.orange)

                Text(l10n.AccountCreationView.step1Message)

                Button(String(l10n.AccountCreationView.step1GoButton.characters)) {
                    self.navigateToStep2.toggle()
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
    AccountCreationView.Step1()
}
