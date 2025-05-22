// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

struct ConnectedRobotInformationView: View {
    @State var viewModel: ConnectedRobotInformationViewModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Connected Robot Information")
                .font(.title2)
                .underline()

            Grid(alignment: .leading, horizontalSpacing: 100) {
                GridRow {
                    Text("Name:")
                    Text(self.viewModel.name)
                }
                GridRow {
                    Text("S/N:")
                    Text(self.viewModel.serialNumber)
                }
                GridRow {
                    Text("LekaOS:")
                    Text(self.viewModel.osVersion)
                }
                GridRow {
                    Text("Battery:")
                    Text("\(self.viewModel.battery)%")
                }
                GridRow {
                    Text("Charging:")
                    Text(self.viewModel.isCharging ? "yes" : "no")
                }
            }
        }
    }
}

#Preview {
    ConnectedRobotInformationView()
}
