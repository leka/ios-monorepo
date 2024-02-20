// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public class ActivityViewViewModelDeprecated: ObservableObject {
    // MARK: Lifecycle

    public init(activity: ActivityDeprecated) {
        self.sequenceManager = ActivitySequenceManager(activity: activity)

        self.currentActivity = activity

        self.totalSequences = self.sequenceManager.totalSequences
        self.currentSequenceIndex = self.sequenceManager.currentSequenceIndex

        self.totalExercisesInCurrentSequence = self.sequenceManager.totalExercisesInCurrentSequence
        self.currentExerciseIndexInSequence = self.sequenceManager.currentExerciseIndexInSequence

        self.currentExercise = self.sequenceManager.currentExercise
        self.currentExerciseInterface = self.sequenceManager.currentExercise.interface

        self.currentExerciseSharedData = ExerciseSharedData(
            sequenceIndex: self.sequenceManager.currentSequenceIndex,
            exerciseIndex: self.sequenceManager.currentExerciseIndexInSequence
        )
        self.completedExercisesSharedData.append(self.currentExerciseSharedData)

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    // MARK: Internal

    @Published var currentActivity: ActivityDeprecated

    @Published var totalSequences: Int
    @Published var currentSequenceIndex: Int

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

    private let sequenceManager: ActivitySequenceManager

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        self.currentExercise = self.sequenceManager.currentExercise
        self.currentExerciseInterface = self.sequenceManager.currentExercise.interface
        self.currentSequenceIndex = self.sequenceManager.currentSequenceIndex
        self.totalSequences = self.sequenceManager.totalSequences
        self.currentExerciseIndexInSequence = self.sequenceManager.currentExerciseIndexInSequence
        self.totalExercisesInCurrentSequence = self.sequenceManager.totalExercisesInCurrentSequence
        self.currentExerciseSharedData = ExerciseSharedData(
            sequenceIndex: self.sequenceManager.currentSequenceIndex,
            exerciseIndex: self.sequenceManager.currentExerciseIndexInSequence
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
