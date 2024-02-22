// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(activity: Activity) {
        self.currentActivity = activity

        self.exerciseManager = ActivityExerciseManager(activity: activity)

        self.totalGroups = self.exerciseManager.totalGroups
        self.currentGroupIndex = self.exerciseManager.currentGroupIndex

        self.groupSizeEnumeration = self.exerciseManager.activity.exercisePayload.exerciseGroups.map(\.exercises.count)

        self.totalExercisesInCurrentGroup = self.exerciseManager.totalExercisesInCurrentGroup
        self.currentExerciseIndexInCurrentGroup = self.exerciseManager.currentExerciseIndexInCurrentGroup

        self.currentExercise = self.exerciseManager.currentExercise
        self.currentExerciseInterface = self.exerciseManager.currentExercise.interface

        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.exerciseManager.currentGroupIndex,
            exerciseIndex: self.exerciseManager.currentExerciseIndexInCurrentGroup
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    // MARK: Internal

    @Published var currentActivity: Activity

    @Published var totalGroups: Int
    @Published var currentGroupIndex: Int
    @Published var groupSizeEnumeration: [Int]

    @Published var totalExercisesInCurrentGroup: Int
    @Published var currentExerciseIndexInCurrentGroup: Int

    @Published var currentExercise: Exercise
    @Published var currentExerciseInterface: Exercise.Interface

    @Published var completedExercisesSharedData: [ExerciseSharedData] = []
    @Published var currentExerciseSharedData: ExerciseSharedData

    @Published var isCurrentActivityCompleted: Bool = false
    @Published var isReinforcerAnimationVisible: Bool = false
    @Published var isReinforcerAnimationEnabled: Bool = true

    var successExercisesSharedData: [ExerciseSharedData] {
        self.completedExercisesSharedData.filter {
            $0.completionLevel == .excellent
                || $0.completionLevel == .good
        }
    }

    var didCompleteActivitySuccessfully: Bool {
        let minimalSuccessPercentage = 0.8

        return Double(self.successExercisesSharedData.count) > (Double(self.completedExercisesSharedData.count) * minimalSuccessPercentage)
    }

    var scorePanelEnabled: Bool {
        !self.completedExercisesSharedData.filter {
            $0.completionLevel != .nonApplicable
        }.isEmpty
    }

    var activityCompletionSuccessPercentage: Int {
        let successfulExercises = self.successExercisesSharedData.count
        let totalExercises = self.completedExercisesSharedData.filter {
            $0.completionLevel != .nonApplicable
        }.count

        return (successfulExercises / totalExercises) * 100
    }

    var delayAfterReinforcerAnimation: Double {
        self.isReinforcerAnimationEnabled ? 5 : 0.5
    }

    var isProgressBarVisible: Bool {
        self.totalGroups > 1 || self.totalExercisesInCurrentGroup != 1
    }

    var isExerciseInstructionsButtonVisible: Bool {
        guard let instructions = self.currentExercise.instructions else { return false }
        return !instructions.isEmpty
    }

    var isFirstExercise: Bool {
        self.exerciseManager.isFirstExercise
    }

    var isLastExercise: Bool {
        self.exerciseManager.isLastExercise
    }

    func moveToNextExercise() {
        self.exerciseManager.moveToNextExercise()
        self.updateValues()
    }

    func moveToPreviousExercise() {
        self.exerciseManager.moveToPreviousExercise()
        self.updateValues()
    }

    func moveToActivityEnd() {
        self.isCurrentActivityCompleted = true
    }

    // MARK: Private

    private let exerciseManager: ActivityExerciseManager

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        self.currentExercise = self.exerciseManager.currentExercise
        self.currentExerciseInterface = self.exerciseManager.currentExercise.interface
        self.currentGroupIndex = self.exerciseManager.currentGroupIndex
        self.totalGroups = self.exerciseManager.totalGroups
        self.currentExerciseIndexInCurrentGroup = self.exerciseManager.currentExerciseIndexInCurrentGroup
        self.totalExercisesInCurrentGroup = self.exerciseManager.totalExercisesInCurrentGroup
        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.exerciseManager.currentGroupIndex,
            exerciseIndex: self.exerciseManager.currentExerciseIndexInCurrentGroup
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    private func subscribeToCurrentExerciseSharedDataUpdates() {
        self.currentExerciseSharedData.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {
                if self.isReinforcerAnimationEnabled, case .completed = self.currentExerciseSharedData.state {
                    self.isReinforcerAnimationVisible = true
                } else {
                    self.isReinforcerAnimationVisible = false
                }
            }
            .store(in: &self.cancellables)
    }
}
