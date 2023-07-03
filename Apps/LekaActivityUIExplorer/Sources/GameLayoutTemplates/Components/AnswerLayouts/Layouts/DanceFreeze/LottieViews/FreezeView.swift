// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FreezeView: View {
    @State var isFreezing: Bool = false

    var body: some View {
        if isFreezing {
            LottieView(
                name: "freeze", speed: 0.5,
                loopMode: .loop,
                play: $isFreezing
            )
        } else {
            LottieView(
                name: "freeze-transition", speed: 0.5,
                action: {
                    isFreezing.toggle()
                }
            )
        }
    }
}

struct FreezeView_Previews: PreviewProvider {
    static var previews: some View {
        FreezeView()
    }
}
