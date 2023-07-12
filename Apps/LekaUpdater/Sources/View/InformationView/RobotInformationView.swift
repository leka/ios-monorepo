// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotInformationView: View {
    @EnvironmentObject var robot: RobotPeripheralViewModel

    var body: some View {
        List {
            Text("N° série: \(robot.serialNumber ?? "(n/a)")")
            Text("Battery: \(robot.battery)")
            Text("Version: \(robot.osVersion)")
        }
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static let robotWithoutSerialNumber = RobotPeripheralViewModel()
    static let robotWithSerialNumber = RobotPeripheralViewModel(serialNumber: "LK-2206...")

    static var previews: some View {
        RobotInformationView()
            .environmentObject(robotWithoutSerialNumber)
        RobotInformationView()
            .environmentObject(robotWithSerialNumber)
    }
}
