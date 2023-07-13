// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum DanceFreezeStage {
    case waitingForSelection
    case automaticMode
    case manualMode
}

struct DanceFreezeLauncher: View {
    @State private var mode = DanceFreezeStage.waitingForSelection

    var body: some View {
        switch mode {
            case .waitingForSelection:
                DanceFreezeSelector(mode: $mode)
                    .robotNeededAlert()
            case .automaticMode:
                DanceFreezePlayer(isAuto: true)
            case .manualMode:
                DanceFreezePlayer(isAuto: false)
        }
    }
}

struct DanceFreezeLauncher_Previews: PreviewProvider {
    static var previews: some View {
        DanceFreezeLauncher()
            .environmentObject(GameLayoutTemplatesDefaults())
    }
}
