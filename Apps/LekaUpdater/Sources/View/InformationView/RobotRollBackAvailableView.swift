// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - RobotRollBackAvailableView

struct RobotRollBackAvailableView: View {
    @State private var requirementsViewModel = RequirementsViewModel()

    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            Button {
                globalFirmwareManager.currentVersion = .init(tolerant: "1.4")!
                self.isUpdateStatusViewPresented = true
            } label: {
                Text(l10n.information.status.robotRollBackAvailable)
                    .font(.title3)
                    .padding(.bottom)
                    .underline()
            }
            .opacity(self.requirementsViewModel.robotIsNotReadyToUpdate ? 0.4 : 1)
            .disabled(self.requirementsViewModel.robotIsNotReadyToUpdate)

            if !self.requirementsViewModel.robotIsReadyToUpdate {
                RequirementsView(viewModel: self.requirementsViewModel)
            }
        }
    }
}

// MARK: - RobotRollBackAvailableView_Previews

#Preview {
    VStack {
        RobotRollBackAvailableView(isUpdateStatusViewPresented: .constant(false))
    }
}
