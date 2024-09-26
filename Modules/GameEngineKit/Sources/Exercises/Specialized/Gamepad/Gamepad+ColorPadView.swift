// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

extension Gamepad {
    struct ColorPadView: View {
        // MARK: Internal

        var body: some View {
            VStack(spacing: 50) {
                LazyVGrid(columns: self.columns, spacing: self.kHorizontalSpacing) {
                    ForEach(self.colors, id: \.screen) { color in
                        ColorButtonLabel(color: color, isPressed: self.selectedColor?.screen == color.screen)
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

                HStack {
                    ForEach(Robot.Reinforcer.allCases, id: \.self) { reinforcer in
                        reinforcer.icon()
                            .resizable()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .onTapGesture {
                                self.reinforcerTriggered = true
                                Robot.shared.run(reinforcer)
                            }
                    }
                }
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

    struct ColorButtonLabel: View {
        // MARK: Internal

        let color: Robot.Color
        let isPressed: Bool

        var body: some View {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: self.kButtonSize, height: self.kButtonSize)
                    .shadow(color: self.color.screen != .white ? self.color.screen : .gray.opacity(0.6), radius: self.isPressed ? 20 : 0)
                    .animation(.easeIn(duration: 0.2), value: self.isPressed)

                Circle()
                    .stroke(self.color.screen != .white ? self.color.screen : .gray.opacity(0.3), lineWidth: 8)
                    .frame(width: self.kButtonSize, height: self.kButtonSize)

                HStack(spacing: 30) {
                    Circle()
                        .fill(.black)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(.black)
                        .frame(width: 20, height: 20)
                }
            }
        }

        // MARK: Private

        private let kButtonSize: CGFloat = 190
    }
}

#Preview {
    Gamepad.ColorPadView()
}
