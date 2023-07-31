// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotInformationView: View {
    @EnvironmentObject var robotManager: RobotManager

    var body: some View {
        List {
            Text("N° série: \(robotManager.serialNumber ?? "(n/a)")")
            Text("Battery: \(robotManager.battery)")
            Text("Version: \(robotManager.osVersion)")
        }
    }
}

struct RobotInformationView_Previews: PreviewProvider {
    static let robotWithoutSerialNumber = RobotManager()
    static let robotWithSerialNumber = RobotManager(serialNumber: "LK-2206...")

    static var previews: some View {
        RobotInformationView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .environmentObject(robotWithoutSerialNumber)
        RobotInformationView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .environmentObject(robotWithSerialNumber)
    }
}
