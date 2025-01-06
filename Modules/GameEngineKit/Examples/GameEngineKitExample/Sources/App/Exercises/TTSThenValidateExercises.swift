// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct TTSThenValidateExercises: View {
    var body: some View {
        Text("TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers", color: .cyan)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<5]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswersAllAtOnce(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers All At Once")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers All At Once", color: .cyan)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightOrder(choices: Array(NewGameplayFindTheRightOrder.kDefaultChoices[0..<3]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightOrder(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
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
