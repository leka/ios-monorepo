// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import SwiftUI

// MARK: - PlaceholderExerciseView

struct PlaceholderExerciseView: View {
    @State var count = 0

    var body: some View {
        Text("Placeholder Exercise View")

        Text("Counter: \(self.count)")
        Button("Press me") {
            self.count += 1
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - ExerciseCoordinator

class ExerciseCoordinator {
    // MARK: Lifecycle

    init(payload: Activity.ExercisesPayload) {
        self.currentExercise = payload.exerciseGroups.first!.exercises.first!
    }

    // MARK: Internal

    let currentExercise: Exercise

    @ViewBuilder
    var execiseView: some View {
        switch (ui: self.currentExercise.interface, gameplay: self.currentExercise.gameplay) {
            case (.touchToSelect, .findTheRightAnswers):
                // swiftlint:disable:next force_cast
                let ttsPayload = self.currentExercise.payload as! TouchToSelect.Payload

                let gameplayChoices = ttsPayload.choices.map {
                    NewGameplayFindTheRightAnswersChoice(value: $0.value, isRightAnswer: $0.isRightAnswer)
                }

                let gameplay = NewGameplayFindTheRightAnswers(choices: gameplayChoices)
                let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
                let viewModel = TTSViewViewModel(coordinator: coordinator)

                TTSView(viewModel: viewModel)
            default:
                PlaceholderExerciseView()
        }
    }
}

// MARK: - NewActivityViewModel

public class NewActivityViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self.activity = activity
        self.exerciseCoordinator = ExerciseCoordinator(payload: activity.exercisePayload)
    }

    // MARK: Internal

    var activityTitle: String {
        self.activity.details.title
    }

    @ViewBuilder
    var exerciseView: some View {
        VStack {
            Button(self.exerciseCoordinator.currentExercise.instructions ?? "Missing instructions") {
                log.warning("Exercise instructions button tapped")
            }
            .buttonStyle(.borderedProminent)

            Spacer()

            self.exerciseCoordinator.execiseView

            Spacer()
        }
    }

    // MARK: Private

    private let activity: Activity
    private let exerciseCoordinator: ExerciseCoordinator
}

// MARK: - NewActivityView

public struct NewActivityView: View {
    // MARK: Lifecycle

    public init(viewModel: NewActivityViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                VStack(spacing: 15) {
                    Text("Progress bar")
                }

                self.viewModel.exerciseView
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.viewModel.activityTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Reinforcer animation toggled")
                } label: {
                    Image(systemName: "livephoto")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Move to previous exercise")
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Move to next exercise")
                } label: {
                    Image(systemName: "arrow.forward")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Activity information sheet toggled")
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }

    // MARK: Internal

    @StateObject var viewModel: NewActivityViewModel

    @Environment(\.dismiss) var dismiss
}

#Preview {
    NavigationStack {
        let activity = ContentKit.allTemplateActivities.first(where: {
            $0.exercisePayload.exerciseGroups.first!.exercises.first!.interface == .touchToSelect
        })!
        let viewModel = NewActivityViewModel(activity: activity)
        NewActivityView(viewModel: viewModel)
    }
}
