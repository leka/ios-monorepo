// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - ExerciseData

// TODO: (@ladislas) to remove in the future, replaced by actual data
extension ExerciseData {
    static let TTSActionThenValidatexFindTheRightAnswers: [TTSCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Choice 1\nCorrect", isRightAnswer: true),
        .init(value: "Choice 2", isRightAnswer: false),
        .init(value: "Choice 3\nCorrect", isRightAnswer: true),
        .init(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        .init(value: "Choice 5\nCorrect", isRightAnswer: true),
        .init(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}

// MARK: - ActionThenTTSThenValidateExercises

struct ActionThenTTSThenValidateExercises: View {
    var body: some View {
        Text("Action Then TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .ipad(type: .image("sport_dance_player_man"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe Image")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .ipad(type: .sfsymbol("star"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .ipad(type: .audio("sound_animal_duck"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Audio")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .ipad(type: .speech("Correct answer"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Listen Speech")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .robot(type: .color("mint"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
                        .navigationTitle("Robot Color")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot & Right Answers", color: .mint)
                }

                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSActionThenValidatexFindTheRightAnswers,
                        action: .robot(type: .image("robotFaceHappy"))
                    )
                    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

                    return TTSThenValidateView(viewModel: viewModel)
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
