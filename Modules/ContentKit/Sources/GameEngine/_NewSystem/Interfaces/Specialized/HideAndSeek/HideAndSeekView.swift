// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HideAndSeekView: View {
    // MARK: Lifecycle

    public init() {
        self.stage = .toHide
        self.shared = ExerciseSharedData()
    }

    init(exercise _: Exercise, data: ExerciseSharedData? = nil) {
        self.stage = .toHide
        self.shared = data
    }

    // MARK: Public

    public var body: some View {
        switch self.stage {
            case .toHide:
                Launcher(stage: self.$stage)
            case .hidden:
                Player(stage: self.$stage, shared: self.shared)
        }
    }

    // MARK: Internal

    enum HideAndSeekStage {
        case toHide
        case hidden
    }

    let shared: ExerciseSharedData?

    // MARK: Private

    @State private var stage: HideAndSeekStage
}
