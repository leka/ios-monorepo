// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

public class ExerciseSharedData: ObservableObject {
    // MARK: Lifecycle

    public init(groupIndex: Int, exerciseIndex: Int) {
        self.groupIndex = groupIndex
        self.exerciseIndex = exerciseIndex
    }

    public init() {
        self.exerciseIndex = 0
        self.groupIndex = 0
    }

    // MARK: Internal

    // TODO: (@HPezz): Add state setter function, and makes it private
    @Published var state: ExerciseState = .idle

    let groupIndex: Int
    let exerciseIndex: Int

    var completionLevel: ExerciseState.CompletionLevel? {
        guard case let .completed(level) = state else { return nil }
        return level
    }

    var isCompleted: Bool {
        self.state.isCompleted
    }

    var isExerciseNotYetCompleted: Bool {
        switch self.state {
            case .completed:
                false
            default:
                true
        }
    }
}
