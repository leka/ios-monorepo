// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// TODO: (@ladislas) to remove in the future, replaced by actual data
extension ExerciseData {
    static let TTSxFindTheRightAnswers: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Choice 1\nCorrect", isRightAnswer: true),
        .init(value: "Choice 2", isRightAnswer: false),
        .init(value: "Choice 3\nCorrect", isRightAnswer: true),
        .init(value: "checkmark.seal.fill", isRightAnswer: true, type: .sfsymbol),
        .init(value: "Choice 5\nCorrect", isRightAnswer: true),
        .init(value: "exclamationmark.triangle.fill", isRightAnswer: false, type: .sfsymbol),
    ]
}

// MARK: - TTSExercises

struct TTSExercises: View {
    var body: some View {
        Text("TTS")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                        choices: ExerciseData.TTSxFindTheRightAnswers,
                        action: nil
                    )
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Answers")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Answers", color: .indigo)
                }

                NavigationLink {
                    let gameplay = NewGameplayFindTheRightOrder(choices: NewGameplayFindTheRightOrder.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Find The Right Order")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Right Order", color: .indigo)
                }

                NavigationLink {
                    let coordinator = TTSCoordinatorAssociateCategories(choices: ExerciseData.AssociateCategoriesChoicesDefault)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Categories", color: .indigo)
                }

                NavigationLink {
                    let coordinator = MemoryCoordinatorAssociateCategories(choices: ExerciseData.AssociateCategoriesChoicesDefault)
                    let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                    return NewMemoryView(viewModel: viewModel)
                        .navigationTitle("Memory")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Memory", color: .indigo)
                }
            }
        }
    }
}

#Preview {
    TTSExercises()
}
