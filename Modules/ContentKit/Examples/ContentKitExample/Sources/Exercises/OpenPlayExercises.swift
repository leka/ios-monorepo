// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - OpenPlay

struct OpenPlayExercises: View {
    var body: some View {
        Text("Choose Any Answers")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorOpenPlay(
                        choices: ExerciseData.kOpenPlayDefault,
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

                NavigationLink {
                    let coordinator = DnDGridWithZonesCoordinatorOpenPlay(
                        choices: ExerciseData.kOpenPlayWithZonesChoicesEmojis,
                        minimumToSelect: 1,
                        maximumToSelect: 3
                    )
                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                    return DnDGridWithZonesView(viewModel: viewModel)
                        .navigationTitle("WithZones")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "WithZones", color: .pink)
                }
            }
        }
    }
}

#Preview {
    OpenPlayExercises()
}
