// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct HideAndSeekView: View {
    // MARK: Lifecycle

    public init(instructions: HideAndSeek.Payload.Instructions) {
        self.stage = .toHide
        self.instructions = instructions
        self.shared = ExerciseSharedData()
    }

    init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? HideAndSeek.Payload else {
            fatalError("Exercise payload is not .selection")
        }

        self.instructions = payload.instructions
        self.stage = .toHide
        self.shared = data
    }

    // MARK: Public

    public var body: some View {
        switch self.stage {
            case .toHide:
                Launcher(
                    stage: self.$stage, textMainInstructions: self.instructions.textMainInstructions,
                    textButtonOk: self.instructions.textButtonOk
                )
            case .hidden:
                Player(
                    stage: self.$stage, textSubInstructions: self.instructions.textSubInstructions,
                    textButtonRobotFound: self.instructions.textButtonRobotFound, shared: self.shared
                )
        }
    }

    // MARK: Internal

    enum HideAndSeekStage {
        case toHide
        case hidden
    }

    let instructions: HideAndSeek.Payload.Instructions
    let shared: ExerciseSharedData?

    // MARK: Private

    @State private var stage: HideAndSeekStage
}
