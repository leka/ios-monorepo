// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - NoGameplayExercises

struct NoGameplayExercises: View {
    var body: some View {
        Text("Choose Any Answers")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorNoGameplay(
                        choices: ExerciseData.kNoGameplayDefault,
                        minimumToSelect: 1,
                        maximumToSelect: 3
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
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
