// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - States, errors

enum UpdateStatusState {
    case initial

    // LekaOS 1.0.0+
    case sendingUpdate
    case installingUpdate
}

enum UpdateStatusError: Error {
    case unknown
    case updateProcessNotAvailable

    // LekaOS 1.0.0+
    case failedToLoadFile
    case robotNotUpToDate
}

//
// MARK: - StateMachine
//

class UpdateProcessController {
    private var currentStateMachine: any UpdateProcessProtocol

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            case "1.0.0", "1.1.0":
                self.currentStateMachine = UpdateProcessV100(robot: robot)
            default:
                self.currentStateMachine = UpdateProcessUnavailable()
        }
        self.currentState = self.currentStateMachine.userState
    }

    func startUpdate() {
        currentStateMachine.startUpdate()
    }
}

private class UpdateProcessUnavailable: UpdateProcessProtocol {
    private var cancellables: Set<AnyCancellable> = []

    var currentState = CurrentValueSubject<UpdateProcessState, UpdateProcessError>(.initial)
    var userState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init() {
        subscribeToStateUpdate()
    }

    private func subscribeToStateUpdate() {
        self.currentState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.convertCompletion, receiveValue: self.convertReceivedValue)
            .store(in: &cancellables)
    }

    private func convertCompletion(completion: Subscribers.Completion<UpdateProcessError>) {
        switch completion {
            case .finished:
                self.userState.send(completion: .finished)
            case .failure(let error):
                self.userState.send(completion: .failure(.updateProcessNotAvailable))  // only available error
        }
    }

    private func convertReceivedValue(state: UpdateProcessState) {
        self.userState.send(.initial)  // only available state
    }

    func startUpdate() {
        currentState.send(completion: .failure(.notAvailable))
    }
}
