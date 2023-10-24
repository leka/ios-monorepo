// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

class ActivitySequenceManager {
    private let activity: Activity

    var currentSequenceIndex: Int = 0
    var currentExerciseIndexInSequence: Int = 0

    init(activity: Activity) {
        self.activity = activity
    }

    var totalSequences: Int {
        activity.sequence.count
    }

    var totalExercisesInCurrentSequence: Int {
        activity.sequence[currentSequenceIndex].exercises.count
    }

    var currentExercise: Exercise {
        activity.sequence[currentSequenceIndex].exercises[currentExerciseIndexInSequence]
    }

    var isFirstExercise: Bool {
        currentExerciseIndexInSequence == 0 && currentSequenceIndex == 0
    }

    var isLastExercise: Bool {
        currentExerciseIndexInSequence == activity.sequence[currentSequenceIndex].exercises.count - 1
            && currentSequenceIndex == activity.sequence.count - 1
    }

    func moveToNextExercise() {
        if currentExerciseIndexInSequence < activity.sequence[currentSequenceIndex].exercises.count - 1 {
            currentExerciseIndexInSequence += 1
        } else if currentSequenceIndex < activity.sequence.count - 1 {
            currentSequenceIndex += 1
            currentExerciseIndexInSequence = 0
        }
    }

    func moveToPreviousExercise() {
        if currentExerciseIndexInSequence > 0 {
            currentExerciseIndexInSequence -= 1
        } else if currentSequenceIndex > 0 {
            currentSequenceIndex -= 1
            currentExerciseIndexInSequence = activity.sequence[currentSequenceIndex].exercises.count - 1
        }
    }

}
