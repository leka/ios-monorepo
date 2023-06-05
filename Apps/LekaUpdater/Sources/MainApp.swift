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
            Leka_1_0_0_ViewDemo()
        }
    }
}
