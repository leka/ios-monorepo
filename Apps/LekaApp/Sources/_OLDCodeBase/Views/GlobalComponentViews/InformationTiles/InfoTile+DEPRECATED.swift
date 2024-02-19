// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - InfoTileDeprecated

struct InfoTileDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated
    @EnvironmentObject var viewRouter: ViewRouterDeprecated
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
        HStack {
            switch self.data {
                case .discovery,
                     .curriculums,
                     .activities,
                     .commands:
                    Image(systemName: self.data.content.image!)
                default:
                    Image(self.data.content.image!)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
            }
            Spacer()
            Text(self.data.content.title!)
                .font(.title3)
            Spacer()
            if self.data != .discovery, self.settings.companyIsConnected {
                self.closeButton
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 20)
        .frame(height: 44)
        .foregroundColor(.white)
        .background(self.headerColor)
    }

    private var tileContent: some View {
        VStack {
            Spacer()
            Text(self.data.content.subtitle!)
                .font(.headline)
                .foregroundColor(self.headerColor)
                .padding(10)
            Spacer()
            Text(self.data.content.message!)
                .font(.subheadline)
                .padding(10)
            Spacer()
            if self.data == .discovery {
                self.connectButton
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 700)
    }

    private var closeButton: some View {
        Button {
            self.navigationVM.updateShowInfo()
        } label: {
            Image(systemName: "multiply")
        }
    }

    private var connectButton: some View {
        Button {
            self.viewRouter.currentPage = .welcome
        } label: {
            Text(self.data.content.callToActionLabel!)
        }
        .padding(.horizontal, 20)
        .buttonStyle(
            BorderedCapsule_NoFeedback_ButtonStyleDeprecated(
                font: .body,
                color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                width: 300
            )
        )
    }
}

// MARK: - InfoTile_Previews

struct InfoTile_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            InfoTileDeprecated(data: .discovery)
                .environmentObject(SettingsViewModelDeprecated())
                .environmentObject(NavigationViewModelDeprecated())
                .environmentObject(UIMetrics())
                .environmentObject(ViewRouterDeprecated())
                .padding()
        }
    }
}
