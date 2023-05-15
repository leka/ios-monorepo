// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DisplayModeButton: View {
    var mode: DisplayMode
    @Binding var displayMode: DisplayMode

    @State private var buttonPressed = false

    var body: some View {
        Button {
            displayMode = mode
        } label: {
            switch mode {
                case .fullBelt:
                    FullBeltIcon()
                case .twoHalves:
                    TwoHalvesIcon()
                case .fourQuarters:
                    FourQuartersIcon()
            }
        }
        .background(DisplayModelFeedback(backgroundDimension: displayMode == mode ? 80 : 0))
    }
}

struct DisplayModeButton_Previews: PreviewProvider {

    static var previews: some View {
        DisplayModeButton(mode: .fullBelt, displayMode: .constant(.fullBelt))
    }
}
