// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotInformationView: View {
    @StateObject private var viewModel = RobotInformationViewModel()

    var body: some View {
        List {
            Text("N° série: \(viewModel.robotSerialNumber)")
            Text("Battery: \(viewModel.robotBattery)")
            Text("Version: \(viewModel.robotOsVersion)")
        }
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
                        globalRobotManager.osVersion = "1.0.0"
                    case 2:
                        print("Robot connected")
                        globalRobotManager.serialNumber = "LK-2206..."
                        globalRobotManager.battery = Int.random(in: 0...100)
                        globalRobotManager.osVersion = "1.0.0"
                    default:
                        print("Robot not connected")
                        globalRobotManager.serialNumber = nil
                        globalRobotManager.battery = nil
                        globalRobotManager.osVersion = nil
                }
            }
        }
    }
}
