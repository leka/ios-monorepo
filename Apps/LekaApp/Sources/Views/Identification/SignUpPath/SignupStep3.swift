// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SignupStep3: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    private let data: TileData = .signup_step3
    @State private var navigateToUserCreation: Bool = false

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()
            tile
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SignupNavigationTitle()
            }
        }
        .navigationDestination(isPresented: $navigateToUserCreation) {
            CreateUserProfileView()
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
                    .padding(.vertical, 20)

                // Title
                Text(data.content.title!)
                    .font(metrics.semi17)
                    .foregroundColor(Color("lekaOrange"))
                Spacer()
                // Message
                Text(data.content.message!)
                    .font(metrics.reg17)
                Spacer()
                // CTA Button
                accessoryView
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.accentColor)
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
                Text(data.content.CTALabel!)
            }
        )
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: metrics.reg17,
                color: .accentColor,
                width: metrics.tileBtnWidth)
        )
    }
}
