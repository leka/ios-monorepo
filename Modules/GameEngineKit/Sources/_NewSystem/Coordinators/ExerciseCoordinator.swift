// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ExerciseCoordinator

public class ExerciseCoordinator {
    // MARK: Lifecycle

    public init(exercise: NewExercise) {
        self.exercise = exercise
    }

    // MARK: Public

    @ViewBuilder
    public var exerciseView: some View {
        if case let .general(interface) = self.exercise.interface {
            if let gameplay = self.exercise.gameplay, let payload = self.exercise.payload {
                switch interface {
                    case .touchToSelect:
                        switch gameplay {
                            case .associateCategories:
                                let model = CoordinatorAssociateCategoriesModel(data: payload)
                                let coordinator = TTSCoordinatorAssociateCategories(model: model)
                                let viewModel = TTSViewViewModel(coordinator: coordinator)

                                TTSView(viewModel: viewModel)

                            case .findTheRightAnswers:
                                let model = CoordinatorFindTheRightAnswersModel(data: payload)
                                let coordinator = TTSCoordinatorFindTheRightAnswers(model: model)
                                let viewModel = TTSViewViewModel(coordinator: coordinator)

                                TTSView(viewModel: viewModel)

                            case .findTheRightOrder:
                                let model = CoordinatorFindTheRightOrderModel(data: payload)
                                let coordinator = TTSCoordinatorFindTheRightOrder(model: model)
                                let viewModel = TTSViewViewModel(coordinator: coordinator)

                                TTSView(viewModel: viewModel)

                            case .openPlay:
                                let model = CoordinatorOpenPlayModel(data: payload)
                                let coordinator = TTSCoordinatorOpenPlay(model: model)
                                let viewModel = TTSViewViewModel(coordinator: coordinator)

                                TTSView(viewModel: viewModel)
                        }

                    case .dragAndDropGrid:
                        switch gameplay {
                            case .associateCategories:
                                let model = CoordinatorAssociateCategoriesModel(data: payload)
                                let coordinator = DnDGridCoordinatorAssociateCategories(model: model)
                                let viewModel = DnDGridViewModel(coordinator: coordinator)

                                DnDGridView(viewModel: viewModel)

                            default:
                                // TODO: (@ladislas) - handle wrong combinations
                                PlaceholderExerciseView()
                        }

                    case .dragAndDropGridWithZones:
                        switch gameplay {
                            case .associateCategories:
                                let model = CoordinatorAssociateCategoriesModel(data: payload)
                                let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(model: model)
                                let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                                DnDGridWithZonesView(viewModel: viewModel)

                            case .openPlay:
                                let model = CoordinatorOpenPlayModel(data: payload)
                                let coordinator = DnDGridWithZonesCoordinatorOpenPlay(model: model)
                                let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                                DnDGridWithZonesView(viewModel: viewModel)

                            default:
                                // TODO: (@ladislas) - handle wrong combinations
                                PlaceholderExerciseView()
                        }

                    case .dragAndDropOneToOne:
                        switch gameplay {
                            case .findTheRightOrder:
                                let model = CoordinatorFindTheRightOrderModel(data: payload)
                                let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(model: model)
                                let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                                DnDOneToOneView(viewModel: viewModel)

                            default:
                                // TODO: (@ladislas) - handle wrong combinations
                                PlaceholderExerciseView()
                        }

                    case .memory:
                        switch gameplay {
                            case .associateCategories:
                                let model = CoordinatorAssociateCategoriesModel(data: payload)
                                let coordinator = MemoryCoordinatorAssociateCategories(model: model)
                                let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                                NewMemoryView(viewModel: viewModel)

                            default:
                                // TODO: (@ladislas) - handle wrong combinations
                                PlaceholderExerciseView()
                        }

                    case .magicCards:
                        switch gameplay {
                            default:
                                PlaceholderExerciseView()
                        }
                }
            } else {
                // TODO: (@ladislas) - handle missing gameplay
                PlaceholderExerciseView()
            }
        }

        if case let .specialized(interface) = self.exercise.interface {
            switch interface {
                default:
                    PlaceholderExerciseView()
            }
        }
    }

    // MARK: Private

    private let exercise: NewExercise
}
