// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class NewHideAndSeekViewViewModel {
    // MARK: Lifecycle

    init(coordinator: NewHideAndSeekCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Internal

    func triggerLight() {
        self.coordinator.runRandomReinforcer()
    }

    func triggerMotion() {
        self.coordinator.wiggle(for: 1)
    }

    func completeHideAndSeek() {
        self.coordinator.completeHideAndSeek()
    }

    // MARK: Private

    private let coordinator: NewHideAndSeekCoordinator
}
