// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public class ActivitySequenceManagerDeprecated {
    // MARK: Lifecycle

    public init(activity: ActivityDeprecated) {
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
        self.activity.sequence.count
    }

    public var totalExercisesInCurrentSequence: Int {
        self.activity.sequence[self.currentSequenceIndex].exercises.count
    }

    public var currentExercise: Exercise {
        self.activity.sequence[self.currentSequenceIndex].exercises[self.currentExerciseIndexInSequence]
    }

    public var isFirstExercise: Bool {
        self.currentExerciseIndexInSequence == 0 && self.currentSequenceIndex == 0
    }

    public var isLastExercise: Bool {
        self.currentExerciseIndexInSequence == self.activity.sequence[self.currentSequenceIndex].exercises.count - 1
            && self.currentSequenceIndex == self.activity.sequence.count - 1
    }

    public func moveToNextExercise() {
        if self.currentExerciseIndexInSequence < self.activity.sequence[self.currentSequenceIndex].exercises.count - 1 {
            self.currentExerciseIndexInSequence += 1
        } else if self.currentSequenceIndex < self.activity.sequence.count - 1 {
            self.currentSequenceIndex += 1
            self.currentExerciseIndexInSequence = 0
        }
    }

    public func moveToPreviousExercise() {
        if self.currentExerciseIndexInSequence > 0 {
            self.currentExerciseIndexInSequence -= 1
        } else if self.currentSequenceIndex > 0 {
            self.currentSequenceIndex -= 1
            self.currentExerciseIndexInSequence = self.activity.sequence[self.currentSequenceIndex].exercises.count - 1
        }
    }

    // MARK: Private

    private let activity: ActivityDeprecated
}
