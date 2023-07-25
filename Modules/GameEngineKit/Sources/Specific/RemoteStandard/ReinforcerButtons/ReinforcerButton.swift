// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ReinforcerButton: View {
    var reinforcer: Reinforcer

    var body: some View {
        Button {
            // Reinforcer has been pressed
        } label: {
            reinforcer.icon()
        }
    }

}

struct ReinforcerButton_Previews:
    PreviewProvider
{
    static var previews: some View {
        ReinforcerButton(reinforcer: .blinkGreen)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
