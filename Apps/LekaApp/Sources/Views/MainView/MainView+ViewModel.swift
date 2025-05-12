// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

extension MainView {
    @Observable
    class ViewModel {
        // MARK: Lifecycle

        init() {
            Robot.shared.isConnected
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isConnected in
                    guard let self else { return }
                    self.isRobotConnect = isConnected
                }
                .store(in: &self.cancellables)
        }

        // MARK: Internal

        var isDesignSystemAppleExpanded: Bool = false
        var isDesignSystemLekaExpanded: Bool = false
        var isRobotConnect: Bool = false

        // MARK: Private

        @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    }
}
