// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

public struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewViewModel

    public init(viewModel: ActivityViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Text("S(\(viewModel.currentSequenceIndex + 1)/\(viewModel.totalSequences))")
                    Text(
                        "E(\(viewModel.currentExerciseIndexInSequence + 1)/\(viewModel.totalExercisesInCurrentSequence))"
                    )
                }
                .font(.headline)
                .monospacedDigit()

                ActivityProgressBar(viewModel: viewModel)

                Text(viewModel.currentExercise.instructions)
                    .font(.title)
                    .padding(40)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.top)

                Spacer()

                currentExerciseInterface()

                Spacer()
            }

            HStack {
                Button(action: viewModel.moveToPreviousExercise) {
                    Text("Previous")
                }
                .disabled(viewModel.isFirstExercise)

                Spacer()

                Button(action: viewModel.moveToNextExercise) {
                    Text("Next")
                }
                .disabled(viewModel.isLastExercise)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    @ViewBuilder
    private func currentExerciseInterface() -> some View {
        switch viewModel.currentExerciseInterface {
            case .touchToSelect:
                TouchToSelectView(exercise: viewModel.currentExercise)
                    .id(viewModel.currentExerciseIndexInSequence)
        }
    }
}

#Preview {
    let activity = ContentKit.ActivityList.seq1Selection
    return ActivityView(viewModel: ActivityViewViewModel(activity: activity))
}
