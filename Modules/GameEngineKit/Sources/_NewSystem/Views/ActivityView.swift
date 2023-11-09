// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

public struct ActivityView: View {

    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ActivityViewViewModel

    public init(viewModel: ActivityViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    VStack(spacing: 15) {
                        ActivityProgressBar(viewModel: viewModel)

                        ExerciseInstructionsButton(instructions: viewModel.currentExercise.instructions)
                    }

                    VStack {
                        Spacer()
                        currentExerciseInterface()
                        Spacer()
                    }
                }
                .id(viewModel.currentExerciseIndexInSequence)

                continueButton
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.currentActivity.name)
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.moveToPreviousExercise()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .disabled(viewModel.isFirstExercise)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.moveToNextExercise()
                    } label: {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(viewModel.isLastExercise)
                }
            }
        }
    }

    @ViewBuilder
    private func currentExerciseInterface() -> some View {
        switch viewModel.currentExerciseInterface {
            case .touchToSelect:
                TouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )

            case .robotThenTouchToSelect:
                RobotThenTouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )

            case .listenThenTouchToSelect:
                ListenThenTouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )

            case .observeThenTouchToSelect:
                ObserveThenTouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )

            case .dragAndDrop:
                DragAndDropView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )

            case .association:
                Text("association")
        }
    }

    @ViewBuilder
    private var continueButton: some View {
        let state = viewModel.currentExerciseSharedData.state

        if state != .completed {
            EmptyView()
        } else {
            Button("Continuer") {
                viewModel.isLastExercise ? dismiss() : viewModel.moveToNextExercise()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding()
            .transition(.asymmetric(insertion: .opacity.animation(.snappy.delay(2)), removal: .identity))
        }
    }

}

#Preview {
    let activity = ContentKit.decodeActivity("activity-sample")
    return ActivityView(viewModel: ActivityViewViewModel(activity: activity))
}
