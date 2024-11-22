// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func logEventLogin(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Self.logEvent(name: AnalyticsEventLogin, parameters: params)
    }

    static func logEventLogout(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Self.logEvent(name: "logout", parameters: params)
    }

    static func logEventSignUp(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Self.logEvent(name: AnalyticsEventSignUp, parameters: params)
    }

    static func logEventSkipAuthentication(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Self.logEvent(name: "skip_authentication", parameters: params)
    }
}
