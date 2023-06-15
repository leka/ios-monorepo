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
    private var cancellables: Set<AnyCancellable> = []

    public var currentState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let currentRobotVersion = robot.osVersion

        switch currentRobotVersion {
            case "1.0.0", "1.1.0":
                self.currentStateMachine = UpdateProcessV100(robot: robot)
            default:
                self.currentStateMachine = UpdateProcessUnavailable()
        }

        subscribeToStateUpdate()
    }

    func startUpdate() {
        currentStateMachine.startUpdate()
    }

    private func subscribeToStateUpdate() {
        self.currentStateMachine.currentState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.convertCompletion, receiveValue: self.convertReceivedValue)
            .store(in: &cancellables)
    }

    private func convertCompletion(completion: Subscribers.Completion<UpdateProcessError>) {
        switch completion {
            case .finished:
                self.currentState.send(completion: .finished)
            case .failure(let error):
                var result: UpdateStatusError = .unknown
                switch error {
                    case .failedToLoadFile:
                        result = .failedToLoadFile
                    case .robotNotUpToDate:
                        result = .robotNotUpToDate
                    case .notAvailable:
                        result = .updateProcessNotAvailable
                    default:
                        result = .unknown
                }
                self.currentState.send(completion: .failure(result))

        }
    }

    private func convertReceivedValue(state: UpdateProcessState) {
        var result: UpdateStatusState = .initial
        switch state {
            case .initial:
                result = .initial
            case .loadingUpdateFile, .settingDestinationPathAndClearFile, .sendingFile:
                result = .sendingUpdate
            case .applyingUpdate, .waitingRobotToReboot:
                result = .installingUpdate
        }
        self.currentState.send(result)
    }
}

private class UpdateProcessUnavailable: UpdateProcessProtocol {
    var currentState = CurrentValueSubject<UpdateProcessState, UpdateProcessError>(.initial)

    func startUpdate() {
        currentState.send(completion: .failure(.notAvailable))
    }
}
