// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Arrow {
    case forward, right, backward, left

    public var name: String {
        switch self {
            case .forward:
                return "arrow.up"
            case .right:
                return "arrow.clockwise"
            case .backward:
                return "arrow.down"
            case .left:
                return "arrow.counterclockwise"
        }
    }

    public var color: Color {
        switch self {
            case .forward:
                return .blue
            case .right:
                return .red
            case .backward:
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
                case .forward:
                    // TODO(@ladislas): Go forward
                    print("Go forward")
                case .right:
                    // TODO(@ladislas): Turn right
                    print("Turn right")
                case .backward:
                    // TODO(@ladislas): Go backward
                    print("Go backward")
                case .left:
                    // TODO(@ladislas): Turn left
                    print("Turn left")
            }
            // TODO(@ladislas): Lights up Leka in "arrow.color()"
            print("Show \(arrow.color)")
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)
                .overlay {
                    Image(systemName: arrow.name)
                        .resizable()
                        .foregroundColor(arrow.color)
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
        ArrowButton(arrow: .forward)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
