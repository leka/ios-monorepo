// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RequirementsView: View {
    @StateObject var viewModel: RequirementsViewModel

    var body: some View {
        HStack {
            VStack {
                viewModel.batteryImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(viewModel.batteryForegroundColor)
                Text("Min. 30% de batteries")
                    .bold()
                    .foregroundColor(viewModel.batteryForegroundColor)
            }

            VStack {
                viewModel.chargingImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(viewModel.isChargingForegroundColor)
                Text("Robot branché sur le secteur")
                    .bold()
                    .foregroundColor(viewModel.isChargingForegroundColor)
            }
        }
    }
}

struct RequirementsView_Previews: PreviewProvider {
    @StateObject static var robot = DummyRobotModel()
    @StateObject static var viewModel = RequirementsViewModel(robot: robot)

    static var previews: some View {
        RequirementsView(viewModel: viewModel)
    }
}
