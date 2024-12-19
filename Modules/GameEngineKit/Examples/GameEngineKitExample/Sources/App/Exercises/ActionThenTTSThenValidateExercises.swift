// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenTTSThenValidateExercises: View {
    var body: some View {
        Text("Action Then TTS Then Validate")
            .font(.title)
            .padding(.bottom)
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe Image")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Observe Image")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Observe SFSymbol")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Listen Audio")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                                    action: .ipad(type: .speech("Correct answer")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Listen Speech")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .robot(type: .color("red")))
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Robot")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Robot")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.indigo).shadow(radius: 1))
                }
            }
        }
    }
}

#Preview {
    ActionThenTTSThenValidateExercises()
}
