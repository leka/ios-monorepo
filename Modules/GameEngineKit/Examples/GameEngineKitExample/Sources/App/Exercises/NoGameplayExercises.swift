// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - ExerciseData

extension ExerciseData {
    static let TTSThenValidatexNoGameplay: [TTSCoordinatorNoGameplayChoiceModel] = [
        .init(value: "Choice 1\nCorrect"),
        .init(value: "Choice 2"),
        .init(value: "Choice 3\nCorrect"),
        .init(value: "checkmark.seal.fill", type: .sfsymbol),
        .init(value: "Choice 5\nCorrect"),
        .init(value: "exclamationmark.triangle.fill", type: .sfsymbol),
    ]
}

// MARK: - NoGameplayExercises

struct NoGameplayExercises: View {
    var body: some View {
        Text("Choose Any Answers")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorNoGameplay(
                        choices: ExerciseData.TTSThenValidatexNoGameplay,
                        minimumToSelect: 1,
                        maximumToSelect: 3
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("TTS")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "TTS", color: .pink)
                }
            }
        }
    }
}

#Preview {
    NoGameplayExercises()
}
