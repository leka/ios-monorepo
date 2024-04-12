// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

public class CurrentActivityManager {
    // MARK: Lifecycle

    public init(activity: Activity) {
        var copyOfActivity = activity

        if copyOfActivity.exercisePayload.options.shuffleExercises {
            copyOfActivity.exercisePayload.exerciseGroups = copyOfActivity.exercisePayload.exerciseGroups.map {
                Activity.ExercisesPayload.ExerciseGroup(exercises: $0.exercises.shuffled())
            }
        }

        if copyOfActivity.exercisePayload.options.shuffleGroups {
            copyOfActivity.exercisePayload.exerciseGroups.shuffle()
        }

        self.activity = copyOfActivity
    }

    // MARK: Public

    public var currentGroupIndex: Int = 0
    public var currentExerciseIndexInCurrentGroup: Int = 0
//    public var exerciseCompletionData: [ExerciseSharedData] = []
    public var activityCompletionData: [ExerciseSharedData] = []

    public let activity: Activity

    public var totalGroups: Int {
        self.activity.exercisePayload.exerciseGroups.count
    }

    public var totalExercisesInCurrentGroup: Int {
        self.activity.exercisePayload.exerciseGroups[self.currentGroupIndex].exercises.count
    }

    public var currentExercise: Exercise {
        self.activity.exercisePayload.exerciseGroups[self.currentGroupIndex].exercises[self.currentExerciseIndexInCurrentGroup]
    }

    public var isFirstExercise: Bool {
        self.currentExerciseIndexInCurrentGroup == 0 && self.currentGroupIndex == 0
    }

    public var isLastExercise: Bool {
        self.currentExerciseIndexInCurrentGroup == self.activity.exercisePayload.exerciseGroups[self.currentGroupIndex].exercises.count - 1
            && self.currentGroupIndex == self.activity.exercisePayload.exerciseGroups.count - 1
    }

    public func moveToNextExercise() {
        if self.currentExerciseIndexInCurrentGroup < self.activity.exercisePayload.exerciseGroups[self.currentGroupIndex].exercises.count - 1 {
            self.currentExerciseIndexInCurrentGroup += 1
        } else if self.currentGroupIndex < self.activity.exercisePayload.exerciseGroups.count - 1 {
            self.currentGroupIndex += 1
            self.currentExerciseIndexInCurrentGroup = 0
        }
    }

    public func moveToPreviousExercise() {
        if self.currentExerciseIndexInCurrentGroup > 0 {
            self.currentExerciseIndexInCurrentGroup -= 1
        } else if self.currentGroupIndex > 0 {
            self.currentGroupIndex -= 1
            self.currentExerciseIndexInCurrentGroup = self.activity.exercisePayload.exerciseGroups[self.currentGroupIndex].exercises.count - 1
        }
    }
}
