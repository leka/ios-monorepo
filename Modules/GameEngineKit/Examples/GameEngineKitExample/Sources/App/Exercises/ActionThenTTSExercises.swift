// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

extension ExerciseData {
    static let ActionThenTTSexFindTheRightAnswers: [TTSCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Choice 1\nCorrect", isRightAnswer: true),
        .init(value: "Choice 2", isRightAnswer: false),
        .init(value: "Choice 3\nCorrect", isRightAnswer: true),
        .init(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        .init(value: "Choice 5\nCorrect", isRightAnswer: true),
        .init(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}

// MARK: - ActionThenTTSExercises

struct ActionThenTTSExercises: View {
    var body: some View {
        Text("Action Then TTS")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .ipad(type: .image("sport_dance_player_man"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe Image Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe Image & Right Answers", color: .blue)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .ipad(type: .sfsymbol("star"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Observe SFSymbol Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Observe SFSymbol & Right Answers", color: .blue)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .ipad(type: .audio("sound_animal_duck"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Audio Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Audio & Right Answers", color: .blue)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .ipad(type: .speech("Correct answer"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Listen Speech Then Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Listen Speech & Right Answers", color: .blue)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .robot(type: .color("blue"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Color & Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Color & Right Answers", color: .blue)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.ActionThenTTSexFindTheRightAnswers,
                        action: .robot(type: .image("robotFaceHappy"))
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Robot Screen & Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Robot Screen & Right Answers", color: .blue)
                }
            }
        }
    }
}

#Preview {
    ActionThenTTSExercises()
}
