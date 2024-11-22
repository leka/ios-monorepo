// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func logEventLogin(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.login, parameters: params)
    }

    static func logEventLogout(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.logout, parameters: params)
    }

    static func logEventSignUp(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.signup, parameters: params)
    }

    static func logEventSkipAuthentication(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.skipAuthentication, parameters: params)
    }

    static func logEventAccountDelete(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.accountDelete, parameters: params)
    }

    static func setUserPropertyUserIsLoggedIn(value: Bool) {
        setUserProperty(value: value.description, name: "user_is_logged_in")
    }
}
