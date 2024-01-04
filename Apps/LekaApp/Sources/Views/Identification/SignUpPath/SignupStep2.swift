// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupStep2: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            self.tile
        }
        .edgesIgnoringSafeArea(.top)
        .navigationDestination(isPresented: self.$navigateToTeacherCreation) {
            CreateTeacherProfileView()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SignupNavigationTitle()
            }
        }
    }

    // MARK: Private

    private let data: TileData = .signupStep1
    @State private var navigateToTeacherCreation: Bool = false

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
                .padding(.top, 20)
                Spacer()
                // Title
                Text(self.data.content.title!)
                    .font(self.metrics.semi17)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)
                    .padding(.vertical, 20)
                // Message
                Text(self.data.content.message!)
                    .font(self.metrics.reg17)
                Spacer()
                // CTA Button
                self.accessoryView
            }
            .multilineTextAlignment(.center)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
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
                self.navigateToTeacherCreation.toggle()
            },
            label: {
                Text(self.data.content.callToActionLabel!)
            }
        )
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: self.metrics.reg17,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: self.metrics.tileBtnWidth
            )
        )
    }
}
