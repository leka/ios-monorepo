// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupStep2: View {

    @EnvironmentObject var metrics: UIMetrics

    private let data: TileData = .signupStep1
    @State private var navigateToTeacherCreation: Bool = false

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            tile
        }
        .edgesIgnoringSafeArea(.top)
        .navigationDestination(isPresented: $navigateToTeacherCreation) {
            CreateTeacherProfileView()
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
                Image(data.content.image!)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: metrics.tilePictoHeightMedium)
                    .padding(.top, 20)
                Spacer()
                // Title
                Text(data.content.title!)
                    .font(metrics.semi17)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)
                    .padding(.vertical, 20)
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
                navigateToTeacherCreation.toggle()
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
