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
//        self.startTimestamp = Date()
    }

    public init() {
        self.exerciseIndex = 0
        self.groupIndex = 0
//        self.startTimestamp = Date()
    }

    // MARK: Internal

    let groupIndex: Int
    let exerciseIndex: Int

    // TODO: (@HPezz): Add state setter function, and makes it private
    @Published var state: ExerciseState = .idle {
        didSet {
            print("ExerciseSharedData: State has been set to \(self.state)")
        }
    }

//    let startTimestamp: Date

    var completionLevel: ExerciseState.CompletionLevel? {
        guard case let .completed(level, _) = state else { return nil }
        return level
    }

//    var inProgressCompletiondata: ExerciseCompletionData? {
//        didSet {
//            print("inProgressCompletiondata:", self.inProgressCompletiondata ?? "empty")
//        }
//    }

    var completionData: ExerciseCompletionData? {
        guard case let .completed(_, data) = state else { return nil }
        return data
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
