// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RequirementsView: View {
    @StateObject var viewModel: RequirementsViewModel

    var body: some View {
        HStack {
            viewModel.batteryImage
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .padding()
                .foregroundColor(viewModel.batteryForegroundColor)

            Image(systemName: "powerplug.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .padding()
                .foregroundColor(viewModel.isChargingForegroundColor)
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
