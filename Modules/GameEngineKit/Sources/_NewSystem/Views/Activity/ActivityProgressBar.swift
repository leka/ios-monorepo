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
                        let dotColor: Color = {
                            guard sequenceIndex < self.viewModel.currentSequenceIndex
                                || (sequenceIndex == self.viewModel.currentSequenceIndex
                                    && exerciseIndex < self.viewModel.currentExerciseIndexInSequence)
                            else {
                                return .white
                            }
                            return .green
                        }()
                        let isCurrentExercise: Bool = sequenceIndex == self.viewModel.currentSequenceIndex
                            && exerciseIndex == self.viewModel.currentExerciseIndexInSequence
                            && self.viewModel.currentExerciseSharedData.state != .completed
                        ActivityProgressBarMarker(
                            color: (sequenceIndex == self.viewModel.currentSequenceIndex
                                && exerciseIndex == self.viewModel.currentExerciseIndexInSequence)
                                ? self.$currentColor : .constant(dotColor),
                            isCurrent: .constant(isCurrentExercise)
                        )
                        .padding(6)
                        .onChange(of: self.viewModel.currentExerciseSharedData.state) { newValue in
                            if newValue == .completed {
                                withAnimation(.snappy.delay(self.viewModel.delayAfterReinforcerAnimation)) {
                                    self.currentColor = .green
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
