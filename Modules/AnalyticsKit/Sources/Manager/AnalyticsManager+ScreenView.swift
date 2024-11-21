// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventScreenView(screenName: String, screenClass: String? = nil) {
        var params: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
        ]

        if let screenClass {
            params[AnalyticsParameterScreenClass] = screenClass
        }

        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
    }
}
