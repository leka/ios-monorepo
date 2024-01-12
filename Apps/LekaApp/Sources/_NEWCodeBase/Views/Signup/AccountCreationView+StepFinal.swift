// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationView {
    struct StepFinal: View {
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
                Text(l10n.AccountCreationView.stepFinalTitle)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationView.stepFinalMessage)

                Button(String(l10n.AccountCreationView.stepFinalDiscoverContentButton.characters)) {
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
    AccountCreationView.StepFinal()
}
