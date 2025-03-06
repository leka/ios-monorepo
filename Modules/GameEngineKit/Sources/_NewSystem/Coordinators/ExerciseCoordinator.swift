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
        VStack {
            if let instructions = exercise.instructions {
                ExerciseInstructionsButton(instructions: instructions)
            }

            Spacer()

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
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
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
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                            }

                        case .dragAndDropOneToOne:
                            switch gameplay {
                                case .findTheRightOrder:
                                    let model = CoordinatorFindTheRightOrderModel(data: payload)
                                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(model: model)
                                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                                    DnDOneToOneView(viewModel: viewModel)

                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                            }

                        case .memory:
                            switch gameplay {
                                case .associateCategories:
                                    let model = CoordinatorAssociateCategoriesModel(data: payload)
                                    let coordinator = MemoryCoordinatorAssociateCategories(model: model)
                                    let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                                    NewMemoryView(viewModel: viewModel)

                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                            }

                        case .magicCards:
                            switch gameplay {
                                default:
                                    PlaceholderExerciseView()
                            }
                    }
                } else {
                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: nil)
                }
            }

            if case let .specialized(interface) = self.exercise.interface {
                switch interface {
                    default:
                        PlaceholderExerciseView()
                }
            }
        }

        Spacer()
    }

    // MARK: Private

    private let exercise: NewExercise
}

// MARK: - ExerciseInterfaceGameplayNotSupportedView

private struct ExerciseInterfaceGameplayNotSupportedView: View {
    // MARK: Lifecycle

    init(interface: NewExerciseInterface.GeneralInterface, gameplay: NewExerciseGameplay? = nil) {
        log.error("Interface \(interface) and gameplay \(gameplay?.rawValue ?? "empty") combination not supported.")
        self.interface = interface
        self.gameplay = gameplay
    }

    // MARK: Internal

    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.red)

            Text("Interface + Gameplay \n not supported")
                .font(.title)

            Text(
                "Interface: \(self.interface.rawValue) \n Gameplay: \(self.gameplay?.rawValue ?? "empty")"
            )
            .font(.subheadline)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: Private

    private let interface: NewExerciseInterface.GeneralInterface
    private let gameplay: NewExerciseGameplay?
}

#if DEBUG
    #Preview {
        ExerciseInterfaceGameplayNotSupportedView(interface: .dragAndDropGrid, gameplay: .openPlay)
    }
#endif
