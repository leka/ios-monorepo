// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotUpdateAvailableView: View {
    @ObservedObject private var robotManager: RobotManager
    @StateObject private var requirementsViewModel: RequirementsViewModel

    init(robotManager: RobotManager) {
        self._robotManager = ObservedObject(wrappedValue: robotManager)
        self._requirementsViewModel = StateObject(wrappedValue: RequirementsViewModel(robotManager: robotManager))
    }

    var body: some View {
        VStack {
            Text("⬆️ Une mise à jour est disponible 📦")
                .font(.title3)
            NavigationLink {
                UpdateStatusView(robotManager: robotManager)
            } label: {
                Text("Lancer la mise à jour du robot")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
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
    @StateObject static var robotIsReady = RobotManager(battery: 100, isCharging: true)
    @StateObject static var robotIsNotReady = RobotManager(battery: 0, isCharging: false)

    static var previews: some View {
        RobotUpdateAvailableView(robotManager: robotIsReady)
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        RobotUpdateAvailableView(robotManager: robotIsNotReady)
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
