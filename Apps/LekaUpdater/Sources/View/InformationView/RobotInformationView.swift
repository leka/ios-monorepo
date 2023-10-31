// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import Version

struct RobotInformationView: View {
    @StateObject private var viewModel = RobotInformationViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text(l10n.information.robot.serialNumber(viewModel.robotSerialNumber))
            Divider()
            Text(l10n.information.robot.battery(viewModel.robotBattery))
            Divider()
            Text(l10n.information.robot.version(viewModel.robotOsVersion))
            Divider()
            Text(l10n.information.robot.isCharging(viewModel.robotIsCharging))
        }
        .padding()
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RobotInformationView()
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)

            Button("Change example") {
                let selection = Int.random(in: 1...3)
                switch selection {
                    case 1:
                        print("Robot just connected (not received serial number yet)")
                        globalRobotManager.serialNumber = nil
                        globalRobotManager.battery = Int.random(in: 0...100)
                        globalRobotManager.osVersion = Version(1, 0, 0)
                        globalRobotManager.isCharging = false
                    case 2:
                        print("Robot connected")
                        globalRobotManager.serialNumber = "LK-2206DHQFLQJZ139813JJQ - connected"
                        globalRobotManager.battery = Int.random(in: 0...100)
                        globalRobotManager.osVersion = Version(1, 0, 0)
                        globalRobotManager.isCharging = true
                    default:
                        print("Robot not connected")
                        globalRobotManager.serialNumber = nil
                        globalRobotManager.battery = nil
                        globalRobotManager.osVersion = nil
                        globalRobotManager.isCharging = nil
                }
            }
        }
        .environment(\.locale, .init(identifier: "fr"))
    }
}
