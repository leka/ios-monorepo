// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - ActivityCoordinator

@Observable
public class ActivityCoordinator {
    // MARK: Lifecycle

    public init(payload: ActivityPayload) {
        guard payload.exerciseGroups.first?.group.first != nil else {
            logGEK.error("Failed to get first exercise from ActivityPayload: \(payload)")
            fatalError("Failed to get first exercise from ActivityPayload")
        }

        self.payload = payload
        let shuffleOptions = payload.options
        var exerciseGroups = payload.exerciseGroups

        if shuffleOptions.shuffleExercises {
            exerciseGroups = payload.exerciseGroups.map {
                ExerciseGroup(group: $0.group.shuffled())
            }
        }

        self.groups = shuffleOptions.shuffleGroups ? exerciseGroups.shuffled() : exerciseGroups
        self.groupSizeEnumeration = self.groups.map(\.group.count)

        let firstExercise = self.groups[0].group[0]
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

    public enum ActivityCompletionStatus {
        case success
        case failure
    }

    public var currentGroupIndex: Int = 0
    public var currentExerciseIndex: Int = 0
    public var isExerciseCompleted: Bool = false

    public let groupSizeEnumeration: [Int]

    public var isReinforcerAnimationEnabled: Bool = true

    public var activityEvent = PassthroughSubject<ActivityEvent, Never>()

    public var completionStatus: ActivityCompletionStatus?
    public var exercisesCompletionData: [Int: [Int: (level: ExerciseEvaluationLevel, data: ExerciseCompletionData?)]] = [:]

    public var numberOfGroups: Int {
        self.groupSizeEnumeration.count
    }

    public var numberOfExercisesInCurrentGroup: Int {
        self.groups[self.currentGroupIndex].group.count
    }

    public var totalNumberOfExercises: Int {
        self.groupSizeEnumeration.reduce(0, +)
    }

    public var isFirstExercise: Bool {
        self.currentGroupIndex == 0 && self.currentExerciseIndex == 0
    }

    public var isLastExercise: Bool {
        self.currentGroupIndex == self.groups.count - 1
            && self.currentExerciseIndex == self.groups[self.currentGroupIndex].group.count - 1
    }

    @ViewBuilder
    public var currentExerciseView: some View {
        self.currentExerciseCoordinator.exerciseView
    }

    // MARK: Internal

    let payload: ActivityPayload
    let groups: [ExerciseGroup]

    var currentExercise: Exercise

    func setExerciseCoordinator(_ coordinator: CurrentExerciseCoordinator) {
        self.currentExerciseCoordinator = coordinator

        self.currentExerciseCoordinator.didComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionData in
                guard let self else { return }

                logGEK.info("Current exercise completed 🎉️ - \(completionData)")
                self.exercisesCompletionData[self.currentGroupIndex, default: [:]][self.currentExerciseIndex] = completionData

                self.isExerciseCompleted = true
                if self.isLastExercise {
                    self.computeActivityCompletionStatus()
                }
            }
            .store(in: &self.cancellables)
    }

    func nextExercise() {
        guard !self.isLastExercise else {
            self.activityEvent.send(.didEnd)
            logGEK.info("Activity completed 🎉️ - \(self.exercisesCompletionData)")
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

    func computeActivityCompletionStatus() {
        let minimalSuccessRatio = 0.8

        var completedExercises = self.exercisesCompletionData.flatMap(\.value.values)
        let applicableCompletedExercises = completedExercises.filter { $0.level != .notApplicable }
        let applicableExercisesCount = applicableCompletedExercises.count

        guard applicableExercisesCount > 0 else { self.completionStatus = .success; return }

        let successfulExercisesCount = applicableCompletedExercises.filter { completion in
            completion.level == .excellent || completion.level == .good
        }.count

        self.completionStatus = Double(successfulExercisesCount) / Double(applicableExercisesCount) >= minimalSuccessRatio ? .success : .failure
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private var currentExerciseCoordinator: CurrentExerciseCoordinator
}
