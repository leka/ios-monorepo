// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum DanceFreezeStage {
    case waitingForSelection
    case automaticMode
    case manualMode
}

public struct DanceFreezeView: View {
    @State private var mode = DanceFreezeStage.waitingForSelection

    public var body: some View {
            switch mode {
                case .waitingForSelection:
                    DanceFreezeLauncher(mode: $mode)
                        .alertWhenRobotIsNeeded()
                case .automaticMode:
                    DanceFreezePlayer(isAuto: true)
                case .manualMode:
                    DanceFreezePlayer(isAuto: false)
    }
}
