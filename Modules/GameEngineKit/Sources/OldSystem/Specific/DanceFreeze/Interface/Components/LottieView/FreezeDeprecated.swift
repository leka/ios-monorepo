// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct FreezeViewDeprecated: View {
    var body: some View {
        LottieView(
            name: "freeze", speed: 0.5,
            loopMode: .loop
        )
    }
}

struct FreezeViewDeprecated_Previews: PreviewProvider {
    static var previews: some View {
        FreezeViewDeprecated()
    }
}
