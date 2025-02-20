// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - Action

extension ColorCoachView {
    struct ActionButton: View {
        // MARK: Lifecycle

        init(_ actionType: ActionType, text: String, isPlaying: Bool = false, action: @escaping () -> Void) {
            self.actionType = actionType
            self.text = text
            self.isPlaying = isPlaying
            self.action = action
        }

        // MARK: Internal

        let actionType: ActionType
        let text: String
        let isPlaying: Bool
        let action: () -> Void

        var body: some View {
            VStack(spacing: 5) {
                Button {
                    self.action()
                } label: {
                    self.actionType.icon(self.isPlaying)
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
    HStack(spacing: 50) {
        ColorCoachView.ActionButton(.start, text: "Play", isPlaying: true) {
            print("Button Play tapped !")
        }

        ColorCoachView.ActionButton(.next, text: "Next", isPlaying: true) {
            print("Button Next tapped !")
        }

        ColorCoachView.ActionButton(.stop, text: "Stop", isPlaying: false) {
            print("Button Stop tapped !")
        }
    }
}
