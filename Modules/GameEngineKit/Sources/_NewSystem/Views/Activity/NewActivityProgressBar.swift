// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - NewActivityProgressBar

struct NewActivityProgressBar: View {
    // MARK: Internal

    @ObservedObject var manager: ActivityExercisesCoordinator

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.manager.numberOfGroups, id: \.self) { groupIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.manager.groupSizeEnumeration[groupIndex], id: \.self) { exerciseIndex in
                        let markerColor = self.progressBarMarkerColor(group: groupIndex, exercise: exerciseIndex)

                        let isCurrentGroup = groupIndex == self.manager.currentGroupIndex
                        let isCurrentExercise = isCurrentGroup && exerciseIndex == self.manager.currentExerciseIndex
//                        let isNotYetCompleted = self.manager.currentExerciseSharedData.isExerciseNotYetCompleted

                        let isCurrentlyPlaying = isCurrentExercise
//                        && isNotYetCompleted

                        ActivityProgressBarMarker(
                            color: (isCurrentGroup && isCurrentExercise)
                                ? self.$currentColor : .constant(markerColor),
                            isCurrentlyPlaying: .constant(isCurrentlyPlaying)
                        )
                        .padding(6)
//                        .onChange(of: self.manager.currentExerciseIndex) { newState in
//                            if case let .completed(level) = newState {
//                                withAnimation(.snappy.delay(self.manager.delayAfterReinforcerAnimation)) {
//                                    self.currentColor = self.completionLevelToColor(level: level)
//                                }
//                            }
//                        }

                        if exerciseIndex < self.manager.groupSizeEnumeration[groupIndex] - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: self.height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if groupIndex < self.manager.numberOfGroups - 1 {
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

    private func progressBarMarkerColor(group _: Int, exercise _: Int) -> Color {
//        if let completedExerciseSharedData = self.manager.completedExercisesSharedData.first(where: {
//            $0.groupIndex == group
//                && $0.exerciseIndex == exercise
//        }) {
//            self.completionLevelToColor(level: completedExerciseSharedData.completionLevel)
//        } else {
//            .white
//        }
        .white
    }
}
