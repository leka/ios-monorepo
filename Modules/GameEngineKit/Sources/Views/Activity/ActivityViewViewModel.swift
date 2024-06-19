// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import SwiftUI

class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(activity: Activity) {
        self.currentActivity = activity

        self.activityManager = CurrentActivityManager(activity: activity)

        self.totalGroups = self.activityManager.totalGroups
        self.currentGroupIndex = self.activityManager.currentGroupIndex

        self.groupSizeEnumeration = self.activityManager.activity.exercisePayload.exerciseGroups.map(\.exercises.count)

        self.totalExercisesInCurrentGroup = self.activityManager.totalExercisesInCurrentGroup
        self.currentExerciseIndexInCurrentGroup = self.activityManager.currentExerciseIndexInCurrentGroup

        self.currentExercise = self.activityManager.currentExercise
        self.currentExerciseInterface = self.activityManager.currentExercise.interface

        self.completedExercisesSharedData = Array(repeating: [], count: self.activityManager.totalGroups)

        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.activityManager.currentGroupIndex,
            exerciseIndex: self.activityManager.currentExerciseIndexInCurrentGroup
        )
//        self.completedExercisesSharedData[self.currentGroupIndex].append(self.currentExerciseSharedData)

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

    @Published var completedExercisesSharedData: [[ExerciseSharedData]]
    @Published var currentExerciseSharedData: ExerciseSharedData

    @Published var isCurrentActivityCompleted: Bool = false
    @Published var isReinforcerAnimationVisible: Bool = false
    @Published var isReinforcerAnimationEnabled: Bool = true

    var successExercisesSharedData: [[ExerciseSharedData]] {
        self.completedExercisesSharedData.map { group in
            group.filter {
                $0.completionLevel == .excellent || $0.completionLevel == .good
            }
        }
    }

    var didCompleteActivitySuccessfully: Bool {
        let minimalSuccessPercentage = 0.8
        let successfulExercisesCount = self.successExercisesSharedData.flatMap { $0 }.count
        let totalCompletedExercisesCount = self.completedExercisesSharedData.flatMap { $0 }.count

        return Double(successfulExercisesCount) > (Double(totalCompletedExercisesCount) * minimalSuccessPercentage)
    }

    var scorePanelEnabled: Bool {
        !self.completedExercisesSharedData.flatMap { $0 }.filter {
            $0.completionLevel != .nonApplicable
        }.isEmpty
    }

    var activityCompletionSuccessPercentage: Double {
        let successfulExercisesCount = Double(self.successExercisesSharedData.flatMap { $0 }.count)
        let totalCompletedExercisesCount = Double(self.completedExercisesSharedData.flatMap { $0 }.filter {
            $0.completionLevel != .nonApplicable
        }.count)

        return (successfulExercisesCount / totalCompletedExercisesCount) * 100.0
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
        self.activityManager.isFirstExercise
    }

    var isLastExercise: Bool {
        self.activityManager.isLastExercise
    }

    var completedExercisesData: [[ExerciseCompletionData]] {
        self.completedExercisesSharedData.map { group in
            group.compactMap(\.completionData)
        }
    }

    func moveToNextExercise() {
        self.activityManager.moveToNextExercise()
        self.updateValues()
    }

    func moveToPreviousExercise() {
        self.activityManager.moveToPreviousExercise()
        self.updateValues()
    }

    func moveToActivityEnd() {
        self.isCurrentActivityCompleted = true
    }

    func collectCurrentExerciseSharedData() {
        self.completedExercisesSharedData[self.currentGroupIndex].append(self.currentExerciseSharedData)
    }

    func saveActivityCompletion(caregiverID: String?, carereceiverIDs: [String]) {
        let completionDataString = self.exerciseCompletionDataManager.encodeCompletionData(self.completedExercisesData)
        let activityCompletionData = ActivityCompletionData(
            caregiverID: caregiverID ?? "No caregiver found",
            carereceiverIDs: carereceiverIDs,
            startTimestamp: self.activityManager.startTimestamp,
            endTimestamp: Date(),
            completionData: completionDataString
        )

        self.activityManager.saveActivityCompletion(activityCompletionData: activityCompletionData)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Activity Completion Data saved successfully.")
                    case let .failure(error):
                        print("Saving Activity Completion Data failed with error: \(error)")
                }
            }, receiveValue: { _ in
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private let activityManager: CurrentActivityManager
    private let exerciseCompletionDataManager: ExerciseCompletionDataManager = .shared

    private var cancellables: Set<AnyCancellable> = []

    private func updateValues() {
        self.currentExercise = self.activityManager.currentExercise
        self.currentExerciseInterface = self.activityManager.currentExercise.interface
        self.currentGroupIndex = self.activityManager.currentGroupIndex
        self.totalGroups = self.activityManager.totalGroups
        self.currentExerciseIndexInCurrentGroup = self.activityManager.currentExerciseIndexInCurrentGroup
        self.totalExercisesInCurrentGroup = self.activityManager.totalExercisesInCurrentGroup
        self.currentExerciseSharedData = ExerciseSharedData(
            groupIndex: self.activityManager.currentGroupIndex,
            exerciseIndex: self.activityManager.currentExerciseIndexInCurrentGroup
        )

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
