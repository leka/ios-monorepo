//// Leka - iOS Monorepo
//// Copyright 2023 APF France handicap
//// SPDX-License-Identifier: Apache-2.0

// Copied from RobotKit

import SwiftUI

struct RobotGridView: View {

    @EnvironmentObject var robotConnectionViewModel: RobotConnectionViewModel

    var body: some View {
        Group {
            if let robotDiscoveries = robotConnectionViewModel.robotDiscoveries {
                switch robotDiscoveries.count {
                    case 0:
                        Text("No robots found :(")
                    case 1...4:
                        VStack {
                            HStack(spacing: 120) {
                                robotDiscoveriesViews
                            }
                        }
                    default:
                        VStack(alignment: .trailing) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 90) {
                                    Spacer()
                                    robotDiscoveriesViews
                                    Spacer()
                                }
                            }
                        }
                }
            } else {
                Text("Start searching")
            }
        }
    }

    private var robotDiscoveriesViews: some View {
        self.robotConnectionViewModel.robotDiscoveries.map { discoveries in
            ForEach(discoveries, id: \.name) { discovery in
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
        .previewInterfaceOrientation(.landscapeLeft)

    }
}
