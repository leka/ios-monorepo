// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - NewActivityManager

class NewActivityManager: ObservableObject {
    // MARK: Lifecycle

    init(payload: ActivityPayload) {
        self.payload = payload
        self.groups = payload.exerciseGroups
        self.currentExercise = self.groups[0].group[0]
        self.groupSizeEnumeration = self.groups.map(\.group.count)
        self.currentExerciseCoordinator = ExerciseCoordinator(exercise: self.currentExercise)
    }

    convenience init(payload: Data) {
        guard let payload = try? JSONDecoder().decode(ActivityPayload.self, from: payload) else {
            log.error("Failed to decode ActivityPayload: \(payload)")
            fatalError("Failed to decode ActivityPayload")
        }
        self.init(payload: payload)
    }

    // MARK: Public

    @Published public var currentGroupIndex: Int = 0
    @Published public var currentExerciseIndex: Int = 0

    public let groupSizeEnumeration: [Int]

    public var numberOfGroups: Int {
        self.groupSizeEnumeration.count
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

    @ViewBuilder
    public var currentExerciseView: some View {
        Spacer()

        self.currentExerciseCoordinator.exerciseView

        Spacer()
    }

    // MARK: Internal

    let payload: ActivityPayload
    let groups: [ExerciseGroup]

    var currentExercise: NewExercise

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
        self.currentExerciseCoordinator = ExerciseCoordinator(exercise: self.currentExercise)
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
        self.currentExerciseCoordinator = ExerciseCoordinator(exercise: self.currentExercise)
    }

    // MARK: Private

    private var currentExerciseCoordinator: ExerciseCoordinator
}
