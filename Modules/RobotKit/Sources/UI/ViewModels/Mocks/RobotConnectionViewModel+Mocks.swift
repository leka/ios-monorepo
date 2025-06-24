// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension RobotConnectionViewModel {
    static func mock() -> RobotConnectionViewModel {
        let viewModel = RobotConnectionViewModel()
        viewModel.setRobotDiscoveries([
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
        ])
        return viewModel
    }
}
