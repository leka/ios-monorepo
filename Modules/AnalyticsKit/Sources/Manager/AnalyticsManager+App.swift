// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventAppUpdateSkip() {
        Analytics.logEvent("app_update_skip", parameters: nil)
    }

    func logEventAppUpdateOpenAppStore() {
        Analytics.logEvent("app_update_open_app_store", parameters: nil)
    }
}
