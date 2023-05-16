// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotUpdateAvailableView: View {
    @ObservedObject private var robot: DummyRobotModel

    var robotIsNotReadyToUpdate: Bool {
        !(robot.battery >= 30 && robot.isCharging)
    }

    init(robot: DummyRobotModel) {
        self._robot = ObservedObject(wrappedValue: robot)
    }

    var body: some View {
        HStack {
            RequirementsView(robot: robot)

            Button("MAJ", action: robot.startUpdate)
                .padding()
                .foregroundColor(.black)
                .background(.cyan)
                .cornerRadius(.infinity)
                .disabled(robotIsNotReadyToUpdate)
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
