// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBar: View {
    // MARK: Internal

    @ObservedObject var viewModel: ActivityViewViewModel
    let height: CGFloat = 30

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<self.viewModel.totalSequences, id: \.self) { sequenceIndex in
                HStack(spacing: 0) {
                    ForEach(0..<self.viewModel.totalExercisesInCurrentSequence, id: \.self) { exerciseIndex in
                        let dotColor: Color = if let completedExerciseSharedData = self.viewModel.completedExercisesSharedData.first(where: {
                            $0.sequenceIndex == sequenceIndex
                                && $0.exerciseIndex == exerciseIndex
                        }) {
                            switch completedExerciseSharedData.completionLevel {
                                case .excellent:
                                    .green
                                case .good:
                                    .orange
                                case .fail,
                                     .average,
                                     .belowAverage:
                                    .red
                                case .none,
                                     .nonApplicable:
                                    .gray
                            }
                        } else {
                            .white
                        }

                        let isCurrentExercise: Bool = sequenceIndex == self.viewModel.currentSequenceIndex
                            && exerciseIndex == self.viewModel.currentExerciseIndexInSequence
                            && {
                                switch self.viewModel.currentExerciseSharedData.state {
                                    case .completed:
                                        false
                                    default:
                                        true
                                }
                            }()

                        ActivityProgressBarMarker(
                            color: (sequenceIndex == self.viewModel.currentSequenceIndex
                                && exerciseIndex == self.viewModel.currentExerciseIndexInSequence)
                                ? self.$currentColor : .constant(dotColor),
                            isCurrent: .constant(isCurrentExercise)
                        )
                        .padding(6)
                        .onChange(of: self.viewModel.currentExerciseSharedData.state) { newValue in
                            if case let .completed(level) = newValue {
                                withAnimation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)) {
                                    switch level {
                                        case .excellent:
                                            self.currentColor = .green
                                        case .good:
                                            self.currentColor = .orange
                                        case .average,
                                             .belowAverage,
                                             .fail:
                                            self.currentColor = .red
                                        case .nonApplicable:
                                            self.currentColor = .gray
                                    }
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
}
