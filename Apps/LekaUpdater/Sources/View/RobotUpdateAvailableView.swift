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
        VStack {
            Text("⬆️ Une mise à jour est disponible 📦")
                .font(.title3)
                .foregroundColor(.gray)
            NavigationLink {
                UpdateStatusView()
            } label: {
                Text("Lancer la mise à jour du robot")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            .onSubmit(robot.startUpdate)
            .buttonStyle(.plain)
            .disabled(requirementsViewModel.robotIsNotReadyToUpdate)

            if !requirementsViewModel.robotIsReadyToUpdate {
                RequirementsView(viewModel: requirementsViewModel)
            }
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
