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
            LazyVGrid(columns: self.columns, spacing: self.kVerticalSpacing) {
                ForEach(self.colors, id: \.screen) { color in
                    ColorButton(color: color, isPressed: self.selectedColor?.screen == color.screen)
                        .onTapGesture {
                            self.selectedColor = color
                            Robot.shared.shine(.all(in: color))
                        }
                }
            }
            .padding()
        }

        // MARK: Private

        private let colors: [Robot.Color] = [.black, .red, .blue, .green, .yellow, .purple, .orange, .pink]
        private let columns = Array(repeating: GridItem(), count: 4)
        private let kVerticalSpacing: CGFloat = 60
        private let kButtonSize: CGFloat = 200
        @State private var selectedColor: Robot.Color?
    }

    struct ColorButton: View {
        // MARK: Internal

        let color: Robot.Color
        let isPressed: Bool

        var body: some View {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: self.kButtonSize, height: self.kButtonSize)
                    .shadow(color: self.color.screen, radius: self.isPressed ? 20 : 0)
                    .animation(.easeIn(duration: 0.2), value: self.isPressed)

                Circle()
                    .stroke(self.color.screen, lineWidth: 8)
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

        private let kVerticalSpacing: CGFloat = 60
        private let kButtonSize: CGFloat = 200
    }
}

#Preview {
    Gamepad.ColorPadView()
}
