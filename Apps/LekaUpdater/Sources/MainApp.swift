// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

@main
struct LekaUpdaterApp: App {
    var firmware = FirmwareManager()
    @StateObject var connectedRobot = DummyRobotModel()

    var body: some Scene {
        WindowGroup {
            VStack {
                InformationView()
                    .environmentObject(firmware)
                    .environmentObject(connectedRobot)

                Button("Switch (debug)") {
                    if connectedRobot.osVersion == "1.3.0" {
                        connectedRobot.osVersion = "1.4.0"
                    } else {
                        connectedRobot.osVersion = "1.3.0"
                    }
                }
            }
        }
    }
}
