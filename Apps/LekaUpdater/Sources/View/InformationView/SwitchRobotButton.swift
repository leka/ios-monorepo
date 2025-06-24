// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - SwitchRobotButton

struct SwitchRobotButton: View {
    let isRobotConnected: Bool
    @Binding var isConnectionViewPresented: Bool

    var body: some View {
        Button {
            self.isConnectionViewPresented = true
            if self.isRobotConnected {
                BLEManager.shared.disconnect()
            }
        } label: {
            Text(self.isRobotConnected ? l10n.connection.anotherRobot : l10n.connection.newRobot)
                .foregroundColor(.white)
                .font(.title2)
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
                .background(.green)
                .clipShape(Capsule())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SwitchRobotButton_Previews

#Preview {
    VStack(spacing: 100) {
        SwitchRobotButton(isRobotConnected: false, isConnectionViewPresented: .constant(false))
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)

        SwitchRobotButton(isRobotConnected: true, isConnectionViewPresented: .constant(false))
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
