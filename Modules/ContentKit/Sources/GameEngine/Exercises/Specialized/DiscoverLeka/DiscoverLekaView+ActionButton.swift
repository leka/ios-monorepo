// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - Action

extension DiscoverLekaView {
    struct ActionButton: View {
        // MARK: Lifecycle

        init(_ actionType: ActionType, text: String, hasStarted: Bool = false, action: @escaping () -> Void) {
            self.actionType = actionType
            self.text = text
            self.hasStarted = hasStarted
            self.action = action
        }

        // MARK: Internal

        let actionType: ActionType
        let text: String
        let hasStarted: Bool
        let action: () -> Void

        var body: some View {
            VStack {
                Button {
                    self.action()
                } label: {
                    self.actionType.icon(self.hasStarted)
                }

                .background(
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.5), radius: 7, x: 0, y: 4)
                )

                Text(self.text)
                    .font(.body)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    DiscoverLekaView.ActionButton(.stop, text: "Stop", hasStarted: true) {
        print("Button tapped !")
    }
}
