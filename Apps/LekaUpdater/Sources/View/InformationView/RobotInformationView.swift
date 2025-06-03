// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI
import Version

// MARK: - RobotInformationView

struct RobotInformationView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            Text(l10n.information.robot.serialNumber(self.viewModel.robotSerialNumber))
            Divider()
            Text(l10n.information.robot.battery(self.viewModel.robotBattery))
            Divider()
            Text(l10n.information.robot.version(self.viewModel.robotOsVersion))
            Divider()
            Text(l10n.information.robot.isCharging(self.viewModel.robotIsCharging))
        }
        .padding()
    }

    // MARK: Private

    @State private var viewModel = RobotInformationViewModel()
}

// MARK: - RobotInformationView_Previews

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
                        Robot.shared.osVersion.send(Version(1, 0, 0))
                        Robot.shared.isCharging.send(false)
                    case 2:
                        print("Robot connected")
                        Robot.shared.serialNumber.send("LK-2206DHQFLQJZ139813JJQ - connected")
                        Robot.shared.battery.send(Int.random(in: 0...100))
                        Robot.shared.osVersion.send(Version(1, 0, 0))
                        Robot.shared.isCharging.send(true)
                    default:
                        print("Robot not connected")
                        Robot.shared.serialNumber.send("(n/a)")
                        Robot.shared.battery.send(0)
                        Robot.shared.osVersion.send(nil)
                        Robot.shared.isCharging.send(false)
                }
            }
        }
        .environment(\.locale, .init(identifier: "fr"))
    }
}
