// Leka - iOS Monorepo
// Copyright 2024 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self.sequenceManager = ActivitySequenceManager(activity: activity)

        self.currentActivity = activity

        self.totalSequences = self.sequenceManager.totalSequences
        self.currentSequenceIndex = self.sequenceManager.currentSequenceIndex

        self.totalExercisesInCurrentSequence = self.sequenceManager.totalExercisesInCurrentSequence
        self.currentExerciseIndexInSequence = self.sequenceManager.currentExerciseIndexInSequence

        self.currentExercise = self.sequenceManager.currentExercise
        self.currentExerciseInterface = self.sequenceManager.currentExercise.interface
        self.currentExerciseSharedData = ExerciseSharedData()

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    // MARK: Internal

    @Published var currentActivity: Activity

    @Published var totalSequences: Int
    @Published var currentSequenceIndex: Int

    @Published var totalExercisesInCurrentSequence: Int
    @Published var currentExerciseIndexInSequence: Int

    @Published var currentExercise: Exercise
    @Published var currentExerciseInterface: Exercise.Interface
    @Published var currentExerciseSharedData: ExerciseSharedData
    @Published var isCurrentActivityCompleted: Bool = false

    @Published var isReinforcerAnimationVisible: Bool = false
    @Published var isReinforcerAnimationEnabled: Bool = true

    // TODO(@ladislas/@hugo): Add method to change this boolean
    @Published var didCompleteActivitySuccessfully: Bool = true

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

    func moveToScorePanel() {
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
        self.currentExerciseSharedData = ExerciseSharedData()

        self.subscribeToCurrentExerciseSharedDataUpdates()
    }

    private func subscribeToCurrentExerciseSharedDataUpdates() {
        self.currentExerciseSharedData.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {
                if self.isReinforcerAnimationEnabled, self.currentExerciseSharedData.state == .completed {
                    self.isReinforcerAnimationVisible = true
                } else {
                    self.isReinforcerAnimationVisible = false
                }
            }
            .store(in: &self.cancellables)
    }
}
