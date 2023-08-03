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
        RobotInformationView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
