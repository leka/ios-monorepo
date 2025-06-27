// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DesignKit
import SwiftUI

// MARK: - ActivityProgressBarViewModel

@Observable
class ActivityProgressBarViewModel {
    // MARK: Lifecycle

    init(coordinator: ActivityCoordinator) {
        logGEK.debug("Initializing ActivityProgressBarViewModel with coordinator: \(coordinator)")
        self.coordinator = coordinator
        self.coordinator.exerciseEvent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { event in
                switch event {
                    case .didStart:
                        logGEK.debug("Received start event")
                    case let .didEnd(groupIndex, exerciseIndex, withSuccess):
                        logGEK.debug("Received end event: groupIndex: \(groupIndex), exerciseIndex: \(exerciseIndex), withSuccess: \(withSuccess)")
                }
            })
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public var currentColor: Color = .white
    public var coordinator: ActivityCoordinator

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []
}

// MARK: - NewActivityProgressBarMarker

struct NewActivityProgressBarMarker: View {
    var color: Color
    var isCurrentlyPlaying: Bool

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(self.color, in: Circle())
            .overlay {
                Circle()
                    .fill(DesignKitAsset.Colors.chevron.swiftUIColor)
                    .padding(4)
                    .scaleEffect(self.isCurrentlyPlaying ? 1 : 0.01)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: self.isCurrentlyPlaying)
            }
    }
}

// MARK: - NewActivityProgressBar

struct NewActivityProgressBar: View {
    // MARK: Lifecycle

    init(coordinator: ActivityCoordinator) {
        self.viewModel = ActivityProgressBarViewModel(coordinator: coordinator)
    }

    // MARK: Internal

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.viewModel.coordinator.numberOfGroups, id: \.self) { groupIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.viewModel.coordinator.groupSizeEnumeration[groupIndex], id: \.self) { exerciseIndex in
                        let markerColor = self.progressBarMarkerColor(group: groupIndex, exercise: exerciseIndex)

                        let isCurrentGroup = groupIndex == self.viewModel.coordinator.currentGroupIndex
                        let isCurrentExercise = isCurrentGroup && exerciseIndex == self.viewModel.coordinator.currentExerciseIndex
//                        let isNotYetCompleted = self.manager.currentExerciseSharedData.isExerciseNotYetCompleted

                        let isCurrentlyPlaying = isCurrentExercise
//                        && isNotYetCompleted

                        NewActivityProgressBarMarker(
                            color: (isCurrentGroup && isCurrentExercise)
                                ? self.viewModel.currentColor : markerColor,
                            isCurrentlyPlaying: isCurrentlyPlaying
                        )
                        .padding(6)
//                        .onChange(of: self.manager.currentExerciseIndex) { newState in
//                            if case let .completed(level) = newState {
//                                withAnimation(.snappy.delay(self.manager.delayAfterReinforcerAnimation)) {
//                                    self.currentColor = self.completionLevelToColor(level: level)
//                                }
//                            }
//                        }

                        if exerciseIndex < self.viewModel.coordinator.groupSizeEnumeration[groupIndex] - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: self.height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if groupIndex < self.viewModel.coordinator.numberOfGroups - 1 {
                    Spacer().frame(minWidth: 20, maxWidth: 60)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    private var viewModel: ActivityProgressBarViewModel

//    @State private var currentColor: Color = .white
//
//    private var coordinator: ActivityCoordinator
//    private var cancellables: Set<AnyCancellable> = []

    private let height: CGFloat = 30

    private var canvasColor: Color {
        DesignKitAsset.Colors.progressBar.swiftUIColor
    }

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
