// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Logging

public struct LogKit {

    private static var hasBeenInitialized: Bool = false

    private init() {
        // nothing to do
    }

    static public func createLoggerFor(module: String) -> Logger {
        createLogger(label: "mod:\(module)")
    }

    static public func createLoggerFor(app: String) -> Logger {
        createLogger(label: "app:\(app)")
    }

    static private func createLogger(label: String) -> Logger {
        if !hasBeenInitialized {
            LoggingSystem.bootstrap(LogKitLogHandler.standardOutput)
            hasBeenInitialized = true
        }

        let logger = Logger(label: "\(label)")
        return logger
    }

}
