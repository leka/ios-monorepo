// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct RobotDiscoveryView: View {

    private var discovery: RobotDiscovery

    // MARK: - Environment variables

    @EnvironmentObject private var robotListViewModel: RobotListViewModel

    private var osVersionText: String {
        guard let osVersion = discovery.advertisingData.osVersion else {
            return "⚠️ NO OS VERSION"
        }
        return "Firmware: v\(osVersion)"
    }

    public init(discovery: RobotDiscovery) {
        self.discovery = discovery
    }

    var body: some View {
        HStack(spacing: 20) {
            Image(
                systemName: {
                    if robotListViewModel.selectedRobotDiscovery == discovery {
                        return "checkmark.circle.fill"
                    }

                    if robotListViewModel.connectedRobotDiscovery == discovery {
                        return "checkmark.circle.fill"
                    }

                    return "circle"
                }()
            )
            .font(.system(size: 40))
            .foregroundColor(
                {
                    if robotListViewModel.connectedRobotDiscovery == discovery {
                        return .green
                    }

                    if robotListViewModel.selectedRobotDiscovery == discovery {
                        return .accentColor
                    }

                    return .gray
                }()
            )
            .animation(.easeIn(duration: 0.25), value: { robotListViewModel.selectedRobotDiscovery == discovery }())

            VStack(alignment: .leading, spacing: 10) {

                HStack(spacing: 40) {

                    VStack(alignment: .leading) {
                        Text(discovery.advertisingData.name)
                            .font(.headline)
                        Text(osVersionText)
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Battery: \(discovery.advertisingData.battery)")
                        Text("Charging: \(discovery.advertisingData.isCharging ? "Yes" : "No")")
                            .foregroundColor(discovery.advertisingData.isCharging ? .green : .red)
                    }

                    Spacer()
                }
            }
        }
    }

}

// TODO(@ladislas): create protocol and mock RobotDiscovery
//struct RobotView_Previews: PreviewProvider {
//    static var previews: some View {
//        RobotDiscoveryView(discovery: RobotDiscovery.mock())
//    }
//}
