//// Leka - iOS Monorepo
//// Copyright 2023 APF France handicap
//// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotGridView: View {

    @EnvironmentObject var robotConnectionViewModel: RobotConnectionViewModel

    private let tileContentWidth: CGFloat = 360
    private let tilePictoHeightSmall: CGFloat = 80
    private let reg17: Font = .system(size: 17, weight: .regular)

    private let columns = Array(repeating: GridItem(), count: 2)

    var body: some View {
        Group {
            if let robotDiscoveries = robotConnectionViewModel.robotDiscoveries {
                switch robotDiscoveries.count {
                    case 0:
                        Text("No robots found :(")
                    default:
                        VStack(alignment: .trailing) {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: columns) {
                                    robotDiscoveriesViews
                                }
                            }
                        }
                }
            } else {
                searchInvite
            }
        }
    }

    private var searchInvite: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: tilePictoHeightSmall)
                    .padding(.top, 10)
                Text("Launch a search to find the robots around you!")
                    .font(reg17)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: tileContentWidth)
            .offset(y: -160)
            Spacer()
        }
    }

    private var robotDiscoveriesViews: some View {
        self.robotConnectionViewModel.robotDiscoveries.map { discoveries in
            ForEach(discoveries) { discovery in
                RobotDiscoveryView(discovery: discovery)
                    .onTapGesture {
                        print("tapped: \(discovery.name)")
                        switch discovery.status {
                            case .connected:
                                return
                            case .unselected:
                                self.robotConnectionViewModel.selectedRobotDiscovery = discovery
                            case .selected:
                                self.robotConnectionViewModel.selectedRobotDiscovery = nil
                        }
                    }
                    .disabled(robotConnectionViewModel.connected)
            }
        }
    }

}

struct RobotGridView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            RobotGridView()
                .environmentObject(
                    { () -> RobotConnectionViewModel in
                        let viewModel = RobotConnectionViewModel()
                        viewModel.robotDiscoveries = (1...10)
                            .map {
                                RobotDiscoveryViewModel(
                                    name: "Leka \($0)", battery: Int.random(in: 0...100),
                                    isCharging: Bool.random(), osVersion: "1.2.3", status: .unselected)
                            }
                        return viewModel
                    }())
        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        .previewInterfaceOrientation(.portrait)

    }
}
