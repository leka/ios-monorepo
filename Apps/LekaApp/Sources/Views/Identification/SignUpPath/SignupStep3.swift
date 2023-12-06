// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupStep3: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    private let data: TileData = .signupStep2
    @State private var navigateToUserCreation: Bool = false

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            tile
        }
        .edgesIgnoringSafeArea(.top)
        .navigationDestination(isPresented: $navigateToUserCreation) {
            CreateUserProfileView()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SignupNavigationTitle()
            }
        }
    }

    private var tile: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                // Picto
                Image(
                    data.content.image!,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: metrics.tilePictoHeightMedium)
                .padding(.vertical, 20)
                // Title
                Text(data.content.title!)
                    .font(metrics.semi17)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)
                Spacer()
                // Message
                Text(data.content.message!)
                    .font(metrics.reg17)
                Spacer()
                // CTA Button
                accessoryView
            }
            .multilineTextAlignment(.center)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .frame(width: metrics.tileContentWidth)
            .padding(.bottom, metrics.tileContentPadding)
        }
        .frame(
            width: metrics.tileSize.width,
            height: metrics.tileSize.height
        )
        .background(
            .white,
            in: RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
    }

    private var accessoryView: some View {
        Button(
            action: {
                navigateToUserCreation.toggle()
            },
            label: {
                Text(data.content.callToActionLabel!)
            }
        )
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: metrics.reg17,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: metrics.tileBtnWidth)
        )
    }
}
