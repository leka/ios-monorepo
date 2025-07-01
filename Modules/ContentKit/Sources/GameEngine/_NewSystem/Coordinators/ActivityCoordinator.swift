// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewActivityManager

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

    public enum ActivityEvent {
        case didStart
        case didEnd
    }

    public var currentGroupIndex: Int = 0
    public var currentExerciseIndex: Int = 0
    public var isExerciseCompleted: Bool = false

    public let groupSizeEnumeration: [Int]

    public var activityEvent = PassthroughSubject<ActivityEvent, Never>()

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

        self.currentExerciseCoordinator.didComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionData in
                if let completionData {
                    logGEK.info("Current exercise completed 🎉️ - \(completionData)")

                } else {
                    logGEK.info("Current exercise completed 🎉️ - no data")
                }
                self?.isExerciseCompleted = true
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

    private var cancellables = Set<AnyCancellable>()

    private var currentExerciseCoordinator: CurrentExerciseCoordinator
}
