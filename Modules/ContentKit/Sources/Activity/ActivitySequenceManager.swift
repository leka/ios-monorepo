// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public class ActivitySequenceManager {
    // MARK: Lifecycle

    public init(activity: Activity) {
        var localActivity = activity

        if localActivity.shuffleExercises {
            localActivity.sequence = localActivity.sequence.map { sequence in
                Exercise.Sequence(exercises: sequence.exercises.shuffled())
            }
        }

        if localActivity.shuffleSequences {
            localActivity.sequence.shuffle()
        }

        self.activity = localActivity
    }

    // MARK: Public

    public var currentSequenceIndex: Int = 0
    public var currentExerciseIndexInSequence: Int = 0

    public var totalSequences: Int {
        activity.sequence.count
    }

    public var totalExercisesInCurrentSequence: Int {
        activity.sequence[currentSequenceIndex].exercises.count
    }

    public var currentExercise: Exercise {
        activity.sequence[currentSequenceIndex].exercises[currentExerciseIndexInSequence]
    }

    public var isFirstExercise: Bool {
        currentExerciseIndexInSequence == 0 && currentSequenceIndex == 0
    }

    public var isLastExercise: Bool {
        currentExerciseIndexInSequence == activity.sequence[currentSequenceIndex].exercises.count - 1
            && currentSequenceIndex == activity.sequence.count - 1
    }

    public func moveToNextExercise() {
        if currentExerciseIndexInSequence < activity.sequence[currentSequenceIndex].exercises.count - 1 {
            currentExerciseIndexInSequence += 1
        } else if currentSequenceIndex < activity.sequence.count - 1 {
            currentSequenceIndex += 1
            currentExerciseIndexInSequence = 0
        }
    }

    public func moveToPreviousExercise() {
        if currentExerciseIndexInSequence > 0 {
            currentExerciseIndexInSequence -= 1
        } else if currentSequenceIndex > 0 {
            currentSequenceIndex -= 1
            currentExerciseIndexInSequence = activity.sequence[currentSequenceIndex].exercises.count - 1
        }
    }

    // MARK: Private

    private let activity: Activity
}
