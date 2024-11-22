// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventLogin(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        self.logEvent(name: AnalyticsEventLogin, parameters: params)
    }

    func logEventLogout(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        self.logEvent(name: "logout", parameters: params)
    }

    func logEventSignUp(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        self.logEvent(name: AnalyticsEventSignUp, parameters: params)
    }

    func logEventSkipAuthentication(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        self.logEvent(name: "skip_authentication", parameters: params)
    }
}
