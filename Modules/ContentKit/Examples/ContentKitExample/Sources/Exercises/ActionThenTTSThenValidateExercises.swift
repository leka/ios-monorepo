// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ActionThenTTSThenValidateExercises

struct ActionThenTTSThenValidateExercises: View {
    var body: some View {
        Text("Action Then TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesEmojis,
                        action: .ipad(type: .image("sport_dance_player_man")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe Image")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesSFSymbols,
                        action: .ipad(type: .sfsymbol("star")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesDefault,
                        action: .ipad(type: .audio("sound_animal_duck")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesImages,
                        action: .ipad(type: .speech("happy")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesColors,
                        action: .robot(type: .color("blue")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Color")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.kFindTheRightAnswersChoicesImages,
                        action: .robot(type: .image("robotFaceHappy")),
                        validation: .init(type: .manual)
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Screen")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Screen & Right Answer", color: .mint)
                }
            }
        }
    }
}

#Preview {
    ActionThenTTSThenValidateExercises()
}
