// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - InfoTile

struct InfoTile: View {
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    let data: TileData
    private var headerColor: Color {
        data == .discovery
            ? DesignKitAsset.Colors.lekaOrange.swiftUIColor : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
    }

    var body: some View {
        VStack(spacing: 0) {
            tileHeader
            tileContent
            Spacer()
        }
        .frame(height: 266)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
    }

    private var tileHeader: some View {
        ZStack {
            Text(data.content.title!)
            HStack {
                switch data {
                    case .discovery, .curriculums, .activities, .commands:
                        Image(systemName: data.content.image!)
                            .font(metrics.reg19)
                    default:
                        Image(data.content.image!)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                }
                Spacer()
                if data != .discovery, settings.companyIsConnected {
                    closeButton
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
        }
        .font(metrics.semi17)
        .frame(height: 44)
        .foregroundColor(.white)
        .background(headerColor)
    }

    private var tileContent: some View {
        VStack {
            Spacer()
            Text(data.content.subtitle!)
                .font(metrics.reg17)
                .foregroundColor(headerColor)
            Spacer()
            Text(data.content.message!)
                .font(metrics.reg13)
            Spacer()
            if data == .discovery {
                connectButton
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 300)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var closeButton: some View {
        Button {
            navigationVM.updateShowInfo()
        } label: {
            Image(systemName: "multiply")
                .font(metrics.semi20)
        }
    }

    private var connectButton: some View {
        Button {
            viewRouter.currentPage = .welcome
        } label: {
            Text(data.content.callToActionLabel!)
        }
        .padding(20)
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: metrics.reg17,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: 300))
    }
}

// MARK: - InfoTile_Previews

struct InfoTile_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            InfoTile(data: .discovery)
                .environmentObject(SettingsViewModel())
                .environmentObject(NavigationViewModel())
                .environmentObject(UIMetrics())
                .environmentObject(ViewRouter())
                .padding()
        }
    }
}
