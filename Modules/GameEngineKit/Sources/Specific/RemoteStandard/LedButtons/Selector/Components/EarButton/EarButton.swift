// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// swiftlint:disable identifier_name
enum Ear {
    case all
    case right, left
}
// swiftlint:enable identifier_name

struct EarButton: View {
    var selectedEar: Ear
    var color: Color

    @State private var buttonPressed = false
    @State private var backgroundDimension = 0

    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 50, height: 50)
            .onTapGesture {
                buttonPressed.toggle()
                if buttonPressed {
                    switch selectedEar {
                        case .all:
                            // TODO(@ladislas): Turn on the two ears in "color"
                            print("All ears are \(color)")
                        case .right:
                            // TODO(@ladislas): Turn on the right ear in "color"
                            print("Right ear is \(color)")
                        case .left:
                            // TODO(@ladislas): Turn on the left ear in "color"
                            print("Left ear is \(color)")
                    }
                } else {
                    switch selectedEar {
                        case .all:
                            // TODO(@ladislas): Turn off the two ears
                            print("All ears are off")
                        case .right:
                            // TODO(@ladislas): Turn off the right ear
                            print("Right ear is off")
                        case .left:
                            // TODO(@ladislas): Turn off the left ear
                            print("Left ear is off")
                    }
                }
                backgroundDimension = buttonPressed ? 65 : 0
            }
            .background(
                EarButtonFeedback(color: color, backgroundDimension: backgroundDimension)
            )
            .animation(.easeInOut(duration: 0.2), value: backgroundDimension)
    }
}

struct EarButton_Previews: PreviewProvider {
    static var previews: some View {
        EarButton(selectedEar: .all, color: .red)
    }
}
