// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit

public struct NewModule {
    // MARK: Lifecycle

    public init() {
        log.info("new module has been initialized")
    }

    // MARK: Public

    public func doSomething() {
        log.info("doing something")
    }

    // MARK: Private

    private let log = LogKit.createLoggerFor(module: "NewModule")
}
