// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotUpdateAvailableView: View {
    @ObservedObject private var robot: RobotPeripheralViewModel
    @StateObject private var requirementsViewModel: RequirementsViewModel

    init(robot: RobotPeripheralViewModel) {
        self._robot = ObservedObject(wrappedValue: robot)
        self._requirementsViewModel = StateObject(wrappedValue: RequirementsViewModel(robot: robot))
    }

    var body: some View {
        VStack {
            Text("⬆️ Une mise à jour est disponible 📦")
                .font(.title3)
            NavigationLink {
                UpdateStatusView(robot: robot)
            } label: {
                Text("Lancer la mise à jour du robot")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
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
    @StateObject static var robotIsReady = RobotPeripheralViewModel(battery: 100, isCharging: true)
    @StateObject static var robotIsNotReady = RobotPeripheralViewModel(battery: 0, isCharging: false)

    static var previews: some View {
        RobotUpdateAvailableView(robot: robotIsReady)
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        RobotUpdateAvailableView(robot: robotIsNotReady)
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
