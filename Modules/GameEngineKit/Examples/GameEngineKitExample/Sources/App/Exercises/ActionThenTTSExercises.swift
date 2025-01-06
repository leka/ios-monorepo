// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenTTSExercises: View {
    var body: some View {
        Text("Action Then TTS")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Answers", color: .blue)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Answers", color: .blue)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Audio Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Answers", color: .blue)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .speech("Correct answer")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Speech Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Answers", color: .blue)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .robot(type: .color("blue")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot & Right Answers", color: .blue)
                }
            }
        }
    }
}

#Preview {
    ActionThenTTSExercises()
}
