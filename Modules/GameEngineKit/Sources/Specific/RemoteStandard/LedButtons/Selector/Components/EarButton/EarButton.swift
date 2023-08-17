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
                backgroundDimension = buttonPressed ? 60 : 0
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
