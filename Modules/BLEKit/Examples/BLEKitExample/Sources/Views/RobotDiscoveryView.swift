// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct RobotDiscoveryView: View {
    // MARK: Lifecycle

    public init(discovery: RobotDiscoveryModel) {
        self.discovery = discovery
    }

    // MARK: Internal

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
                        Text(discovery.name)
                            .font(.headline)
                        Text("v\(discovery.osVersion)")
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Battery: \(discovery.battery)")
                        Text("Charging: \(discovery.isCharging ? "Yes" : "No")")
                            .foregroundColor(discovery.isCharging ? .green : .red)
                    }

                    Spacer()
                }
            }
        }
    }

    // MARK: Private

    private var discovery: RobotDiscoveryModel

    // MARK: - Environment variables

    @EnvironmentObject private var robotListViewModel: RobotListViewModel
}

// TODO(@ladislas): create protocol and mock RobotDiscovery
//struct RobotView_Previews: PreviewProvider {
//    static var previews: some View {
//        RobotDiscoveryView(discovery: RobotDiscovery.mock())
//    }
//}
