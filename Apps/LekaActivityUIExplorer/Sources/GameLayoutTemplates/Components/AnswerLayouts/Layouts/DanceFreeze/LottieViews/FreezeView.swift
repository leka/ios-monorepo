// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum FreezingStage {
    case transition
    case freeze
}

struct FreezeView: View {
    @State var stage: FreezingStage = .transition

    var body: some View {
        switch stage {
            case .transition:
                LottieView(
                    name: "freeze-transition", speed: 0.5,
                    action: {
                        stage = .freeze
                    }
                )
            case .freeze:
                LottieView(
                    name: "freeze", speed: 0.5,
                    loopMode: .loop
                )
        }
    }
}

struct FreezeView_Previews: PreviewProvider {
    static var previews: some View {
        FreezeView()
    }
}
