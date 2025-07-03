// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI
import UtilsKit

// MARK: - NewActivityProgressBarMarker

struct NewActivityProgressBarMarker: View {
    var color: Color
    var isCurrentlyPlaying: Bool

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(self.color, in: Circle())
            .overlay {
                if self.isCurrentlyPlaying {
                    Circle()
                        .fill(DesignKitAsset.Colors.chevron.swiftUIColor)
                        .padding(4)
                }
            }
    }
}

// MARK: - NewActivityProgressBar

struct NewActivityProgressBar: View {
    // MARK: Internal

    var coordinator: ActivityCoordinator

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.coordinator.numberOfGroups, id: \.self) { groupIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.coordinator.groupSizeEnumeration[groupIndex], id: \.self) { exerciseIndex in
                        let markerColor = self.progressBarMarkerColor(group: groupIndex, exercise: exerciseIndex)

                        NewActivityProgressBarMarker(
                            color: markerColor,
                            isCurrentlyPlaying: self.isCurrentlyPlaying(group: groupIndex, exercise: exerciseIndex)
                        )
                        .padding(6)

                        if exerciseIndex < self.coordinator.groupSizeEnumeration[groupIndex] - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: self.height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if groupIndex < self.coordinator.numberOfGroups - 1 {
                    Spacer().frame(minWidth: 20, maxWidth: 60)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    private let height: CGFloat = 30

    private func completionLevelToColor(level: ExerciseCompletionLevel?) -> Color {
        switch level {
            case .excellent:
                .green
            case .good:
                .orange
            case .average,
                 .belowAverage,
                 .fail:
                .red
            case .notApplicable:
                .green
            case .none:
                .white
        }
    }

    private func isCurrentlyPlaying(group: Int, exercise: Int) -> Bool {
        let isCurrentGroup = group == self.coordinator.currentGroupIndex
        let isCurrentExercise = isCurrentGroup && exercise == self.coordinator.currentExerciseIndex
        let isCurrentlyPlaying = isCurrentGroup && isCurrentExercise

        let isExerciseCompleted = self.coordinator.isExerciseCompleted

        return isCurrentlyPlaying && !isExerciseCompleted
    }

    private func progressBarMarkerColor(group: Int, exercise: Int) -> Color {
        if let level = self.coordinator.exercisesCompletionData[safe: group]?[safe: exercise]?.level {
            self.completionLevelToColor(level: level)
        } else {
            .white
        }
    }
}
