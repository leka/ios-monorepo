// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// MARK: - NewActivityManager

class NewActivityManager {
    // MARK: Lifecycle

    init(payload: ActivityPayload) {
        self.payload = payload
        self.groups = payload.exerciseGroups
        self.currentExercise = self.groups[self.currentGroupIndex].group[self.currentExerciseIndex]
    }

    convenience init(payload: Data) {
        guard let payload = try? JSONDecoder().decode(ActivityPayload.self, from: payload) else {
            log.error("Failed to decode ActivityPayload: \(payload)")
            fatalError("Failed to decode ActivityPayload")
        }
        self.init(payload: payload)
    }

    // MARK: Public

    public var numberOfGroups: Int {
        self.groups.count
    }

    public var numberOfExercisesInCurrentGroup: Int {
        self.groups[self.currentGroupIndex].group.count
    }

    public var isLastExercise: Bool {
        self.currentGroupIndex == self.groups.count - 1
            && self.currentExerciseIndex == self.groups[self.currentGroupIndex].group.count - 1
    }

    public var isFirstExercise: Bool {
        self.currentGroupIndex == 0 && self.currentExerciseIndex == 0
    }

    // MARK: Internal

    let payload: ActivityPayload
    let groups: [ExerciseGroup]

    var currentExercise: NewExercise
    var currentGroupIndex: Int = 0
    var currentExerciseIndex: Int = 0

    func nextExercise() {
        guard !self.isLastExercise else { return }

        self.currentExerciseIndex += 1

        if self.currentExerciseIndex >= self.groups[self.currentGroupIndex].group.count {
            self.currentExerciseIndex = 0
            self.currentGroupIndex += 1
        }

        if self.currentGroupIndex >= self.groups.count {
            self.currentGroupIndex = 0
        }

        self.currentExercise = self.groups[self.currentGroupIndex].group[self.currentExerciseIndex]
    }

    func previousExercise() {
        guard !self.isFirstExercise else { return }

        self.currentExerciseIndex -= 1

        if self.currentExerciseIndex < 0 {
            self.currentExerciseIndex = self.groups[self.currentGroupIndex].group.count - 1
            self.currentGroupIndex -= 1
        }

        if self.currentGroupIndex < 0 {
            self.currentGroupIndex = self.groups.count - 1
        }

        self.currentExercise = self.groups[self.currentGroupIndex].group[self.currentExerciseIndex]
    }
}
