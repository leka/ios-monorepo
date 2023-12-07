// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - InfoTile

struct InfoTile: View {
    // MARK: Internal

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    let data: TileData

    var body: some View {
        VStack(spacing: 0) {
            self.tileHeader
            self.tileContent
            Spacer()
        }
        .frame(height: 266)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: self.metrics.tilesRadius, style: .continuous))
    }

    // MARK: Private

    private var headerColor: Color {
        self.data == .discovery
            ? DesignKitAsset.Colors.lekaOrange.swiftUIColor : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
    }

    private var tileHeader: some View {
        ZStack {
            Text(self.data.content.title!)
            HStack {
                switch self.data {
                    case .discovery,
                         .curriculums,
                         .activities,
                         .commands:
                        Image(systemName: self.data.content.image!)
                            .font(self.metrics.reg19)
                    default:
                        Image(self.data.content.image!)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                }
                Spacer()
                if self.data != .discovery, self.settings.companyIsConnected {
                    self.closeButton
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
        }
        .font(self.metrics.semi17)
        .frame(height: 44)
        .foregroundColor(.white)
        .background(self.headerColor)
    }

    private var tileContent: some View {
        VStack {
            Spacer()
            Text(self.data.content.subtitle!)
                .font(self.metrics.reg17)
                .foregroundColor(self.headerColor)
            Spacer()
            Text(self.data.content.message!)
                .font(self.metrics.reg13)
            Spacer()
            if self.data == .discovery {
                self.connectButton
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 300)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var closeButton: some View {
        Button {
            self.navigationVM.updateShowInfo()
        } label: {
            Image(systemName: "multiply")
                .font(self.metrics.semi20)
        }
    }

    private var connectButton: some View {
        Button {
            self.viewRouter.currentPage = .welcome
        } label: {
            Text(self.data.content.callToActionLabel!)
        }
        .padding(20)
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyle(
                font: self.metrics.reg17,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: 300
            ))
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
