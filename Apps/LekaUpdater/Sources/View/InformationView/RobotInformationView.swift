// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
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
                        Robot.shared.serialNumber.send("(n/a)")
                        Robot.shared.battery.send(Int.random(in: 0...100))
                        Robot.shared.osVersion.send("1.0.0")
                        Robot.shared.isCharging.send(false)
                    case 2:
                        print("Robot connected")
                        Robot.shared.serialNumber.send("LK-2206DHQFLQJZ139813JJQ - connected")
                        Robot.shared.battery.send(Int.random(in: 0...100))
                        Robot.shared.osVersion.send("1.0.0")
                        Robot.shared.isCharging.send(true)
                    default:
                        print("Robot not connected")
                        Robot.shared.serialNumber.send("(n/a)")
                        Robot.shared.battery.send(0)
                        Robot.shared.osVersion.send("(n/a)")
                        Robot.shared.isCharging.send(false)
                }
            }
        }
        .environment(\.locale, .init(identifier: "fr"))
    }
}
