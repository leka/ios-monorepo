// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self.sequenceManager = ActivityExerciseManager(activity: activity)

        self.currentActivity = activity

        self.totalSequences = self.sequenceManager.totalGroups
        self.currentGroupIndex = self.sequenceManager.currentGroupIndex

        self.totalExercisesInCurrentSequence = self.sequenceManager.totalExercisesInCurrentGroup
        self.currentExerciseIndexInSequence = self.sequenceManager.currentExerciseIndexInCurrentGroup

        self.currentExercise = self.sequenceManager.currentExercise
        self.currentExerciseInterface = self.sequenceManager.currentExercise.interface

        self.currentExerciseSharedData = ExerciseSharedData(
            sequenceIndex: self.sequenceManager.currentGroupIndex,
            exerciseIndex: self.sequenceManager.currentExerciseIndexInCurrentGroup
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    // MARK: Internal

    @Published var currentActivity: ActivityDeprecated

    @Published var totalSequences: Int
    @Published var currentGroupIndex: Int

    @Published var totalExercisesInCurrentSequence: Int
    @Published var currentExerciseIndexInSequence: Int

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
        self.totalSequences > 1 || self.totalExercisesInCurrentSequence != 1
    }

    var isExerciseInstructionsButtonVisible: Bool {
        !self.currentExercise.instructions.isEmpty
    }

    var isFirstExercise: Bool {
        self.sequenceManager.isFirstExercise
    }

    var isLastExercise: Bool {
        self.sequenceManager.isLastExercise
    }

    func moveToNextExercise() {
        self.sequenceManager.moveToNextExercise()
        self.updateValues()
    }

    func moveToPreviousExercise() {
        self.sequenceManager.moveToPreviousExercise()
        self.updateValues()
    }

    func moveToActivityEnd() {
        self.isCurrentActivityCompleted = true
    }

    // MARK: Private

    private let sequenceManager: ActivityExerciseManager

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        self.currentExercise = self.sequenceManager.currentExercise
        self.currentExerciseInterface = self.sequenceManager.currentExercise.interface
        self.currentGroupIndex = self.sequenceManager.currentGroupIndex
        self.totalSequences = self.sequenceManager.totalGroups
        self.currentExerciseIndexInSequence = self.sequenceManager.currentExerciseIndexInCurrentGroup
        self.totalExercisesInCurrentSequence = self.sequenceManager.totalExercisesInCurrentGroup
        self.currentExerciseSharedData = ExerciseSharedData(
            sequenceIndex: self.sequenceManager.currentGroupIndex,
            exerciseIndex: self.sequenceManager.currentExerciseIndexInCurrentGroup
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
