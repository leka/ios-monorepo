// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

protocol UpdateProcessProtocol {

    var currentStage: CurrentValueSubject<UpdateProcessStage, UpdateProcessError> { get set }

    func startProcess()

}
