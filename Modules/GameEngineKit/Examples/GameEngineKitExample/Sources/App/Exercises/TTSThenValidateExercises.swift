// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - ExerciseData

extension ExerciseData {
    static let TTSThenValidatexFindTheRightAnswers: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Choice 1\nCorrect", isRightAnswer: true),
        .init(value: "Choice 2", isRightAnswer: false),
        .init(value: "Choice 3\nCorrect", isRightAnswer: true),
        .init(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        .init(value: "Choice 5\nCorrect", isRightAnswer: true),
        .init(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}

// MARK: - TTSThenValidateExercises

struct TTSThenValidateExercises: View {
    var body: some View {
        Text("TTS Then Validate")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSThenValidateCoordinatorFindTheRightAnswers(choices: ExerciseData.TTSThenValidatexFindTheRightAnswers)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers", color: .cyan)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(choices: ExerciseData.TTSThenValidatexFindTheRightAnswers,
                                                                        validationEnabled: false)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers All At Once")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers All At Once", color: .cyan)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightOrder(choices: ExerciseData.FindTheRightOrderChoicesSFSymbols,
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
