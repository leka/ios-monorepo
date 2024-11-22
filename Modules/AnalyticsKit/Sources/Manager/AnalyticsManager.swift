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

    // MARK: Internal

    static func logEvent(name: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
