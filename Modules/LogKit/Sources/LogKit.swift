// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Logging

public struct LogKit {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Public

    public static func createLoggerFor(module: String) -> Logger {
        self.createLogger(label: "mod:\(module)")
    }

    public static func createLoggerFor(app: String) -> Logger {
        self.createLogger(label: "app:\(app)")
    }

    // MARK: Private

    private static var hasBeenInitialized: Bool = false

    private static func createLogger(label: String) -> Logger {
        if !self.hasBeenInitialized {
            LoggingSystem.bootstrap(LogKitLogHandler.standardOutput)
            self.hasBeenInitialized = true
        }

        let logger = Logger(label: "\(label)")
        return logger
    }
}
