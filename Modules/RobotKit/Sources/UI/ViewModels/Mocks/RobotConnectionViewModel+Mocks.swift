// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension RobotConnectionViewModel {
    static func mock() -> RobotConnectionViewModel {
        let viewModel = RobotConnectionViewModel()
        viewModel.robotDiscoveries = [
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
            .mock(),
        ]
        return viewModel
    }
}
