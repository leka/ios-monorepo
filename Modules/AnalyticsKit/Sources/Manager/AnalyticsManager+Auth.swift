// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventLogin() {
        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
    }

    func logEventLogout() {
        Analytics.logEvent("logout", parameters: nil)
    }

    func logEventSignUp() {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
    }

    func logEventSkipAuthentication() {
        Analytics.logEvent("skip_authentication", parameters: nil)
    }
}
