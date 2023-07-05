// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FreezeView: View {
    var body: some View {
        LottieView(
            name: "freeze", speed: 0.5,
            loopMode: .loop
        )
    }
}

struct FreezeView_Previews: PreviewProvider {
    static var previews: some View {
        FreezeView()
    }
}
