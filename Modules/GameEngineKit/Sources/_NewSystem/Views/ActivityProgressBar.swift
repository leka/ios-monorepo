// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// ? ChatGPT: Just for fun implementation -- not working correclty
// TODO(@ladislas): to be removed and replaced by real implementation
struct ActivityProgressBar: View {
    @ObservedObject var viewModel: ActivityViewViewModel

    var body: some View {
        GeometryReader { geometry in
            let sequenceWidth: CGFloat = geometry.size.width / CGFloat(viewModel.totalSequences)

            ZStack(alignment: .leading) {
                // Draw all the sequences with rounded ends
                ForEach(0..<viewModel.totalSequences, id: \.self) { sequenceIndex in
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: sequenceWidth - 50)
                        .offset(x: sequenceWidth * CGFloat(sequenceIndex))
                }

                // Draw the dots for exercises in all sequences
                ForEach(0..<viewModel.totalSequences, id: \.self) { sequenceIndex in
                    let exercisesInSequence =
                        (sequenceIndex == viewModel.currentSequenceIndex)
                        ? viewModel.totalExercisesInCurrentSequence : 2

                    ForEach(0..<exercisesInSequence, id: \.self) { exerciseIndex in
                        let dotSpacing = sequenceWidth / CGFloat(exercisesInSequence + 1)

                        // Determine the dot color
                        let dotColor: Color = {
                            if sequenceIndex < viewModel.currentSequenceIndex
                                || (sequenceIndex == viewModel.currentSequenceIndex
                                    && exerciseIndex < viewModel.currentExerciseIndexInSequence)
                            {
                                return .green
                            } else if sequenceIndex == viewModel.currentSequenceIndex
                                && exerciseIndex == viewModel.currentExerciseIndexInSequence
                            {
                                return .blue
                            } else {
                                return .gray
                            }
                        }()

                        Circle()
                            .fill(dotColor)
                            .frame(width: 12, height: 12)
                            .offset(x: sequenceWidth * CGFloat(sequenceIndex) + dotSpacing * CGFloat(exerciseIndex + 1))
                    }
                }
            }
        }
        .frame(height: 24)
    }
}
