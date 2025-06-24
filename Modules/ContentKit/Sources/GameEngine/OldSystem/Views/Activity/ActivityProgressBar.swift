// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBar: View {
    // MARK: Internal

    @ObservedObject var viewModel: ActivityViewViewModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.viewModel.totalGroups, id: \.self) { groupIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.viewModel.groupSizeEnumeration[groupIndex], id: \.self) { exerciseIndex in
                        let markerColor = self.progressBarMarkerColor(group: groupIndex, exercise: exerciseIndex)

                        let isCurrentGroup = groupIndex == self.viewModel.currentGroupIndex
                        let isCurrentExercise = isCurrentGroup && exerciseIndex == self.viewModel.currentExerciseIndexInCurrentGroup
                        let isNotYetCompleted = self.viewModel.currentExerciseSharedData.isExerciseNotYetCompleted

                        let isCurrentlyPlaying = isCurrentExercise && isNotYetCompleted

                        ActivityProgressBarMarker(
                            color: (isCurrentGroup && isCurrentExercise)
                                ? self.$currentColor : .constant(markerColor),
                            isCurrentlyPlaying: .constant(isCurrentlyPlaying)
                        )
                        .padding(6)
                        .onChange(of: self.viewModel.currentExerciseSharedData.state) {
                            if case let .completed(level) = self.viewModel.currentExerciseSharedData.state {
                                withAnimation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)) {
                                    self.currentColor = self.completionLevelToColor(level: level)
                                }
                            }
                        }

                        if exerciseIndex < self.viewModel.groupSizeEnumeration[groupIndex] - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: self.height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if groupIndex < self.viewModel.totalGroups - 1 {
                    Spacer().frame(minWidth: 20, maxWidth: 60)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    private let height: CGFloat = 30

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

    private func progressBarMarkerColor(group: Int, exercise: Int) -> Color {
        if let completedExerciseSharedData = self.viewModel.completedExercisesSharedData.first(where: {
            $0.groupIndex == group
                && $0.exerciseIndex == exercise
        }) {
            self.completionLevelToColor(level: completedExerciseSharedData.completionLevel)
        } else {
            .white
        }
    }
}
