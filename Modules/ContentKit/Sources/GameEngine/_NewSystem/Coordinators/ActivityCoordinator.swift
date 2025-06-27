// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - ActivityEvent

public enum ActivityEvent {
    case didStart
    case didEnd
}

// MARK: - ExerciseEvent

public enum ExerciseEvent {
    case didStart
    case didEnd(groupIndex: Int, exerciseIndex: Int, withSuccess: Bool)
}

// MARK: - ActivityCoordinator

@Observable
public class ActivityCoordinator {
    // MARK: Lifecycle

    public init(payload: ActivityPayload) {
        guard let firstExercise = payload.exerciseGroups.first?.group.first else {
            logGEK.error("Failed to get first exercise from ActivityPayload: \(payload)")
            fatalError("Failed to get first exercise from ActivityPayload")
        }

        self.payload = payload
        self.groups = payload.exerciseGroups

        self.groupSizeEnumeration = self.groups.map(\.group.count)

        self.currentExercise = firstExercise
        self.currentExerciseCoordinator = CurrentExerciseCoordinator(exercise: firstExercise)

        self.setExerciseCoordinator(self.currentExerciseCoordinator)
    }

    public convenience init(payload: Data) {
        guard let payload = try? JSONDecoder().decode(ActivityPayload.self, from: payload) else {
            logGEK.error("Failed to decode ActivityPayload: \(payload)")
            fatalError("Failed to decode ActivityPayload")
        }
        self.init(payload: payload)
    }

    // MARK: Public

    public var currentGroupIndex: Int = 0
    public var currentExerciseIndex: Int = 0
    public var isExerciseCompleted: Bool = false

    public let groupSizeEnumeration: [Int]

    public var activityEvent = PassthroughSubject<ActivityEvent, Never>()
    public var exerciseEvent = PassthroughSubject<ExerciseEvent, Never>()

    public var cancellables = Set<AnyCancellable>()

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
        self.currentExerciseCoordinator.exerciseView
    }

    // MARK: Internal

    let payload: ActivityPayload
    let groups: [ExerciseGroup]

    var currentExercise: NewExercise

    func setExerciseCoordinator(_ coordinator: CurrentExerciseCoordinator) {
        self.currentExerciseCoordinator = coordinator
        self.exerciseEvent.send(.didStart)

        self.currentExerciseCoordinator.didComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                logGEK.info("Current exercise completed 🎉️")
                self.isExerciseCompleted = true
                self.exerciseEvent.send(.didEnd(
                    groupIndex: self.currentGroupIndex,
                    exerciseIndex: self.currentExerciseIndex,
                    withSuccess: true
                ))
            }
            .store(in: &self.cancellables)
    }

    func nextExercise() {
        guard !self.isLastExercise else {
            self.activityEvent.send(.didEnd)
            return
        }

        self.isExerciseCompleted = false
        self.currentExerciseIndex += 1

        if self.currentExerciseIndex >= self.groups[self.currentGroupIndex].group.count {
            self.currentExerciseIndex = 0
            self.currentGroupIndex += 1
        }

        self.currentExercise = self.groups[self.currentGroupIndex].group[self.currentExerciseIndex]
        self.setExerciseCoordinator(CurrentExerciseCoordinator(exercise: self.currentExercise))
    }

    func previousExercise() {
        guard !self.isFirstExercise else { return }

        self.isExerciseCompleted = false
        self.currentExerciseIndex -= 1

        if self.currentExerciseIndex < 0 {
            self.currentGroupIndex -= 1
            self.currentExerciseIndex = self.groups[self.currentGroupIndex].group.count - 1
        }

        self.currentExercise = self.groups[self.currentGroupIndex].group[self.currentExerciseIndex]
        self.setExerciseCoordinator(CurrentExerciseCoordinator(exercise: self.currentExercise))
    }

    // MARK: Private

    private var currentExerciseCoordinator: CurrentExerciseCoordinator
}
