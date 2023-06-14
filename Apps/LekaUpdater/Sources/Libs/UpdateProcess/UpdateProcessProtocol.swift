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

    // LekaOS 1.0.0+
    case loadingUpdateFile
    case settingDestinationPathAndClearFile
    case sendingFile
    case applyingUpdate
    case waitingRobotToReboot
}

enum UpdateProcessEvent {
    case startUpdateRequested

    // LekaOS 1.0.0+
    case fileLoaded, failedToLoadFile
    case destinationPathSet
    case fileSent
    case robotDisconnected
    case robotDetected
}

enum UpdateProcessError: Error {
    case unknown
    case notAvailable

    // LekaOS 1.0.0+
    case failedToLoadFile
    case robotNotUpToDate
}

//
// MARK: - UpdateProcess
//

protocol UpdateProcessProtocol {
    var currentState: CurrentValueSubject<UpdateProcessState, UpdateProcessError> { get set }

    func startUpdate()
}
