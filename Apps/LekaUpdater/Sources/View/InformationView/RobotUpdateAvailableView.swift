// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - RobotUpdateAvailableView

struct RobotUpdateAvailableView: View {
    @State private var requirementsViewModel = RequirementsViewModel()

    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            Button {
                self.isUpdateStatusViewPresented = true
            } label: {
                Text(l10n.information.startUpdateButton)
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding([.horizontal], 50)
                    .padding([.vertical], 30)
                    .background(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .disabled(self.requirementsViewModel.robotIsNotReadyToUpdate)

            if !self.requirementsViewModel.robotIsReadyToUpdate {
                RequirementsView(viewModel: self.requirementsViewModel)
            }
        }
    }
}

// MARK: - RobotUpdateAvailableView_Previews

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
                    Robot.shared.battery.send(100)
                    Robot.shared.isCharging.send(true)
                } else {
                    print("Robot is NOT ready to update")
                    Robot.shared.battery.send(0)
                    Robot.shared.isCharging.send(false)
                }
            }
        }
    }
}
