// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Arrow {
    case up, right, down, left

    func name() -> String {
        switch self {
            case .up:
                return "arrow.up"
            case .right:
                return "arrow.clockwise"
            case .down:
                return "arrow.down"
            case .left:
                return "arrow.counterclockwise"
        }
    }

    func color() -> Color {
        switch self {
            case .up:
                return .blue
            case .right:
                return .red
            case .down:
                return .green
            case .left:
                return .yellow
        }
    }
}
// swiftlint:enable identifier_name

struct ArrowButton: View {
    var arrow: Arrow

    var body: some View {
        Button {
            switch arrow {
                case .up:
                    // TODO(@ladislas): Go forward
                    print("Go forward")
                case .right:
                    // TODO(@ladislas): Turn right
                    print("Turn right")
                case .down:
                    // TODO(@ladislas): Go backward
                    print("Go backward")
                case .left:
                    // TODO(@ladislas): Turn left
                    print("Turn left")
            }
            // TODO(@ladislas): Lights up Leka in "arrow.color()"
            print("Show \(arrow.color())")
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)
                .overlay {
                    Image(systemName: arrow.name())
                        .resizable()
                        .foregroundColor(arrow.color())
                        .frame(width: 80, height: 100)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
        }
    }
}

struct ArrowButtonView_Previews:
    PreviewProvider
{
    static var previews: some View {
        ArrowButton(arrow: .up)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
