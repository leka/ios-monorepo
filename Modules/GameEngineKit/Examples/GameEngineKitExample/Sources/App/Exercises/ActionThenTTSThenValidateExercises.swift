// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenTTSThenValidateExercises: View {
    var body: some View {
        Text("Action Then TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe Image")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Answers", color: .mint)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Answers", color: .mint)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Answers", color: .mint)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .speech("Correct answer")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Answers", color: .mint)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .robot(type: .color("mint")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Robot")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot & Right Answers", color: .mint)
                }
            }
        }
    }
}

#Preview {
    ActionThenTTSThenValidateExercises()
}
