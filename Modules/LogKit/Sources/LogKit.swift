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
        createLogger(label: "mod:\(module)")
    }

    public static func createLoggerFor(app: String) -> Logger {
        createLogger(label: "app:\(app)")
    }

    // MARK: Private

    private static var hasBeenInitialized: Bool = false

    private static func createLogger(label: String) -> Logger {
        if !hasBeenInitialized {
            LoggingSystem.bootstrap(LogKitLogHandler.standardOutput)
            hasBeenInitialized = true
        }

        let logger = Logger(label: "\(label)")
        return logger
    }
}
