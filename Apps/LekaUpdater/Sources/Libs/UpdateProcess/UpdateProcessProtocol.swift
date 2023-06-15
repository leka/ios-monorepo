// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

protocol UpdateProcessProtocol {

    var currentState: CurrentValueSubject<UpdateStatusState, UpdateStatusError> { get set }

    func startProcess()

}
