// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

//
// MARK: - States, events, errors
//

enum UpdateProcessState {
    case initial
}

enum UpdateProcessEvent {
    case startUpdateRequested
}

enum UpdateProcessError: Error {
    case unknown
    case notAvailable
}

//
// MARK: - UpdateProcess
//

protocol UpdateProcessProtocol {
    var currentState: CurrentValueSubject<UpdateProcessState, UpdateProcessError> { get set }

    func startUpdate()
}
