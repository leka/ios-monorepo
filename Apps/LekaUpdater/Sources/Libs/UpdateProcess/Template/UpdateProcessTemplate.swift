// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class UpdateProcessTemplate: UpdateProcessProtocol {

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

    // MARK: - Private variables

    private var cancellables: Set<AnyCancellable> = []
    private var currentInternalState = CurrentValueSubject<UpdateState, UpdateError>(.initial)

    // MARK: - Public variables

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init() {
        subscribeToStateUpdate()
    }

    private func subscribeToStateUpdate() {
        self.currentInternalState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.convertCompletion, receiveValue: self.convertReceivedValue)
            .store(in: &cancellables)
    }

    private func convertCompletion(completion: Subscribers.Completion<UpdateError>) {
        switch completion {
            case .finished:
                self.currentState.send(completion: .finished)
            case .failure(let error):
                self.currentState.send(completion: .failure(.updateProcessNotAvailable))  // only available error
        }
    }

    private func convertReceivedValue(state: UpdateState) {
        self.currentState.send(.initial)  // only available state
    }

    func startProcess() {
        currentInternalState.send(completion: .failure(.notAvailable))
    }
}
