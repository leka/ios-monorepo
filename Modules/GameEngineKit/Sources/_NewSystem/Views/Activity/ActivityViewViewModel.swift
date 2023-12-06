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

        self.totalSequences = sequenceManager.totalSequences
        self.currentSequenceIndex = sequenceManager.currentSequenceIndex

        self.totalExercisesInCurrentSequence = sequenceManager.totalExercisesInCurrentSequence
        self.currentExerciseIndexInSequence = sequenceManager.currentExerciseIndexInSequence

        self.currentExercise = sequenceManager.currentExercise
        self.currentExerciseInterface = sequenceManager.currentExercise.interface
        self.currentExerciseSharedData = ExerciseSharedData()

        subscribeToCurrentExerciseSharedDataUpdates()
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

    var isFirstExercise: Bool {
        sequenceManager.isFirstExercise
    }

    var isLastExercise: Bool {
        sequenceManager.isLastExercise
    }

    func moveToNextExercise() {
        sequenceManager.moveToNextExercise()
        updateValues()
    }

    func moveToPreviousExercise() {
        sequenceManager.moveToPreviousExercise()
        updateValues()
    }

    // MARK: Private

    private let sequenceManager: ActivitySequenceManager

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        currentExercise = sequenceManager.currentExercise
        currentExerciseInterface = sequenceManager.currentExercise.interface
        currentSequenceIndex = sequenceManager.currentSequenceIndex
        totalSequences = sequenceManager.totalSequences
        currentExerciseIndexInSequence = sequenceManager.currentExerciseIndexInSequence
        totalExercisesInCurrentSequence = sequenceManager.totalExercisesInCurrentSequence
        currentExerciseSharedData = ExerciseSharedData()

        subscribeToCurrentExerciseSharedDataUpdates()
    }

    private func subscribeToCurrentExerciseSharedDataUpdates() {
        currentExerciseSharedData.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
