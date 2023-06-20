// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

@MainActor
class ConnectionViewModel: ObservableObject {
    @Published public var robotConnectionViewModel = RobotConnectionViewModel()
}
