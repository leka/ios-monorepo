// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RequirementsView: View {
    @StateObject var viewModel: RequirementsViewModel

    var body: some View {
        VStack {
            viewModel.requirementsImage
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text(
                """
                Le robot doit être en charge sur sa base
                Sa batterie doit être chargée à 30% ou plus.
                """
            )
            .multilineTextAlignment(.center)
            .foregroundColor(.red)
        }
    }
}

struct RequirementsView_Previews: PreviewProvider {
    static var robot = RobotPeripheralViewModel()
    @StateObject static var viewModel = RequirementsViewModel(robot: robot)

    static var previews: some View {
        RequirementsView(viewModel: viewModel)
    }
}
