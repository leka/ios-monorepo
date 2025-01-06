// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct TTSExercises: View {
    var body: some View {
        Text("TTS")
            .font(.title)
            .padding()
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                NavigationLink {
                    let gameplay = NewGameplayFindTheRightAnswers(choices: NewGameplayFindTheRightAnswers.kDefaultChoices)
                    let coordinator = TTSCoordinatorFindTheRightAnswers(gameplay: gameplay)
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
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                    let coordinator = TTSCoordinatorAssociateCategories(gameplay: gameplay)
                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                    return TTSView(viewModel: viewModel)
                        .navigationTitle("Associate Categories")
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    ExerciseNavigationButtonLabel(text: "Categories", color: .indigo)
                }

                NavigationLink {
                    let gameplay = NewGameplayAssociateCategories(choices: NewGameplayAssociateCategories.kDefaultChoices)
                    let coordinator = MemoryCoordinatorAssociateCategories(gameplay: gameplay)
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
