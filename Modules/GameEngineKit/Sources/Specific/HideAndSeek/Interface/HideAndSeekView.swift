// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum HideAndSeekStage {
    case toHide
    case hidden
}

public struct HideAndSeekView: View {
    @State private var stage: HideAndSeekStage

    public init() {
        self.stage = .toHide
    }

    public var body: some View {
        switch stage {
            case .toHide:
                HideAndSeekLauncher(stage: $stage)
            case .hidden:
                HideAndSeekPlayer(stage: $stage)
        }
    }
}
