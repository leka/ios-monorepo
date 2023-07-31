// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotInformationView: View {
    @ObservedObject var robotManager: RobotManager

    private var robotSerialNumber: String {
        robotManager.serialNumber ?? "n/a"
    }

    private var robotBattery: String {
        guard let robotBattery = robotManager.battery else {
            return "n/a"
        }
        return "\(robotBattery)"
    }

    private var robotOsVersion: String {
        robotManager.osVersion ?? "n/a"
    }

    var body: some View {
        List {
            Text("N° série: \(robotSerialNumber)")
            Text("Battery: \(robotBattery)")
            Text("Version: \(robotOsVersion)")
        }
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static let robotNotConnected = RobotManager()
    static let robotWithoutSerialNumber = RobotManager(battery: 42, osVersion: "1.0.0")
    static let robotWithSerialNumber = RobotManager(
        serialNumber: "LK-2206...", battery: 42, osVersion: "1.0.0")

    static var previews: some View {
        Group {
            RobotInformationView(robotManager: robotNotConnected)
            RobotInformationView(robotManager: robotWithoutSerialNumber)
            RobotInformationView(robotManager: robotWithSerialNumber)
        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
