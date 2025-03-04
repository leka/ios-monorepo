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
            switch interface {
                case .touchToSelect:
                    switch self.exercise.gameplay {
                        case .associateCategories:
                            let model = CoordinatorAssociateCategoriesModel(data: self.exercise.payload!)!
                            let coordinator = TTSCoordinatorAssociateCategories(model: model)
                            let viewModel = TTSViewViewModel(coordinator: coordinator)

                            TTSView(viewModel: viewModel)

                        case .findTheRightAnswers:
                            let model = CoordinatorFindTheRightAnswersModel(data: self.exercise.payload!)!
                            let coordinator = TTSCoordinatorFindTheRightAnswers(model: model)
                            let viewModel = TTSViewViewModel(coordinator: coordinator)

                            TTSView(viewModel: viewModel)

                        case .findTheRightOrder:
                            let model = CoordinatorFindTheRightOrderModel(data: self.exercise.payload!)!
                            let coordinator = TTSCoordinatorFindTheRightOrder(model: model)
                            let viewModel = TTSViewViewModel(coordinator: coordinator)

                            TTSView(viewModel: viewModel)

                        case .openPlay:
                            let model = CoordinatorOpenPlayModel(data: self.exercise.payload!)!
                            let coordinator = TTSCoordinatorOpenPlay(model: model)
                            let viewModel = TTSViewViewModel(coordinator: coordinator)

                            TTSView(viewModel: viewModel)

                        case .none:
                            // TODO: (@ladislas) - handle missing gameplay
                            PlaceholderExerciseView()
                    }

                case .dragAndDropGrid:
                    switch self.exercise.gameplay {
                        case .associateCategories:
                            let model = CoordinatorAssociateCategoriesModel(data: self.exercise.payload!)!
                            let coordinator = DnDGridCoordinatorAssociateCategories(model: model)
                            let viewModel = DnDGridViewModel(coordinator: coordinator)

                            DnDGridView(viewModel: viewModel)

                        default:
                            // TODO: (@ladislas) - handle wrong combinations
                            PlaceholderExerciseView()
                    }

                case .dragAndDropGridWithZones:
                    switch self.exercise.gameplay {
                        case .associateCategories:
                            let model = CoordinatorAssociateCategoriesModel(data: self.exercise.payload!)!
                            let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(model: model)
                            let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                            DnDGridWithZonesView(viewModel: viewModel)

                        case .openPlay:
                            let model = CoordinatorOpenPlayModel(data: self.exercise.payload!)!
                            let coordinator = DnDGridWithZonesCoordinatorOpenPlay(model: model)
                            let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                            DnDGridWithZonesView(viewModel: viewModel)

                        default:
                            // TODO: (@ladislas) - handle wrong combinations
                            PlaceholderExerciseView()
                    }

                case .dragAndDropOneToOne:
                    switch self.exercise.gameplay {
                        case .findTheRightOrder:
                            let model = CoordinatorFindTheRightOrderModel(data: self.exercise.payload!)!
                            let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(model: model)
                            let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                            DnDOneToOneView(viewModel: viewModel)

                        default:
                            // TODO: (@ladislas) - handle wrong combinations
                            PlaceholderExerciseView()
                    }

                case .memory:
                    switch self.exercise.gameplay {
                        case .associateCategories:
                            let model = CoordinatorAssociateCategoriesModel(data: self.exercise.payload!)!
                            let coordinator = MemoryCoordinatorAssociateCategories(model: model)
                            let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                            NewMemoryView(viewModel: viewModel)

                        default:
                            // TODO: (@ladislas) - handle wrong combinations
                            PlaceholderExerciseView()
                    }

                case .magicCards:
                    switch self.exercise.gameplay {
                        default:
                            PlaceholderExerciseView()
                    }
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
