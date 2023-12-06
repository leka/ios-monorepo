// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

struct ConnectedRobotInformationView: View {
    @StateObject var viewModel: ConnectedRobotInformationViewModel = ConnectedRobotInformationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Connected Robot Information")
                .font(.title2)
                .underline()

            Grid(alignment: .leading, horizontalSpacing: 100) {
                GridRow {
                    Text("Name:")
                    Text(viewModel.name)
                }
                GridRow {
                    Text("S/N:")
                    Text(viewModel.serialNumber)
                }
                GridRow {
                    Text("LekaOS:")
                    Text(viewModel.osVersion)
                }
                GridRow {
                    Text("Battery:")
                    Text("\(viewModel.battery)%")
                }
                GridRow {
                    Text("Charging:")
                    Text(viewModel.isCharging ? "yes" : "no")
                }
            }
        }
    }
}

#Preview {
    ConnectedRobotInformationView()
}
