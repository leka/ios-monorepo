// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class RobotViewModel: ObservableObject {

    // Robot Connect
    // Make 'robotIsConnected' & 'currentlyConnectedRobotIndex' one prop' instead
    // if currentlyConnectedRobotIndex is not nil, robot is connected for sure
    @Published var currentlySelectedRobotIndex: Int?
    @Published var currentlyConnectedRobotIndex: Int?

    // robot Advertised Information
    @Published var robotIsConnected: Bool = false
    @Published var userChoseToPlayWithoutRobot: Bool = false
    @Published var robotChargeLevel: Double = 100
    @Published var robotIsCharging: Bool = false
    @Published var currentlyConnectedRobotName: String = ""
    @Published var robotOSVersion: String = "LekaOS v1.4.0"

    func disconnect() {
        currentlySelectedRobotIndex = nil
        currentlyConnectedRobotIndex = nil
        robotIsConnected = false
    }

}
