// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

protocol UpdateProcessProtocol {
    var currentStage: CurrentValueSubject<UpdateProcessStage, UpdateProcessError> { get }
    var sendingFileProgression: CurrentValueSubject<Float, Never> { get }

    func startProcess()
}
