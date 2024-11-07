// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAnalytics

public class AnalyticsManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public static let shared = AnalyticsManager()

    // MARK: Public Methods

    public func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }

    public func logEventScreenView(screenName: String, screenClass: String? = nil) {
        var params: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
        ]

        if let screenClass {
            params[AnalyticsParameterScreenClass] = screenClass
        }

        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
    }

    public func setDefaultEventParameters(_ parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }

    public func clearDefaultEventParameters() {
        self.setDefaultEventParameters(nil)
    }

    // Recommended events methods

    public func logEventLogin() {
        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
    }

    public func logEventLogout() {
        Analytics.logEvent("logout", parameters: nil)
    }

    public func logEventSignUp() {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
    }
}
