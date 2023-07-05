// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceView: View {
    var body: some View {
        LottieView(
            name: "dance", speed: 0.5,
            loopMode: .loop
        )
    }
}

struct DanceView_Previews: PreviewProvider {
    static var previews: some View {
        DanceView()
    }
}
