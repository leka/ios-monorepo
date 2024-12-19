// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ActionThenTTSExercises: View {
    var body: some View {
        Text("Action Then TTS")
            .font(.title)
            .padding(.bottom)
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .image("sport_dance_player_man")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Find The Right Answers")
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
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .ipad(type: .sfsymbol("star")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol Then Find The Right Answers")
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
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .audio("sound_animal_duck")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Audio Then Find The Right Answers")
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
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay,
                                                                        action: .ipad(type: .speech("Correct answer")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Speech Then Find The Right Answers")
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
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay, action: .robot(type: .color("red")))
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Then Find The Right Answers")
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
    ActionThenTTSExercises()
}
