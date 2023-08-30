// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotUpdateAvailableView: View {
    @StateObject private var requirementsViewModel = RequirementsViewModel()

    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            Text("⬆️ Une mise à jour est disponible 📦")
                .font(.title3)
                .padding([.bottom])

            Button {
                isUpdateStatusViewPresented = true
            } label: {
                Text("Lancer la mise à jour du robot")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding([.horizontal], 50)
                    .padding([.vertical], 30)
                    .background(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
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
    @State static var isUpdateStatusViewPresented = false

    static var previews: some View {
        VStack {
            Spacer()

            RobotUpdateAvailableView(isUpdateStatusViewPresented: $isUpdateStatusViewPresented)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)

            Spacer()

            Button("Change example") {
                let isReady = Bool.random()

                if isReady {
                    print("Robot is ready to update")
                    globalRobotManager.battery = 100
                    globalRobotManager.isCharging = true
                } else {
                    print("Robot is NOT ready to update")
                    globalRobotManager.battery = 0
                    globalRobotManager.isCharging = false
                }
            }
        }
    }
}
