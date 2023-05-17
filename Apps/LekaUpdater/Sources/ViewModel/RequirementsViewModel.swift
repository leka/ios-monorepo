// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class RequirementsViewModel: ObservableObject {
    @ObservedObject private var robot: DummyRobotModel

    var batteryImage: Image {
        if robot.battery >= 100 {
            return Image(systemName: "battery.100")
        } else if robot.battery >= 75 {
            return Image(systemName: "battery.75")
        } else if robot.battery >= 50 {
            return Image(systemName: "battery.50")
        } else if robot.battery >= 25 {
            return Image(systemName: "battery.25")
        } else {
            return Image(systemName: "battery.0")
        }
    }

    var batteryForegroundColor: Color {
        robot.battery >= 30 ? .green : .red
    }

    var isChargingForegroundColor: Color {
        robot.isCharging ? .green : .red
    }

    var robotIsNotReadyToUpdate: Bool {
        !(robot.battery >= 30 && robot.isCharging)
    }

    init(robot: DummyRobotModel) {
        self._robot = ObservedObject(wrappedValue: robot)
    }
}
