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
                    if self.robotListViewModel.selectedRobotDiscovery == self.discovery {
                        return "checkmark.circle.fill"
                    }

                    if self.robotListViewModel.connectedRobotDiscovery == self.discovery {
                        return "checkmark.circle.fill"
                    }

                    return "circle"
                }()
            )
            .font(.system(size: 40))
            .foregroundColor(
                {
                    if self.robotListViewModel.connectedRobotDiscovery == self.discovery {
                        return .green
                    }

                    if self.robotListViewModel.selectedRobotDiscovery == self.discovery {
                        return .accentColor
                    }

                    return .gray
                }()
            )
            .animation(.easeIn(duration: 0.25), value: self.robotListViewModel.selectedRobotDiscovery == self.discovery)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        Text(self.discovery.name)
                            .font(.headline)
                        Text("v\(self.discovery.osVersion)")
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Battery: \(self.discovery.battery)")
                        Text("Charging: \(self.discovery.isCharging ? "Yes" : "No")")
                            .foregroundColor(self.discovery.isCharging ? .green : .red)
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
// struct RobotView_Previews: PreviewProvider {
//    static var previews: some View {
//        RobotDiscoveryView(discovery: RobotDiscovery.mock())
//    }
// }
