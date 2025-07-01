// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - ExerciseCoordinator

public class CurrentExerciseCoordinator {
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

            if case let .general(interface) = self.exercise.interface {
                if let gameplay = self.exercise.gameplay, let payload = self.exercise.payload {
                    switch interface {
                        case .touchToSelect:
                            switch gameplay {
                                case .associateCategories:
                                    let model = CoordinatorAssociateCategoriesModel(data: payload)
                                    let coordinator = TTSCoordinatorAssociateCategories(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                                    TTSView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] completionData in
                                                    self?.didComplete.send(completionData)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                case .findTheRightAnswers:
                                    let model = CoordinatorFindTheRightAnswersModel(data: payload)
                                    let coordinator = TTSCoordinatorFindTheRightAnswers(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                                    TTSView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] completionData in
                                                    self?.didComplete.send(completionData)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                case .findTheRightOrder:
                                    let model = CoordinatorFindTheRightOrderModel(data: payload)
                                    let coordinator = TTSCoordinatorFindTheRightOrder(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                                    TTSView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] completionData in
                                                    self?.didComplete.send(completionData)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                case .openPlay:
                                    let model = CoordinatorOpenPlayModel(data: payload)
                                    let coordinator = TTSCoordinatorOpenPlay(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = TTSViewViewModel(coordinator: coordinator)

                                    TTSView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                        case .dragAndDropGrid:
                            switch gameplay {
                                case .associateCategories:
                                    let model = CoordinatorAssociateCategoriesModel(data: payload)
                                    let coordinator = DnDGridCoordinatorAssociateCategories(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = DnDGridViewModel(coordinator: coordinator)

                                    DnDGridView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }

                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                        case .dragAndDropGridWithZones:
                            switch gameplay {
                                case .associateCategories:
                                    let model = CoordinatorAssociateCategoriesModel(data: payload)
                                    let coordinator = DnDGridWithZonesCoordinatorAssociateCategories(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                                    DnDGridWithZonesView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }

                                case .openPlay:
                                    let model = CoordinatorOpenPlayModel(data: payload)
                                    let coordinator = DnDGridWithZonesCoordinatorOpenPlay(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = DnDGridWithZonesViewModel(coordinator: coordinator)

                                    DnDGridWithZonesView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }

                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                        case .dragAndDropOneToOne:
                            switch gameplay {
                                case .findTheRightOrder:
                                    let model = CoordinatorFindTheRightOrderModel(data: payload)
                                    let coordinator = DnDOneToOneCoordinatorFindTheRightOrder(
                                        model: model,
                                        action: exercise.action,
                                        options: self.exercise.options
                                    )
                                    let viewModel = DnDOneToOneViewModel(coordinator: coordinator)

                                    DnDOneToOneView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                        case .memory:
                            switch gameplay {
                                case .associateCategories:
                                    let model = CoordinatorAssociateCategoriesModel(data: payload)
                                    let coordinator = MemoryCoordinatorAssociateCategories(
                                        model: model,
                                        options: exercise.options
                                    )
                                    let viewModel = NewMemoryViewViewModel(coordinator: coordinator)

                                    NewMemoryView(viewModel: viewModel)
                                        .onAppear {
                                            coordinator.didComplete
                                                .receive(on: DispatchQueue.main)
                                                .sink { [weak self] in
                                                    self?.didComplete.send(nil)
                                                }
                                                .store(in: &self.cancellables)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                default:
                                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: gameplay)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                        case .magicCards:
                            switch gameplay {
                                default:
                                    ExercisePlaceholderView()
                            }
                    }
                } else {
                    ExerciseInterfaceGameplayNotSupportedView(interface: interface, gameplay: nil)
                }
            }

            if case let .specialized(interface) = self.exercise.interface,
               let payload = self.exercise.payload
            {
                switch interface {
                    case .pairing:
                        DiscoverLekaView()
                    case .danceFreeze:
                        let model = NewDanceFreezeModel(data: payload)
                        let coordinator = NewDanceFreezeCoordinator(model: model)
                        let viewModel = NewDanceFreezeViewViewModel(coordinator: coordinator)
                        NewDanceFreezeView(viewModel: viewModel)
                            .onAppear {
                                coordinator.didComplete
                                    .receive(on: DispatchQueue.main)
                                    .sink { [weak self] in
                                        self?.didComplete.send(nil)
                                    }
                                    .store(in: &self.cancellables)
                            }
                    case .hideAndSeek:
                        let coordinator = NewHideAndSeekCoordinator()
                        let viewModel = NewHideAndSeekViewViewModel(coordinator: coordinator)

                        NewHideAndSeekView(viewModel: viewModel)
                            .onAppear {
                                coordinator.didComplete
                                    .receive(on: DispatchQueue.main)
                                    .sink { [weak self] in
                                        self?.didComplete.send(nil)
                                    }
                                    .store(in: &self.cancellables)
                            }
                    case .musicalInstruments:
                        let model = MusicalInstrumentModel(data: payload)
                        MusicalInstrumentView(model: model)
                    case .melody:
                        let model = NewMelodyModel(data: payload)
                        let coordinator = NewMelodyCoordinator(model: model)
                        let viewModel = NewMelodyViewViewModel(coordinator: coordinator)
                        NewMelodyView(viewModel: viewModel)
                            .onAppear {
                                coordinator.didComplete
                                    .receive(on: DispatchQueue.main)
                                    .sink { [weak self] in
                                        self?.didComplete.send(nil)
                                    }
                                    .store(in: &self.cancellables)
                            }
                    case .gamepadJoyStickColorPad:
                        Gamepad.Joystick()
                    case .gamepadArrowPadColorPad:
                        Gamepad.ArrowPadColorPad()
                    case .gamepadColorPad:
                        Gamepad.ColorPadView()
                    case .gamepadArrowPad:
                        ArrowPadView(size: 200, xPosition: 180)
                    case .colorMusicPad:
                        ColorMusicPad()
                    case .colorMediator:
                        ColorMediatorView()
                    case .superSimon:
                        let model = NewSuperSimonModel(data: payload)
                        let coordinator = NewSuperSimonCoordinator(model: model)
                        let viewModel = NewSuperSimonViewViewModel(coordinator: coordinator)
                        NewSuperSimonView(viewModel: viewModel)
                            .onAppear {
                                coordinator.didComplete
                                    .receive(on: DispatchQueue.main)
                                    .sink { [weak self] in
                                        self?.didComplete.send(nil)
                                    }
                                    .store(in: &self.cancellables)
                            }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Internal

    var cancellables = Set<AnyCancellable>()

    var didComplete: PassthroughSubject<ExerciseCompletionData?, Never> = .init()

    // MARK: Private

    private let exercise: NewExercise
}
