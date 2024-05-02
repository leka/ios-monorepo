// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// swiftlint:disable identifier_name nesting

extension ArrowPadView {
    struct ArrowButton: View {
        enum Arrow {
            case up
            case clockwise
            case down
            case counterclockwise

            // MARK: Internal

            var name: String {
                switch self {
                    case .up:
                        "arrow.up"
                    case .clockwise:
                        "arrow.clockwise"
                    case .down:
                        "arrow.down"
                    case .counterclockwise:
                        "arrow.counterclockwise"
                }
            }

            var color: Robot.Color {
                switch self {
                    case .up:
                        .blue
                    case .clockwise:
                        .red
                    case .down:
                        .green
                    case .counterclockwise:
                        .yellow
                }
            }
        }

        @State private var isPressed = false

        let arrow: Arrow
        let size: CGFloat
        let onChanged: () -> Void
        let onReleased: () -> Void

        var body: some View {
            Circle()
                .fill(.white)
                .frame(width: self.size, height: self.size)
                .overlay {
                    Image(systemName: self.arrow.name)
                        .resizable()
                        .foregroundColor(self.arrow.color.screen)
                        .frame(width: self.size / 2.5, height: self.size / 2)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                .scaleEffect(self.isPressed ? 0.95 : 1.0)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            self.onChanged()
                            self.isPressed = true
                        }
                        .onEnded { _ in
                            self.onReleased()
                            self.isPressed = false
                        }
                )
        }
    }
}

#Preview {
    ArrowPadView.ArrowButton(arrow: .counterclockwise, size: 200) {
        print("Button pressed")
    } onReleased: {
        print("Button released")
    }
}

// swiftlint:enable identifier_name nesting
