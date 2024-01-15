// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step4: View {
        // MARK: Internal

        @EnvironmentObject var viewRouter: ViewRouter

        var body: some View {
            self.tile
                .edgesIgnoringSafeArea(.top)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationTitle()
                    }
                }
        }

        // MARK: Private

        private var tile: some View {
            VStack(spacing: 30) {
                Text(l10n.AccountCreationProcess.Step4.title)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step4.message)

                Button(String(l10n.AccountCreationProcess.Step4.discoverContentButton.characters)) {
                    withAnimation {
                        self.viewRouter.currentPage = .home
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
    AccountCreationProcess.Step4()
}
