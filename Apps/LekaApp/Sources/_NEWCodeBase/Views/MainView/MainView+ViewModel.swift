// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

extension MainView {
    class ViewModel: ObservableObject {
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

        @Published var isDesignSystemAppleExpanded: Bool = false
        @Published var isDesignSystemLekaExpanded: Bool = false

        @Published var isRobotConnect: Bool = false

        // MARK: Private

        private var cancellables: Set<AnyCancellable> = []
    }
}
