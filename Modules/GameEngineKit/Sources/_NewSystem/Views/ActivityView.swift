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

                        Text(viewModel.currentExercise.instructions)
                            .font(.title)
                            .padding(40)
                            .background(.gray)
                            .cornerRadius(10)
                    }

                    VStack {
                        Spacer()
                        currentExerciseInterface()
                        Spacer()
                    }
                }

                Button("Continuer") {
                    viewModel.moveToNextExercise()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding()
                .disabled(viewModel.currentExerciseSharedData.state != .completed)
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
                .id(viewModel.currentExerciseIndexInSequence)

            case .listenThenTouchToSelect:
                ListenThenTouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )
                .id(viewModel.currentExerciseIndexInSequence)

            case .observeThenTouchToSelect:
                ObserveThenTouchToSelectView(
                    exercise: viewModel.currentExercise,
                    data: viewModel.currentExerciseSharedData
                )
                .id(viewModel.currentExerciseIndexInSequence)
        }
    }

}

#Preview {
    let activity = ContentKit.decodeActivity("activity-sample")
    return ActivityView(viewModel: ActivityViewViewModel(activity: activity))
}
