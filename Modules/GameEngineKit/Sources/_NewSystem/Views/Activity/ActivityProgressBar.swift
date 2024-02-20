// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBar: View {
    // MARK: Internal

    @ObservedObject var viewModel: ActivityViewViewModelDeprecated
    let height: CGFloat = 30

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.viewModel.totalSequences, id: \.self) { sequenceIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.viewModel.totalExercisesInCurrentSequence, id: \.self) { exerciseIndex in
                        let markerColor = self.progressBarMarkerColor(sequence: sequenceIndex, exercise: exerciseIndex)

                        let isCurrentSequence = sequenceIndex == self.viewModel.currentSequenceIndex
                        let isCurrentExercise = isCurrentSequence && exerciseIndex == self.viewModel.currentExerciseIndexInSequence
                        let isNotYetCompleted = self.viewModel.currentExerciseSharedData.isExerciseNotYetCompleted

                        let isCurrentlyPlaying = isCurrentExercise && isNotYetCompleted

                        ActivityProgressBarMarker(
                            color: (isCurrentSequence && isCurrentExercise)
                                ? self.$currentColor : .constant(markerColor),
                            isCurrentlyPlaying: .constant(isCurrentlyPlaying)
                        )
                        .padding(6)
                        .onChange(of: self.viewModel.currentExerciseSharedData.state) { newState in
                            if case let .completed(level) = newState {
                                withAnimation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)) {
                                    self.currentColor = self.completionLevelToColor(level: level)
                                }
                            }
                        }

                        if exerciseIndex < self.viewModel.totalExercisesInCurrentSequence - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: self.height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if sequenceIndex < self.viewModel.totalSequences - 1 {
                    Spacer().frame(minWidth: 20, maxWidth: 60)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    @State private var currentColor: Color = .white

    private func completionLevelToColor(level: ExerciseState.CompletionLevel?) -> Color {
        switch level {
            case .excellent:
                .green
            case .good:
                .orange
            case .average,
                 .belowAverage,
                 .fail:
                .red
            case .nonApplicable,
                 .none:
                .gray
        }
    }

    private func progressBarMarkerColor(sequence: Int, exercise: Int) -> Color {
        if let completedExerciseSharedData = self.viewModel.completedExercisesSharedData.first(where: {
            $0.sequenceIndex == sequence
                && $0.exerciseIndex == exercise
        }) {
            self.completionLevelToColor(level: completedExerciseSharedData.completionLevel)
        } else {
            .white
        }
    }
}
