// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - TTSThenValidateExercises

struct TTSThenValidateExercises: View {
    var body: some View {
        Text("TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(choices: ExerciseData.kFindTheRightAnswersChoicesDefault,
                                                                        validationEnabled: false)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers All At Once")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers All At Once", color: .cyan)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightOrder(choices: ExerciseData.kFindTheRightOrderChoicesSFSymbols,
                                                                      validationEnabled: false)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Order", color: .cyan)
                }
            }
        }
    }
}

#Preview {
    TTSThenValidateExercises()
}
