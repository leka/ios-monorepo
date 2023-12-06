// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit

public struct NewModule {
    private let log = LogKit.createLoggerFor(module: "NewModule")

    public init() {
        log.info("new module has been initialized")
    }

    public func doSomething() {
        log.info("doing something")
    }
}
