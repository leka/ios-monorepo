// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension Gamepad {
    struct ColorPadView: View {
        // MARK: Internal

        var body: some View {
            VStack(spacing: 50) {
                LazyVGrid(columns: self.columns, spacing: self.kHorizontalSpacing) {
                    ForEach(self.colors, id: \.screen) { color in
                        ColorLekaButtonLabel(color: color, isPressed: self.selectedColor?.screen == color.screen)
                            .onTapGesture {
                                if self.selectedColor?.screen == color.screen {
                                    self.selectedColor = nil
                                    Robot.shared.blacken(.all)
                                } else {
                                    self.selectedColor = color
                                    Robot.shared.shine(.all(in: color))
                                }
                            }
                            .onChange(of: self.reinforcerTriggered) { _ in
                                if self.reinforcerTriggered {
                                    self.selectedColor = nil
                                    Robot.shared.blacken(.all)
                                    self.reinforcerTriggered = false
                                }
                            }
                    }
                }

                ReinforcerBarButton(onReinforcerTriggerCallback: { self.reinforcerTriggered = true })
            }
            .padding(.horizontal)
        }

        // MARK: Private

        private let colors: [Robot.Color] = [.white, .red, .blue, .green, .yellow, .purple, .orange, .pink]
        private let columns = Array(repeating: GridItem(), count: 4)
        private let kHorizontalSpacing: CGFloat = 20
        @State private var selectedColor: Robot.Color?
        @State private var reinforcerTriggered: Bool = false
    }
}

#Preview {
    Gamepad.ColorPadView()
}
