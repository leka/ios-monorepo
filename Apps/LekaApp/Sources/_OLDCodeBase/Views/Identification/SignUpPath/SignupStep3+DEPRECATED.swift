// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupStep3Deprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            self.tile
        }
        .edgesIgnoringSafeArea(.top)
        .navigationDestination(isPresented: self.$navigateToUserCreation) {
            CreateUserProfileViewDeprecated()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SignupNavigationTitleDeprecated()
            }
        }
    }

    // MARK: Private

    private let data: TileData = .signupStep2
    @State private var navigateToUserCreation: Bool = false

    private var tile: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                // Picto
                Image(
                    self.data.content.image!,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: self.metrics.tilePictoHeightMedium)
                .padding(.vertical, 20)
                // Title
                Text(self.data.content.title!)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)
                Spacer()
                // Message
                Text(self.data.content.message!)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.body)
                Spacer()
                // CTA Button
                self.accessoryView
            }
            .multilineTextAlignment(.center)
            .frame(width: self.metrics.tileContentWidth)
            .padding(.bottom, self.metrics.tileContentPadding)
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
        Button(
            action: {
                self.navigateToUserCreation.toggle()
            },
            label: {
                Text(self.data.content.callToActionLabel!)
            }
        )
        .buttonStyle(
            // TODO: (@ui/ux) - Design System - replace with Leka font
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: .body,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: self.metrics.tileBtnWidth
            )
        )
    }
}
