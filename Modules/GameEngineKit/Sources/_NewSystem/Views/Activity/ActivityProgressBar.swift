// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
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
            ForEach(0..<viewModel.totalSequences, id: \.self) { sequenceIndex in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.totalExercisesInCurrentSequence, id: \.self) { exerciseIndex in
                        let dotColor: Color = {
                            guard
                                sequenceIndex < viewModel.currentSequenceIndex
                                || (sequenceIndex == viewModel.currentSequenceIndex
                                    && exerciseIndex < viewModel.currentExerciseIndexInSequence)
                            else {
                                return .white
                            }
                            return .green
                        }()
                        let isCurrentExercise: Bool = sequenceIndex == viewModel.currentSequenceIndex
                            && exerciseIndex == viewModel.currentExerciseIndexInSequence
                            && viewModel.currentExerciseSharedData.state != .completed
                        ActivityProgressBarMarker(
                            color: (sequenceIndex == viewModel.currentSequenceIndex
                                && exerciseIndex == viewModel.currentExerciseIndexInSequence)
                                ? $currentColor : .constant(dotColor),
                            isCurrent: .constant(isCurrentExercise)
                        )
                        .padding(6)
                        .onChange(of: viewModel.currentExerciseSharedData.state) { newValue in
                            if newValue == .completed {
                                withAnimation(.snappy.delay(2)) {
                                    currentColor = .green
                                }
                            }
                        }

                        if exerciseIndex < viewModel.totalExercisesInCurrentSequence - 1 {
                            Spacer().frame(maxWidth: 100)
                        }
                    }
                }
                .frame(height: height)
                .background(DesignKitAsset.Colors.progressBar.swiftUIColor, in: Capsule())

                if sequenceIndex < viewModel.totalSequences - 1 {
                    Spacer().frame(minWidth: 20, maxWidth: 60)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    @State private var currentColor: Color = .white
}
