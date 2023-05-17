// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotUpdateAvailableView: View {
    @ObservedObject private var robot: DummyRobotModel
    @StateObject private var requirementsViewModel: RequirementsViewModel

    init(robot: DummyRobotModel) {
        self._robot = ObservedObject(wrappedValue: robot)
        self._requirementsViewModel = StateObject(wrappedValue: RequirementsViewModel(robot: robot))
    }

    var body: some View {
        HStack {
            RequirementsView(viewModel: requirementsViewModel)
                .opacity(requirementsViewModel.robotIsReadyToUpdate ? 0.0 : 1.0)

            Button("Mettre à niveau maintenant", action: robot.startUpdate)
                .buttonStyle(.borderedProminent)
                .disabled(requirementsViewModel.robotIsNotReadyToUpdate)
        }
        .padding()
    }
}

struct RobotUpdateAvailableView_Previews: PreviewProvider {
    @StateObject static var robot = DummyRobotModel()

    static var previews: some View {
        RobotUpdateAvailableView(robot: robot)
    }
}
