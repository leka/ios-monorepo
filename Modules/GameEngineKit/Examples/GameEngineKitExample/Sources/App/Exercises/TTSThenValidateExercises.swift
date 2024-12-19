// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// swiftlint:disable multiple_closure_with_trailing_closure

struct TTSThenValidateExercises: View {
    var body: some View {
        Text("TTS Then Validate")
            .font(.title)
            .padding(.bottom)
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 6 Choices")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 6 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<5]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 5 Choices")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 5 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<4]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 4 Choices")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 4 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<3]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 3 Choices")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 3 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<2]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 2 Choices")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 2 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }

                NavigationLink(destination: {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: Array(NewGameplayFindTheRightAnswers.kDefaultChoices[0..<1]))
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(gameplay: gameplay)
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers - 1 Choice")
                        .navigationBarTitleDisplayMode(.large)
                }) {
                    Text("Find The Right Answers - 1 Choices")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, height: 133)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.yellow).shadow(radius: 1))
                }
            }
        }
    }
}

// swiftlint:disable multiple_closure_with_trailing_closure

#Preview {
    TTSThenValidateExercises()
}
