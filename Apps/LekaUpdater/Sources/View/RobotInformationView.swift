// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotInformationView: View {
    @EnvironmentObject var robot: DummyRobotModel

    var body: some View {
        List {
            Text("Nom: \(robot.name)")
            Text("N° série: \(robot.serialNumber)")
            Text("Battery: \(robot.battery)")
            Text("Version: \(robot.osVersion)")
        }
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static let robot = DummyRobotModel()
    static var previews: some View {
        RobotInformationView()
            .environmentObject(robot)
    }
}
