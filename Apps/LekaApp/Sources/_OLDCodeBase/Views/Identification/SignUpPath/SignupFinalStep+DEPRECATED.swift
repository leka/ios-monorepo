// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupFinalStepDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            self.tile
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SignupNavigationTitleDeprecated()
            }
        }
    }

    // MARK: Private

    private let data: TileData = .signupFinalStep

    private var tile: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                // Title
                Text(self.data.content.title!)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)
                Spacer()
                // Message
                VStack(spacing: 10) {
                    Text(self.data.content.message!)
                        .padding(.bottom, 10)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("✅ Créer votre profil de professionnel")
                        Text("✅ Créer votre 1er profil de personne accompagnée")
                        Text("Vous allez maintenant pouvoir découvrir l'univers Leka et le contenu éducatif.")
                            .padding(.vertical, 10)
                    }
                }
                .multilineTextAlignment(.center)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.body)
                Spacer()
                // CTA Button
                self.accessoryView
            }
            .multilineTextAlignment(.center)
            .frame(width: 400)
            .padding(self.metrics.tileContentPadding)
        }
        .frame(
            width: self.metrics.tileSize.width,
            height: self.metrics.tileSize.height
        )
        .background(
            .white,
            in: RoundedRectangle(cornerRadius: self.metrics.tilesRadius, style: .continuous)
        )
    }

    private var accessoryView: some View {
        Button {
            withAnimation {
                self.viewRouter.currentPage = .home
            }
        } label: {
            Text(self.data.content.callToActionLabel!)
        }
        .buttonStyle(
            // TODO: (@ui/ux) - Design System - replace with Leka font
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: .body,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
            )
        )
    }
}
