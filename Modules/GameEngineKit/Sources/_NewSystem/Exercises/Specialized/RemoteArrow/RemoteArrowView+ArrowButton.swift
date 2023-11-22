// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// swiftlint:disable identifier_name nesting

extension RemoteArrowView {

    struct ArrowButton: View {

        enum Arrow {
            case up, clockwise, down, counterclockwise

            var name: String {
                switch self {
                    case .up:
                        return "arrow.up"
                    case .clockwise:
                        return "arrow.clockwise"
                    case .down:
                        return "arrow.down"
                    case .counterclockwise:
                        return "arrow.counterclockwise"
                }
            }

            var color: Robot.Color {
                switch self {
                    case .up:
                        return .blue
                    case .clockwise:
                        return .red
                    case .down:
                        return .green
                    case .counterclockwise:
                        return .yellow
                }
            }
        }

        @State private var isPressed = false

        let arrow: Arrow
        let onChanged: () -> Void
        let onReleased: () -> Void

        var body: some View {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)
                .overlay {
                    Image(systemName: arrow.name)
                        .resizable()
                        .foregroundColor(arrow.color.screen)
                        .frame(width: 80, height: 100)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            onChanged()
                            isPressed = true
                        }
                        .onEnded { _ in
                            onReleased()
                            isPressed = false
                        }
                )
        }
    }

}

#Preview {
    RemoteArrowView.ArrowButton(arrow: .counterclockwise) {
        print("Button pressed")
    } onReleased: {
        print("Button released")
    }
}

// swiftlint:enable identifier_name nesting
