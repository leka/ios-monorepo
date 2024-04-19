// Leka - iOS Monorepo
// Copyright APF France handicap
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
                // TODO: (@ui/ux) - Design System - replace with Leka font
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
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
                .foregroundColor(self.headerColor)
                .padding(10)
            Spacer()
            Text(self.data.content.message!)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.subheadline)
                .padding(10)
            Spacer()
            if self.data == .discovery {
                self.connectButton
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 700)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
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
            // TODO: (@ui/ux) - Design System - replace with Leka font
            BorderedCapsule_NoFeedback_ButtonStyle(
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
            InfoTile(data: .discovery)
                .environmentObject(SettingsViewModel())
                .environmentObject(NavigationViewModel())
                .environmentObject(UIMetrics())
                .environmentObject(ViewRouter())
                .padding()
        }
    }
}
