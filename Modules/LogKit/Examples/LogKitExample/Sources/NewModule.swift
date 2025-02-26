// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit

public struct NewModule {
    // MARK: Lifecycle

    public init() {
        self.log.info("new module has been initialized")
    }

    // MARK: Public

    public func doSomething() {
        self.log.info("doing something")
    }

    // MARK: Private

    private let log = LogKit.createLoggerFor(module: "NewModule")
}
