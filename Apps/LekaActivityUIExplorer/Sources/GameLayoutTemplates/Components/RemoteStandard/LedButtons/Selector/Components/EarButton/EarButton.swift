// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct EarButton: View {
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
            .animation(.easeIn(duration: 0.2), value: backgroundDimension)
    }
}

struct EarButton_Previews: PreviewProvider {
    static var previews: some View {
        EarButton(color: .red)
    }
}
