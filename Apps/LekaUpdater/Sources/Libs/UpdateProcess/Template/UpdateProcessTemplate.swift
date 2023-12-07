// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class UpdateProcessTemplate: UpdateProcessProtocol {
    // MARK: Lifecycle

    init() {
        subscribeToStateUpdates()
    }

    // MARK: Public

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)
    public var sendingFileProgression = CurrentValueSubject<Float, Never>(0.0)

    // MARK: Internal

    // MARK: - Internal states, events, errors

    enum UpdateState {
        case initial
        case inProgress
        case success
    }

    enum UpdateEvent {
        case startUpdateRequested
    }

    enum UpdateError: Error {
        case unknown
        case notAvailable
    }

    func startProcess() {
        currentInternalState.send(completion: .failure(.notAvailable))
    }

    // MARK: Private

    // MARK: - Private variables

    private var cancellables: Set<AnyCancellable> = []
    private var currentInternalState = CurrentValueSubject<UpdateState, UpdateError>(.initial)

    private func subscribeToStateUpdates() {
        currentInternalState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: convertCompletion, receiveValue: convertReceivedValue)
            .store(in: &cancellables)
    }

    private func convertCompletion(completion: Subscribers.Completion<UpdateError>) {
        switch completion {
            case .finished:
                currentStage.send(completion: .finished)
            case let .failure(error):
                currentStage.send(completion: .failure(.updateProcessNotAvailable)) // only available error
        }
    }

    private func convertReceivedValue(state _: UpdateState) {
        currentStage.send(.initial) // only available state
    }
}
