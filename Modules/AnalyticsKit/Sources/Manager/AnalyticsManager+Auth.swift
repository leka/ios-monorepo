// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventLogin(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Analytics.logEvent(AnalyticsEventLogin, parameters: params)
    }

    func logEventLogout(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Analytics.logEvent("logout", parameters: params)
    }

    func logEventSignUp(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Analytics.logEvent(AnalyticsEventSignUp, parameters: params)
    }

    func logEventSkipAuthentication(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Analytics.logEvent("skip_authentication", parameters: params)
    }
}
