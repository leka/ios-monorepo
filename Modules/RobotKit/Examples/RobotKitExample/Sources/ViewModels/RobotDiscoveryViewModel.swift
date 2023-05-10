// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// TODO(@ladisals): maybe move to simple model/struct --> is it needed to @Publish? -- test charging status change
public class RobotDiscoveryViewModel: ObservableObject, Equatable {
    @Published var name: String
    @Published var battery: Int
    @Published var isCharging: Bool
    @Published var osVersion: String
    @Published var status: RobotGridViewStatus

    init(name: String, battery: Int, isCharging: Bool, osVersion: String, status: RobotGridViewStatus = .unselected) {
        self.name = name
        self.battery = battery
        self.isCharging = isCharging
        self.osVersion = osVersion
        self.status = status
    }

    public static func == (lhs: RobotDiscoveryViewModel, rhs: RobotDiscoveryViewModel) -> Bool {
        lhs.name == rhs.name
    }

}
