// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

public class ActivityViewViewModel: ObservableObject {
    private let sequenceManager: ActivitySequenceManager

    @Published var currentExercise: Exercise
    @Published var currentSequenceIndex: Int
    @Published var totalSequences: Int
    @Published var currentExerciseIndexInSequence: Int
    @Published var totalExercisesInCurrentSequence: Int

    @Published var currentInterface: Exercise.Interface

    public init(activity: Activity) {
        self.sequenceManager = ActivitySequenceManager(activity: activity)
        self.currentExercise = sequenceManager.currentExercise
        self.currentSequenceIndex = sequenceManager.currentSequenceIndex
        self.totalSequences = sequenceManager.totalSequences
        self.currentExerciseIndexInSequence = sequenceManager.currentExerciseIndexInSequence
        self.totalExercisesInCurrentSequence = sequenceManager.totalExercisesInCurrentSequence

        // TODO(@ladisals): refactor to use Exercise.Interface and move logic to TouchToSelectView
        switch sequenceManager.currentExercise.interface {
            case .touchToSelectOne, .touchToSelectTwo, .touchToSelectFour, .touchToSelectSix:
                self.currentInterface = .touchToSelect
            default:
                self.currentInterface = .touchToSelect
        }
    }

    func moveToNextExercise() {
        sequenceManager.moveToNextExercise()
        updateValues()
    }

    func moveToPreviousExercise() {
        sequenceManager.moveToPreviousExercise()
        updateValues()
    }

    var isFirstExercise: Bool {
        sequenceManager.isFirstExercise
    }

    var isLastExercise: Bool {
        sequenceManager.isLastExercise
    }

    private func updateValues() {
        currentExercise = sequenceManager.currentExercise
        currentSequenceIndex = sequenceManager.currentSequenceIndex
        totalSequences = sequenceManager.totalSequences
        currentExerciseIndexInSequence = sequenceManager.currentExerciseIndexInSequence
        totalExercisesInCurrentSequence = sequenceManager.totalExercisesInCurrentSequence
    }
}
